import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import Users from '../models/UserModel.js'

const {DataTypes} = Sequelize;

const Sample = db.define('Sample', {
    uuid: {
        type: DataTypes.STRING,
        defaultValue: DataTypes.UUIDV4,
        allowNull: false,
        validate: {
            notEmpty: true
        }
    },
    userId : {
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
    namaBahan: {
        type: DataTypes.STRING,
        allowNull: false
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
    }
}, {
    freezeTableName: true
});

Users.hasMany(Sample);
Sample.belongsTo(Users, {foreignKey: 'userId'})

export default Sample;
