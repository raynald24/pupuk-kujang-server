// models/AnalysisResult.js
import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import Sample from './SampleModel.js';
import Parameter from './parameters.js';
import ParameterInput from './ParameterInput.js';  // Import ParameterInput

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
  parameterInputId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: ParameterInput,
      key: 'id'
    }
  },
  hasilPerhitungan: {
    type: DataTypes.FLOAT,
    allowNull: true  
  },
  tanggalAnalisa: {
    type: DataTypes.DATE,
    allowNull: false
  },
  analisaNumber: {
    type: DataTypes.STRING,
    allowNull: false
  },
  publishAnalisa: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  }
}, {
  freezeTableName: true
});

// Relasi ke Sample
AnalysisResult.belongsTo(Sample, { foreignKey: 'sampleId' });

// Relasi ke Parameter
AnalysisResult.belongsTo(Parameter, { foreignKey: 'parameterId' });

// Relasi ke ParameterInput
AnalysisResult.belongsTo(ParameterInput, { foreignKey: 'parameterInputId' });

export default AnalysisResult;
