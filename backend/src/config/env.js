require('dotenv').config();

module.exports = {
  port: process.env.PORT || 3013,
  nodeEnv: process.env.NODE_ENV || 'development',
  mongodbUri: process.env.MONGODB_URI || 'mongodb://localhost:27017/nri_property_management',
  jwtSecret: process.env.JWT_SECRET || 'dev_secret_change_me',
  jwtExpiresIn: process.env.JWT_EXPIRES_IN || '7d',
  smtp: {
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.SMTP_PORT || '587', 10),
    secure: process.env.SMTP_SECURE === 'true',
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS,
    from: process.env.SMTP_FROM || 'NRI Property Management',
  },
  otpExpiryMinutes: parseInt(process.env.OTP_EXPIRY_MINUTES || '10', 10),
  adminEmail: process.env.ADMIN_EMAIL || 'admin@gmail.com',
  adminPassword: process.env.ADMIN_PASSWORD || '123456',
  payu: {
    clientId: process.env.PAYU_CLIENT_ID,
    clientSecret: process.env.PAYU_CLIENT_SECRET,
    key: process.env.PAYU_KEY,
    salt: process.env.PAYU_SALT,
    env: process.env.PAYU_ENV || 'test',
  },
  appUrl: process.env.APP_URL || 'http://localhost:3013',
  uploadMaxSizeMb: parseInt(process.env.UPLOAD_MAX_SIZE_MB || '10', 10),
};
