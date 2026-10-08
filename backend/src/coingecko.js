const { baseUrl, apiKey, timeoutMs } = require('./config');

async function cg(path, params = {}) {
  const url = new URL(baseUrl + path);
  Object.entries(params).forEach(([k, v]) => url.searchParams.set(k, v));

  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), timeoutMs);
  try {
    const res = await fetch(url, {
      headers: { accept: 'application/json', 'x-cg-demo-api-key': apiKey },
      signal: ctrl.signal,
    });
    if (!res.ok) {
      const err = new Error(`CoinGecko responded ${res.status}`);
      err.status = res.status;
      throw err;
    }
    return await res.json();
  } finally {
    clearTimeout(timer);
  }
}

const mapMarket = (c) => ({
  id: c.id,
  symbol: c.symbol,
  name: c.name,
  image: c.image,
  currentPrice: c.current_price,
  marketCap: c.market_cap,
  marketCapRank: c.market_cap_rank,
  totalVolume: c.total_volume,
  high24h: c.high_24h,
  low24h: c.low_24h,
  priceChange24h: c.price_change_24h,
  priceChangePercentage24h: c.price_change_percentage_24h,
  circulatingSupply: c.circulating_supply,
  totalSupply: c.total_supply,
  maxSupply: c.max_supply,
  ath: c.ath,
  athChangePercentage: c.ath_change_percentage,
  sparkline7d: c.sparkline_in_7d?.price ?? [],
});

const marketParams = { vs_currency: 'usd', order: 'market_cap_desc', sparkline: true, price_change_percentage: '24h' };

exports.fetchMarkets = async () =>
  (await cg('/coins/markets', { ...marketParams, per_page: 100, page: 1 })).map(mapMarket);

exports.fetchMarketsByIds = async (ids) =>
  (await cg('/coins/markets', { ...marketParams, ids: ids.join(',') })).map(mapMarket);

exports.fetchDetail = async (id) => {
  const d = await cg(`/coins/${id}`, {
    localization: false, tickers: false, community_data: false, developer_data: false,
  });
  const m = d.market_data || {};
  return {
    id: d.id,
    symbol: d.symbol,
    name: d.name,
    image: d.image?.large,
    description: d.description?.en || '',
    homepage: d.links?.homepage?.[0] || null,
    categories: d.categories || [],
    genesisDate: d.genesis_date || null,
    marketCapRank: d.market_cap_rank,
    currentPrice: m.current_price?.usd,
    marketCap: m.market_cap?.usd,
    totalVolume: m.total_volume?.usd,
    high24h: m.high_24h?.usd,
    low24h: m.low_24h?.usd,
    priceChangePercentage24h: m.price_change_percentage_24h,
    priceChangePercentage7d: m.price_change_percentage_7d,
    priceChangePercentage30d: m.price_change_percentage_30d,
    circulatingSupply: m.circulating_supply,
    totalSupply: m.total_supply,
    maxSupply: m.max_supply,
    ath: m.ath?.usd,
    athDate: m.ath_date?.usd,
    atl: m.atl?.usd,
    atlDate: m.atl_date?.usd,
  };
};

exports.fetchChart = async (id, days) => {
  const d = await cg(`/coins/${id}/market_chart`, { vs_currency: 'usd', days });
  return d.prices.map(([t, p]) => ({ t, p }));
};

exports.fetchStats = async () => {
  const [global, trending] = await Promise.all([cg('/global'), cg('/search/trending')]);
  const g = global.data || {};
  return {
    totalMarketCap: g.total_market_cap?.usd,
    totalVolume: g.total_volume?.usd,
    marketCapChangePercentage24h: g.market_cap_change_percentage_24h_usd,
    btcDominance: g.market_cap_percentage?.btc,
    ethDominance: g.market_cap_percentage?.eth,
    activeCryptocurrencies: g.active_cryptocurrencies,
    markets: g.markets,
    trending: (trending.coins || []).slice(0, 5).map(({ item }) => ({
      id: item.id,
      name: item.name,
      symbol: item.symbol,
      image: item.thumb,
      marketCapRank: item.market_cap_rank,
      price: Number(item.data?.price) || null,
      priceChangePercentage24h: item.data?.price_change_percentage_24h?.usd ?? null,
    })),
  };
};