// models/Sample.js
import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import Users from './UserModel.js';
import namaBahan from './namaBahan.js'; // Import namaBahan model

const { DataTypes } = Sequelize;

const Sample = db.define('Sample', {
    uuid: {
        type: DataTypes.STRING,
        defaultValue: DataTypes.UUIDV4,
        allowNull: false,
        validate: { notEmpty: true }
    },
    userId: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    namaUnitPemohon: {
        type: DataTypes.STRING,
        allowNull: false
    },
    tanggalSurat: {
        type: DataTypes.DATE,
        allowNull: false
    },
    namaBahanId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: namaBahan,  // Reference to namaBahan model
            key: 'id' // Reference to id column in namaBahan
        }
    },
    nomorPO: {
        type: DataTypes.STRING,
        allowNull: false
    },
    nomorSurat: {
        type: DataTypes.STRING,
        allowNull: false
    },
    status: {
        type: DataTypes.ENUM('pending', 'complete', 'cancelled'),
        allowNull: false
    },
    // New fields added
    noKendaraan: {
        type: DataTypes.STRING,
        allowNull: true // Make it nullable if you want
    },
    isiBerat: {
        type: DataTypes.FLOAT,
        allowNull: true // Nullable if you want
    },
    jumlahContoh: {
        type: DataTypes.INTEGER,
        allowNull: true // Nullable if you want
    },
    noKodeContoh: {
        type: DataTypes.STRING,
        allowNull: true // Nullable if you want
    },
    noSuratPOK: {
        type: DataTypes.STRING,
        allowNull: true // Nullable if you want
    }
}, {
    freezeTableName: true
});

// Relasi: Sample belongs to Users
Users.hasMany(Sample);
Sample.belongsTo(Users, { foreignKey: 'userId' });

// Relasi: Sample belongs to namaBahan
namaBahan.hasMany(Sample);
Sample.belongsTo(namaBahan, { foreignKey: 'namaBahanId' });

export default Sample;
