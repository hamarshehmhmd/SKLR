const { Sequelize, DataTypes } = require('sequelize');
const sequelize = require('../config/database'); // Adjust the path as necessary

const Skill = sequelize.define('Skill', {
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true,
  },
}, {
  indexes: [
    { fields: ['name'] }, // Index for better performance on skill lookups
  ]
});

module.exports = Skill;
