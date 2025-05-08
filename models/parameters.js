// models/Parameter.js
import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import namaBahan from './namaBahan.js'; // Import namaBahan model

const { DataTypes } = Sequelize;

const Parameter = db.define('Parameter', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    namaBahanId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: namaBahan,
            key: 'id'
        }
    },
    namaParameter: {
        type: DataTypes.STRING,
        allowNull: false
    },
    rumus: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    freezeTableName: true
});

// Relasi: Parameter belongs to NamaBahan
Parameter.belongsTo(namaBahan, { foreignKey: 'namaBahanId' });

export default Parameter;
