
const express = require('express');
const router = express.Router();
const pool = require('../config/database');


// ======================================
// 1. GET - Menampilkan semua jenis layanan
// ======================================
router.get('/', async (req, res) => {
    try {
        const result = await pool.query(
            'SELECT * FROM jenis_layanan ORDER BY id_layanan ASC'
        );

        res.status(200).json({
            message: 'Berhasil mengambil semua data layanan',
            data: result.rows
        });

    } catch (error) {
        res.status(500).json({
            message: 'Terjadi kesalahan server',
            error: error.message
        });
    }
});


// ======================================
// 2. GET - Menampilkan layanan berdasarkan ID
// ======================================
router.get('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        if (!/^[1-9]\d*$/.test(id)) {
            return res.status(400).json({
                message: 'ID layanan tidak valid'
            });
        }

        const result = await pool.query(
            'SELECT * FROM jenis_layanan WHERE id_layanan = $1',
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Data layanan tidak ditemukan'
            });
        }

        res.status(200).json({
            message: 'Berhasil mengambil data layanan',
            data: result.rows[0]
        });

    } catch (error) {
        res.status(500).json({
            message: 'Terjadi kesalahan server',
            error: error.message
        });
    }
});


// ======================================
// 3. POST - Menambahkan jenis layanan
// ======================================
router.post('/', async (req, res) => {
    try {
        const {
            nama_layanan,
            deskripsi,
            satuan
        } = req.body;

        if (!nama_layanan || !nama_layanan.trim()) {
            return res.status(400).json({
                message: 'Nama layanan wajib diisi'
            });
        }

        const result = await pool.query(
            `INSERT INTO jenis_layanan
            (nama_layanan, deskripsi, satuan)
            VALUES ($1, $2, $3)
            RETURNING *`,
            [
                nama_layanan.trim(),
                deskripsi || null,
                satuan || null
            ]
        );

        res.status(201).json({
            message: 'Data layanan berhasil ditambahkan',
            data: result.rows[0]
        });

    } catch (error) {
        if (error.code === '23505') {
            return res.status(409).json({
                message: 'Nama layanan sudah terdaftar'
            });
        }

        res.status(500).json({
            message: 'Terjadi kesalahan server',
            error: error.message
        });
    }
});


// ======================================
// 4. PUT - Memperbarui jenis layanan
// ======================================
router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const {
            nama_layanan,
            deskripsi,
            satuan
        } = req.body;

        if (!/^[1-9]\d*$/.test(id)) {
            return res.status(400).json({
                message: 'ID layanan tidak valid'
            });
        }

        if (!nama_layanan || !nama_layanan.trim()) {
            return res.status(400).json({
                message: 'Nama layanan wajib diisi'
            });
        }

        const result = await pool.query(
            `UPDATE jenis_layanan
            SET nama_layanan = $1,
                deskripsi = $2,
                satuan = $3
            WHERE id_layanan = $4
            RETURNING *`,
            [
                nama_layanan.trim(),
                deskripsi || null,
                satuan || null,
                id
            ]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Data layanan tidak ditemukan'
            });
        }

        res.status(200).json({
            message: 'Data layanan berhasil diperbarui',
            data: result.rows[0]
        });

    } catch (error) {
        if (error.code === '23505') {
            return res.status(409).json({
                message: 'Nama layanan sudah digunakan'
            });
        }

        res.status(500).json({
            message: 'Terjadi kesalahan server',
            error: error.message
        });
    }
});


// ======================================
// 5. DELETE - Menghapus jenis layanan
// ======================================
router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        if (!/^[1-9]\d*$/.test(id)) {
            return res.status(400).json({
                message: 'ID layanan tidak valid'
            });
        }

        const result = await pool.query(
            `DELETE FROM jenis_layanan
            WHERE id_layanan = $1
            RETURNING *`,
            [id]
        );

        if (result.rows.length === 0) {
            return res.status(404).json({
                message: 'Data layanan tidak ditemukan'
            });
        }

        res.status(200).json({
            message: 'Data layanan berhasil dihapus',
            data: result.rows[0]
        });

    } catch (error) {
        if (error.code === '23503') {
            return res.status(409).json({
                message: 'Layanan tidak dapat dihapus karena sudah digunakan dalam pemeriksaan'
            });
        }

        res.status(500).json({
            message: 'Terjadi kesalahan server',
            error: error.message
        });
    }
});


module.exports = router;
