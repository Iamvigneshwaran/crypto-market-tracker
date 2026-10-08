const express = require('express');
const svc = require('./service');

const router = express.Router();

const SORT_KEYS = {
  market_cap: 'marketCap',
  price: 'currentPrice',
  volume: 'totalVolume',
  change_24h: 'priceChangePercentage24h',
  name: 'name',
};
const DAYS = [1, 7, 30, 90, 365];
const ID_RE = /^[a-z0-9-]+$/;

router.get('/health', (req, res) => res.json({ status: 'ok' }));

// GET /api/coins?q=bit&sort=price&order=desc&filter=gainers&page=1&perPage=20
router.get('/coins', async (req, res, next) => {
  try {
    const q = String(req.query.q || '').trim().toLowerCase();
    const sortKey = SORT_KEYS[req.query.sort] || 'marketCap';
    const dir = req.query.order === 'asc' ? 1 : -1;
    const filter = req.query.filter || 'all';
    const page = Math.max(1, parseInt(req.query.page) || 1);
    const perPage = Math.min(100, Math.max(1, parseInt(req.query.perPage) || 20));

    const { data, source } = await svc.getMarkets();

    let list = data.filter(
      (c) => !q || c.name.toLowerCase().includes(q) || c.symbol.toLowerCase().includes(q)
    );
    if (filter === 'gainers') list = list.filter((c) => c.priceChangePercentage24h > 0);
    if (filter === 'losers') list = list.filter((c) => c.priceChangePercentage24h < 0);

    list.sort((a, b) => {
      const x = a[sortKey], y = b[sortKey];
      const cmp = typeof x === 'string' ? x.localeCompare(y) : (x ?? 0) - (y ?? 0);
      return dir * cmp;
    });

    res.json({
      source, page, perPage, total: list.length,
      data: list.slice((page - 1) * perPage, page * perPage),
    });
  } catch (e) { next(e); }
});

// GET /api/watchlist?ids=bitcoin,ethereum
router.get('/watchlist', async (req, res, next) => {
  try {
    const ids = String(req.query.ids || '').split(',').map((s) => s.trim()).filter((s) => ID_RE.test(s)).slice(0, 50);
    if (!ids.length) return res.json({ source: 'none', data: [] });
    const { data, source } = await svc.getMarketsByIds(ids);
    res.json({ source, data });
  } catch (e) { next(e); }
});

router.get('/stats', async (req, res, next) => {
  try { res.json(await svc.getStats()); } catch (e) { next(e); }
});

router.get('/coins/:id', async (req, res, next) => {
  try {
    if (!ID_RE.test(req.params.id)) return res.status(400).json({ error: 'Invalid coin id' });
    const { data, source } = await svc.getDetail(req.params.id);
    res.json({ source, data });
  } catch (e) { next(e); }
});

// GET /api/coins/bitcoin/chart?days=7  (1, 7, 30, 90, 365)
router.get('/coins/:id/chart', async (req, res, next) => {
  try {
    const days = parseInt(req.query.days) || 7;
    if (!ID_RE.test(req.params.id) || !DAYS.includes(days)) {
      return res.status(400).json({ error: `days must be one of ${DAYS.join(', ')}` });
    }
    const { data, source } = await svc.getChart(req.params.id, days);
    res.json({ source, days, data });
  } catch (e) { next(e); }
});

module.exports = router;