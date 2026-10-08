const express = require('express');
const cors = require('cors');
const { port } = require('./config');
const routes = require('./routes');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api', routes);

app.use((req, res) => res.status(404).json({ error: 'Route not found' }));

app.use((err, req, res, next) => {
  const status = err.status === 404 ? 404 : 500;
  if (status === 500) console.error(err);
  res.status(status).json({ error: status === 404 ? 'Not found' : 'Something went wrong' });
});

// app.listen(port, () => console.log(`API running on http://localhost:${port}`));
app.listen(port, '0.0.0.0', () => console.log(`API running on port ${port}`));