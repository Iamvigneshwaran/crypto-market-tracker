const store = new Map();

exports.get = (key) => store.get(key);
exports.set = (key, data, ttlMs) => store.set(key, { data, exp: Date.now() + ttlMs });