const jwt = require('jsonwebtoken');
const config = require('../config/env');
const User = require('../models/User');
const { error } = require('../utils/response');

const authMiddleware = async (req, res, next) => {
  try {
    const header = req.headers.authorization;
    if (!header || !header.startsWith('Bearer ')) {
      return error(res, 'Unauthorized', 401);
    }

    const token = header.split(' ')[1];
    const decoded = jwt.verify(token, config.jwtSecret);
    const user = await User.findById(decoded.id).select('-passwordHash');

    if (!user || user.isSuspended) {
      return error(res, 'Unauthorized', 401);
    }

    req.user = user;
    next();
  } catch (err) {
    return error(res, 'Invalid token', 401);
  }
};

const adminMiddleware = (req, res, next) => {
  if (!req.user || req.user.role !== 'admin') {
    return error(res, 'Admin access required', 403);
  }
  next();
};

module.exports = { authMiddleware, adminMiddleware };
