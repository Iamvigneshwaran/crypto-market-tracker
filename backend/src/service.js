const cache = require('./cache');
const cg = require('./coingecko');
const fb = require('./fallback');
const { ttl } = require('./config');

const ORDER = ['live', 'cache', 'stale', 'fallback'];
const worst = (...s) => s.reduce((a, b) => (ORDER.indexOf(b) > ORDER.indexOf(a) ? b : a));

// cache -> live API -> stale cache -> fallback data
async function withFallback(key, ttlMs, fetcher, fallbackFn) {
  const hit = cache.get(key);
  if (hit && hit.exp > Date.now()) return { data: hit.data, source: 'cache' };
  try {
    const data = await fetcher();
    cache.set(key, data, ttlMs);
    return { data, source: 'live' };
  } catch (err) {
    if (err.status === 404) throw err; // unknown coin id: fallback venaam
    console.warn(`[fallback] ${key}: ${err.message}`);
    if (hit) return { data: hit.data, source: 'stale' };
    return { data: fallbackFn(), source: 'fallback' };
  }
}

const notFound = () => Object.assign(new Error('Coin not found'), { status: 404 });

exports.getMarkets = () => withFallback('markets', ttl.markets, cg.fetchMarkets, fb.markets);

exports.getMarketsByIds = (ids) =>
  withFallback(`ids:${[...ids].sort()}`, ttl.markets, () => cg.fetchMarketsByIds(ids),
    () => fb.markets().filter((c) => ids.includes(c.id)));

exports.getDetail = (id) =>
  withFallback(`detail:${id}`, ttl.detail, () => cg.fetchDetail(id), () => {
    const d = fb.detail(id);
    if (!d) throw notFound();
    return d;
  });

exports.getChart = (id, days) =>
  withFallback(`chart:${id}:${days}`, ttl.chart, () => cg.fetchChart(id, days), () => {
    const c = fb.chart(id, days);
    if (!c) throw notFound();
    return c;
  });

exports.getStats = async () => {
  const stats = await withFallback('stats', ttl.stats, cg.fetchStats, fb.stats);
  const markets = await exports.getMarkets();

  const sorted = markets.data
    .filter((c) => c.priceChangePercentage24h != null)
    .sort((a, b) => b.priceChangePercentage24h - a.priceChangePercentage24h);
  const slim = (c) => ({
    id: c.id, name: c.name, symbol: c.symbol, image: c.image,
    currentPrice: c.currentPrice, priceChangePercentage24h: c.priceChangePercentage24h,
  });

  return {
    source: worst(stats.source, markets.source),
    data: {
      ...stats.data,
      topGainers: sorted.slice(0, 5).map(slim),
      topLosers: sorted.slice(-5).reverse().map(slim),
    },
  };
};