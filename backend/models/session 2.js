const { Sequelize, DataTypes } = require('sequelize');
const sequelize = require('../config/database'); // Adjust the path as necessary

const Session = sequelize.define('Session', {
  studentId: {
    type: DataTypes.INTEGER,
    references: {
      model: 'Users',
      key: 'id',
    },
  },
  teacherId: {
    type: DataTypes.INTEGER,
    references: {
      model: 'Users',
      key: 'id',
    },
  },
  skillId: {
    type: DataTypes.INTEGER,
    references: {
      model: 'Skills',
      key: 'id',
    },
  },
  time: {
    type: DataTypes.DATE,
    allowNull: false,
  },
}, {
  // Ensure integrity and proper indexing for quick queries
  indexes: [
    { fields: ['studentId'] },
    { fields: ['teacherId'] },
    { fields: ['skillId'] },
    { fields: ['time'] },
  ]
});

module.exports = Session;