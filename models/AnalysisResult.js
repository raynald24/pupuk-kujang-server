import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import Sample from './SampleModel.js';
import Parameter from './parameters.js';

const { DataTypes } = Sequelize;

const AnalysisResult = db.define('AnalysisResult', {
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
  analisaNumber: {
    type: DataTypes.STRING,
    allowNull: false
  },
  tanggalAnalisa: {
    type: DataTypes.DATE,
    allowNull: false
  },
  publishAnalisa: {
    type: DataTypes.DATE,
    allowNull: false,
  },
  hasilPerhitungan: {
    type: DataTypes.TEXT,
    allowNull: true
  }
}, {
  freezeTableName: true,
  timestamps: true
});

export default AnalysisResult;