// models/ParameterInput.js
import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import Sample from './SampleModel.js';
import Parameter from './parameters.js';

const { DataTypes } = Sequelize;

const ParameterInput = db.define('ParameterInput', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  sampleId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Sample,
      key: 'id'
    }
  },
  parameterId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Parameter,
      key: 'id'
    }
  },
  v1: {
    type: DataTypes.FLOAT,
    allowNull: true
  },
  v2: {
    type: DataTypes.FLOAT,
    allowNull: true
  },
  v3: {
    type: DataTypes.FLOAT,
    allowNull: true
  },
  faktorPengenceran: {
    type: DataTypes.FLOAT,
    allowNull: true
  },
  bobotKosong: {
    type: DataTypes.FLOAT,
    allowNull: true
  },
  bobotSampel: {
    type: DataTypes.FLOAT,
    allowNull: true
  },
  bobotSetelahPemanasan: {
    type: DataTypes.FLOAT,
    allowNull: true
  },
  hasil: {
    type: DataTypes.FLOAT,
    allowNull: true
  },
}, {
  freezeTableName: true
});

// Hapus asosiasi dari sini

export default ParameterInput;
