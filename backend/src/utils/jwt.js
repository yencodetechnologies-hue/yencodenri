const jwt = require('jsonwebtoken');
const config = require('../config/env');

const signToken = (user) => {
  return jwt.sign({ id: user._id, role: user.role }, config.jwtSecret, {
    expiresIn: config.jwtExpiresIn,
  });
};

const formatUser = (user) => ({
  id: user._id,
  fullName: user.fullName,
  email: user.email,
  mobile: user.mobile,
  country: user.country,
  address: user.address,
  role: user.role,
  isVerified: user.isVerified,
});

module.exports = { signToken, formatUser };
