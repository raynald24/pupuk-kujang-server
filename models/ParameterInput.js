import { Sequelize } from 'sequelize';
import db from '../config/database.js';
import Parameter from './parameters.js';

const { DataTypes } = Sequelize;

const ParameterInput = db.define('ParameterInput', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  analysisId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  parameterId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: Parameter,
      key: 'id'
    }
  },
  inputs: {
    type: DataTypes.JSON,
    allowNull: false,
    validate: {
      isValidJSON(value) {
        try {
          if (typeof value === 'string') {
            JSON.parse(value);
          } else {
            JSON.stringify(value);
          }
        } catch (e) {
          throw new Error('Invalid JSON format for inputs');
        }
      }
    }
  }
}, {
  freezeTableName: true,
  indexes: [
    {
      unique: true,
      fields: ['analysisId', 'parameterId']
    }
  ]
});

export default ParameterInput;