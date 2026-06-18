const nodemailer = require('nodemailer');
const config = require('../config/env');

let transporter = null;

const getTransporter = () => {
  if (!transporter) {
    transporter = nodemailer.createTransport({
      host: config.smtp.host,
      port: config.smtp.port,
      secure: config.smtp.secure,
      auth: config.smtp.user
        ? { user: config.smtp.user, pass: config.smtp.pass }
        : undefined,
    });
  }
  return transporter;
};

const sendOtpEmail = async (email, otp, purpose = 'verification') => {
  const subject =
    purpose === 'forgot'
      ? 'NRI Property Management - Password Reset OTP'
      : 'NRI Property Management - Verification OTP';

  const html = `
    <div style="font-family:Arial,sans-serif;max-width:480px;margin:0 auto;padding:24px;border:1px solid #e0e0e0;border-radius:8px;">
      <div style="background:linear-gradient(90deg,#0d2240,#02afef);padding:16px;border-radius:8px 8px 0 0;">
        <h2 style="color:#fff;margin:0;">NRI Property Management</h2>
      </div>
      <div style="padding:24px;">
        <p>Your OTP for ${purpose === 'forgot' ? 'password reset' : 'account verification'} is:</p>
        <h1 style="color:#0d2240;letter-spacing:8px;text-align:center;">${otp}</h1>
        <p style="color:#666;">This OTP expires in ${config.otpExpiryMinutes} minutes. Do not share it with anyone.</p>
      </div>
    </div>
  `;

  if (!config.smtp.user || !config.smtp.pass) {
    console.log(`[DEV] OTP for ${email}: ${otp}`);
    return { dev: true, otp };
  }

  await getTransporter().sendMail({
    from: config.smtp.from,
    to: email,
    subject,
    html,
  });

  return { sent: true };
};

module.exports = { sendOtpEmail };
