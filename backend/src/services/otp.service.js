const Otp = require('../models/Otp');
const config = require('../config/env');
const { sendOtpEmail } = require('./email.service');

const generateCode = () => String(Math.floor(100000 + Math.random() * 900000));

const createAndSendOtp = async (identifier, purpose) => {
  const code = generateCode();
  const expiresAt = new Date(Date.now() + config.otpExpiryMinutes * 60 * 1000);

  await Otp.deleteMany({ identifier, purpose });
  await Otp.create({ identifier, code, purpose, expiresAt });

  if (identifier.includes('@')) {
    await sendOtpEmail(identifier, code, purpose);
  } else {
    console.log(`[DEV] OTP for ${identifier}: ${code}`);
  }

  return { expiresAt };
};

const verifyOtp = async (identifier, code, purpose) => {
  const otp = await Otp.findOne({
    identifier,
    code,
    purpose,
    isUsed: false,
    expiresAt: { $gt: new Date() },
  });

  if (!otp) return false;

  otp.isUsed = true;
  await otp.save();
  return true;
};

module.exports = { createAndSendOtp, verifyOtp };
