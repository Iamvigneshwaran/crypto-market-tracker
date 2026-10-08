require('dotenv').config();

module.exports = {
  port: process.env.PORT || 3000,
  apiKey: process.env.COINGECKO_API_KEY || '',
  baseUrl: process.env.COINGECKO_BASE_URL || 'https://api.coingecko.com/api/v3',
  timeoutMs: 8000,
  ttl: {
    markets: 60_000,
    detail: 120_000,
    chart: 120_000,
    stats: 60_000,
  },
};