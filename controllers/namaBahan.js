import namaBahan from '../models/namaBahan.js'; // Mengimpor model namaBahan

// Get All NamaBahan
export const getNamaBahan = async (req, res) => {
    try {
        const bahanList = await namaBahan.findAll({
            attributes: ['id', 'namaBahan'] // Ambil hanya id dan namaBahan
        });
        res.status(200).json(bahanList);
    } catch (error) {
        res.status(500).json({ msg: error.message });
    }
};
