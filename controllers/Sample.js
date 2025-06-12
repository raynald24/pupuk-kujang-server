import Sample from "../models/SampleModel.js";
import User from "../models/UserModel.js";
import namaBahan from "../models/namaBahan.js"; // Import namaBahan model
import { Op } from "sequelize";
// Get All Samples
export const getSamples = async (req, res) => {
    try {
        const response = await Sample.findAll({
            attributes: ['uuid', 'namaUnitPemohon', 'tanggalSurat', 'nomorPO', 'nomorSurat', 'status', 'noKendaraan', 'isiBerat', 'jumlahContoh', 'noKodeContoh', 'noSuratPOK', 'namaBahanId'],
            include: [
                { model: User, attributes: ['name', 'email'] },
                { model: namaBahan, attributes: ['namaBahan'] }
            ]
        });
        res.status(200).json(response);
    } catch (error) {
        console.error("Error fetching samples:", error);
        res.status(500).json({ msg: error.message });
    }
};

export const getSampleById = async (req, res) => {
    try {
        const sample = await Sample.findOne({
            attributes: ['uuid', 'namaUnitPemohon', 'tanggalSurat', 'nomorPO', 'nomorSurat', 'status', 'noKendaraan', 'isiBerat', 'jumlahContoh', 'noKodeContoh', 'noSuratPOK', 'namaBahanId'],
            where: { uuid: req.params.id },
            include: [
                { model: User, attributes: ['name', 'email'] },
                { model: namaBahan, attributes: ['namaBahan'] }
            ]
        });
        if (!sample) return res.status(404).json({ msg: "Sample not found" });
        res.status(200).json(sample);
    } catch (error) {
        console.error("Error fetching sample by ID:", error);
        res.status(500).json({ msg: error.message });
    }
};

// Create Sample
export const createSample = async (req, res) => {
    const { namaUnitPemohon, tanggalSurat, namaBahanId, nomorPO, nomorSurat, status, noKendaraan, isiBerat, jumlahContoh, noKodeContoh, noSuratPOK } = req.body;

    try {
        // Validasi apakah namaBahanId valid
        const validNamaBahan = await namaBahan.findOne({ where: { id: namaBahanId } });

        if (!validNamaBahan) {
            return res.status(400).json({ msg: "Invalid namaBahanId" });
        }

        // Buat sample baru
        const newSample = await Sample.create({
            namaUnitPemohon,
            tanggalSurat,
            namaBahanId,  // Menggunakan namaBahanId
            nomorPO,
            nomorSurat,
            status,
            noKendaraan,  // Store the new fields
            isiBerat,
            jumlahContoh,
            noKodeContoh,
            noSuratPOK,
            userId: req.userId  // Mengaitkan sample dengan pengguna yang sedang login
        });

        res.status(201).json({ msg: "Sample created successfully" });
    } catch (error) {
        console.error("Error creating sample:", error);
        res.status(500).json({ msg: error.message });
    }
};

// Update Sample
export const updateSample = async (req, res) => {
    try {
        const sample = await Sample.findOne({ where: { uuid: req.params.id } });
        if (!sample) return res.status(404).json({ msg: "Sample not found" });

        const { namaUnitPemohon, tanggalSurat, namaBahanId, nomorPO, nomorSurat, status, noKendaraan, isiBerat, jumlahContoh, noKodeContoh, noSuratPOK } = req.body;

        // Admin can update any sample
        if (req.role === "admin") {
            await Sample.update({
                namaUnitPemohon,
                tanggalSurat,
                namaBahanId,
                nomorPO,
                nomorSurat,
                status,
                noKendaraan,
                isiBerat,
                jumlahContoh,
                noKodeContoh,
                noSuratPOK
            }, {
                where: { id: sample.id }
            });
        } else {
            // User can only update their own sample
            if (req.userId !== sample.userId) return res.status(403).json({ msg: "Forbidden access" });
            await Sample.update({
                namaUnitPemohon,
                tanggalSurat,
                namaBahanId,
                nomorPO,
                nomorSurat,
                status,
                noKendaraan,
                isiBerat,
                jumlahContoh,
                noKodeContoh,
                noSuratPOK
            }, {
                where: {
                    [Op.and]: [{ id: sample.id }, { userId: req.userId }]
                }
            });
        }
        res.status(200).json({ msg: "Sample updated successfully" });
    } catch (error) {
        console.error("Error updating sample:", error);
        res.status(500).json({ msg: error.message });
    }
};

// File: controllers/Sample.js
export const deleteSample = async (req, res) => {
  try {
    const sample = await Sample.findOne({ where: { uuid: req.params.id } });
    if (!sample) return res.status(404).json({ msg: "Sample not found" });

    await sample.destroy();
    res.status(200).json({ msg: "Sample deleted successfully" });
  } catch (error) {
    console.error("Error deleting sample:", error);
    if (error.name === 'SequelizeForeignKeyConstraintError') {
      return res.status(400).json({
        msg: "Tidak bisa menghapus sample karena masih ada data analisis terkait. Hapus data analisis terlebih dahulu atau hubungi admin."
      });
    }
    res.status(500).json({ msg: "Terjadi kesalahan di server. Silakan coba lagi nanti." });
  }
};

// Get Sample Counts (for Pending, Completed, and Cancelled status)
export const getSampleCounts = async (req, res) => {
    try {
        const pendingCount = await Sample.count({ where: { status: 'pending' } });
        const completedCount = await Sample.count({ where: { status: 'complete' } });
        const cancelledCount = await Sample.count({ where: { status: 'cancelled' } });

        res.status(200).json({ pending: pendingCount, completed: completedCount, cancelled: cancelledCount });
    } catch (error) {
        console.error("Error fetching sample counts:", error);
        res.status(500).json({ msg: 'Error fetching sample counts' });
    }
};
