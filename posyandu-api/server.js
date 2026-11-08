
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Import routes
const layananRoutes = require('./routes/layananRoutes');

// Route utama
app.get('/', (req, res) => {
    res.json({
        message: 'REST API Sistem Informasi Posyandu Desa Berhasil Berjalan'
    });
});

// Route jenis layanan
app.use('/api/layanan', layananRoutes);

// Menjalankan server
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});
