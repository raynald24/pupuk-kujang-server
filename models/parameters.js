import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import namaBahan from './namaBahan.js';

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
  name: {
    type: DataTypes.STRING,
    allowNull: false
  },
  type: {
    type: DataTypes.ENUM('calculated', 'manual', 'enum'),
    allowNull: false
  },
  formula: {
    type: DataTypes.STRING,
    allowNull: true
  },
  inputs: {
    type: DataTypes.JSON,
    allowNull: true
  }
}, {
  freezeTableName: true
});

export default Parameter;