// Values from the coingecko.com screenshots (BTC, ETH, global stats, trending).
// Other coins are approximate sample data.
const seeds = [
  { id: 'bitcoin', symbol: 'btc', name: 'Bitcoin', price: 84182.35, mc: 1_691_652_241_224, vol: 31_768_645_347,
    pct: -1.7, high: 86648.14, low: 83647.88, circ: 20_094_000, total: 20_095_000, max: 21_000_000, ath: 126000 },
  { id: 'ethereum', symbol: 'eth', name: 'Ethereum', price: 2615.01, mc: 319_326_715_252, vol: 15_190_658_408,
    pct: -3.3, circ: 122_120_000, total: 122_120_000, max: null, ath: 4950 },
  { id: 'tether', symbol: 'usdt', name: 'Tether', price: 1.0, mc: 185_000_000_000, vol: 60_000_000_000,
    pct: 0.0, circ: 185_000_000_000, total: 185_000_000_000, max: null, ath: 1.32 },
  { id: 'binancecoin', symbol: 'bnb', name: 'BNB', price: 610, mc: 88_000_000_000, vol: 1_400_000_000,
    pct: -1.2, circ: 144_000_000, total: 144_000_000, max: 200_000_000, ath: 1370 },
  { id: 'ripple', symbol: 'xrp', name: 'XRP', price: 2.05, mc: 120_000_000_000, vol: 3_200_000_000,
    pct: -2.4, circ: 58_000_000_000, total: 99_986_000_000, max: 100_000_000_000, ath: 3.65 },
  { id: 'solana', symbol: 'sol', name: 'Solana', price: 138, mc: 75_000_000_000, vol: 4_100_000_000,
    pct: -4.1, circ: 545_000_000, total: 610_000_000, max: null, ath: 293 },
  { id: 'dogecoin', symbol: 'doge', name: 'Dogecoin', price: 0.17, mc: 25_500_000_000, vol: 1_300_000_000,
    pct: 2.6, circ: 150_000_000_000, total: 150_000_000_000, max: null, ath: 0.73 },
  { id: 'cardano', symbol: 'ada', name: 'Cardano', price: 0.52, mc: 19_000_000_000, vol: 520_000_000,
    pct: -0.8, circ: 36_500_000_000, total: 45_000_000_000, max: 45_000_000_000, ath: 3.09 },
];

// Seeded RNG so the fake charts stay the same on every call
function rng(seed) {
  let h = 0;
  for (const ch of seed) h = (h * 31 + ch.charCodeAt(0)) >>> 0;
  return () => {
    h = (h + 0x6d2b79f5) | 0;
    let t = Math.imul(h ^ (h >>> 15), 1 | h);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

// Random walk that ends at endPrice
function series(seed, endPrice, points, volatility) {
  const r = rng(seed);
  const out = [endPrice];
  for (let i = 1; i < points; i++) {
    out.unshift(out[0] * (1 + (r() - 0.5) * 2 * volatility));
  }
  return out;
}

const build = (s, rank) => ({
  id: s.id,
  symbol: s.symbol,
  name: s.name,
  image: null, // Flutter la placeholder icon kaattunga
  currentPrice: s.price,
  marketCap: s.mc,
  marketCapRank: rank,
  totalVolume: s.vol,
  high24h: s.high ?? s.price * 1.02,
  low24h: s.low ?? s.price * 0.98,
  priceChange24h: (s.price * s.pct) / 100,
  priceChangePercentage24h: s.pct,
  circulatingSupply: s.circ,
  totalSupply: s.total,
  maxSupply: s.max,
  ath: s.ath,
  athChangePercentage: (s.price / s.ath - 1) * 100,
  sparkline7d: series(s.id + '7d', s.price, 168, s.id === 'tether' ? 0.0002 : 0.006),
});

exports.markets = () => seeds.map((s, i) => build(s, i + 1));

exports.detail = (id) => {
  const coin = exports.markets().find((c) => c.id === id);
  if (!coin) return null;
  const { sparkline7d, ...rest } = coin;
  return {
    ...rest,
    description: `${coin.name} sample data. Live API unavailable, so fallback data is shown.`,
    homepage: null,
    categories: [],
    genesisDate: null,
    priceChangePercentage7d: null,
    priceChangePercentage30d: null,
    athDate: null,
    atl: null,
    atlDate: null,
  };
};

exports.chart = (id, days) => {
  const coin = seeds.find((s) => s.id === id);
  if (!coin) return null;
  const points = days === 1 ? 96 : days === 7 ? 168 : 120;
  const step = (days * 86_400_000) / points;
  const now = Date.now();
  const prices = series(`${id}-${days}`, coin.price, points, 0.004 + days / 8000);
  return prices.map((p, i) => ({ t: Math.round(now - (points - 1 - i) * step), p }));
};

exports.stats = () => ({
  totalMarketCap: 2_957_000_000_000,
  totalVolume: 89_044_000_000,
  marketCapChangePercentage24h: -1.8,
  btcDominance: 57.2,
  ethDominance: 10.8,
  activeCryptocurrencies: 21966,
  markets: 1507,
  trending: [
    { id: 'bitcoin', name: 'Bitcoin', symbol: 'btc', image: null, marketCapRank: 1, price: 84178.82, priceChangePercentage24h: -1.5 },
    { id: 'orca', name: 'Orca', symbol: 'orca', image: null, marketCapRank: null, price: 2.9, priceChangePercentage24h: 23.5 },
    { id: 'near', name: 'NEAR Protocol', symbol: 'near', image: null, marketCapRank: null, price: 4.97, priceChangePercentage24h: -5.4 },
    { id: 'pons', name: 'Pons', symbol: 'pons', image: null, marketCapRank: null, price: 0.4102, priceChangePercentage24h: 8.2 },
    { id: 'backpack', name: 'Backpack', symbol: 'bp', image: null, marketCapRank: null, price: 1.1, priceChangePercentage24h: -10.6 },
  ],
});