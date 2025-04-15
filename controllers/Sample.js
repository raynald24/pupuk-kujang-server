import Sample from "../models/SampleModel.js";
import User from "../models/UserModel.js";
import { Op } from "sequelize";

// Get All Samples
export const getSamples = async (req, res) => {
    try {
        const response = await Sample.findAll({
            attributes: ['uuid', 'namaUnitPemohon', 'tanggalSurat', 'namaBahan', 'nomorPO', 'nomorSurat', 'status'],
            include: [{
                model: User,
                attributes: ['name', 'email']
            }]
        });
        res.status(200).json(response);
    } catch (error) {
        res.status(500).json({ msg: error.message });
    }
};

// Get Sample by ID
export const getSampleById = async (req, res) => {
    try {
        const sample = await Sample.findOne({
            where: {
                uuid: req.params.id
            }
        });
        if (!sample) return res.status(404).json({ msg: "Sample not found" });

        const response = await Sample.findOne({
            attributes: ['uuid', 'namaUnitPemohon', 'tanggalSurat', 'namaBahan', 'nomorPO', 'nomorSurat', 'status'],
            where: {
                id: sample.id
            },
            include: [{
                model: User,
                attributes: ['name', 'email']
            }]
        });

        res.status(200).json(response);
    } catch (error) {
        res.status(500).json({ msg: error.message });
    }
};

// Create Sample
export const createSample = async (req, res) => {
    const { namaUnitPemohon, tanggalSurat, namaBahan, nomorPO, nomorSurat, status } = req.body;

    try {
        const newSample = await Sample.create({
            namaUnitPemohon,
            tanggalSurat,
            namaBahan,
            nomorPO,
            nomorSurat,
            status,
            userId: req.userId // Mengaitkan sample dengan pengguna yang sedang login
        });
        res.status(201).json({ msg: "Sample created successfully" });
    } catch (error) {
        res.status(500).json({ msg: error.message });
    }
};

// Update Sample
export const updateSample = async (req, res) => {
    try {
        const sample = await Sample.findOne({
            where: {
                uuid: req.params.id
            }
        });
        if (!sample) return res.status(404).json({ msg: "Sample not found" });

        const { namaUnitPemohon, tanggalSurat, namaBahan, nomorPO, nomorSurat, status } = req.body;

        // Admin bisa mengupdate sample milik siapa saja
        if (req.role === "admin") {
            await Sample.update({ namaUnitPemohon, tanggalSurat, namaBahan, nomorPO, nomorSurat, status }, {
                where: {
                    id: sample.id
                }
            });
        } else {
            // Pengguna hanya bisa mengupdate sample miliknya sendiri
            if (req.userId !== sample.userId) return res.status(403).json({ msg: "Forbidden access" });
            await Sample.update({ namaUnitPemohon, tanggalSurat, namaBahan, nomorPO, nomorSurat, status }, {
                where: {
                    [Op.and]: [{ id: sample.id }, { userId: req.userId }]
                }
            });
        }
        res.status(200).json({ msg: "Sample updated successfully" });
    } catch (error) {
        res.status(500).json({ msg: error.message });
    }
};

// Delete Sample
export const deleteSample = async (req, res) => {
    try {
        const sample = await Sample.findOne({
            where: { uuid: req.params.id }
        });
        if (!sample) return res.status(404).json({ msg: "Sample not found" });

        await sample.destroy();
        res.status(200).json({ msg: "Sample deleted successfully" });
    } catch (error) {
        res.status(500).json({ msg: error.message });
    }
};

// Get Sample Counts (for Pending, Completed, and Cancelled status)
export const getSampleCounts = async (req, res) => {
    try {
        const pendingCount = await Sample.count({
            where: { status: 'pending' }
        });
        const completedCount = await Sample.count({
            where: { status: 'complete' }
        });
        const cancelledCount = await Sample.count({
            where: { status: 'cancelled' }
        });

        res.status(200).json({
            pending: pendingCount,
            completed: completedCount,
            cancelled: cancelledCount
        });
    } catch (error) {
        console.error('Error fetching sample counts:', error)
        res.status(500).json({ msg: 'Error fetching sample counts' });
    }
};
