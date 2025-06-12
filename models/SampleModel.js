import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import Users from './UserModel.js';
import namaBahan from './namaBahan.js';

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
        allowNull: false,
        references: {
            model: Users,
            key: 'id'
        }
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
            model: namaBahan,
            key: 'id'
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
    noKendaraan: {
        type: DataTypes.STRING,
        allowNull: true
    },
    isiBerat: {
        type: DataTypes.FLOAT,
        allowNull: true
    },
    jumlahContoh: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    noKodeContoh: {
        type: DataTypes.STRING,
        allowNull: true
    },
    noSuratPOK: {
        type: DataTypes.STRING,
        allowNull: true
    }
}, {
    freezeTableName: true
});

export default Sample;