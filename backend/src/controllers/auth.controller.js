const User = require('../models/User');
const { createAndSendOtp, verifyOtp } = require('../services/otp.service');
const { signToken, formatUser } = require('../utils/jwt');
const { success, error } = require('../utils/response');

const register = async (req, res) => {
  try {
    const { fullName, email, mobile, password, confirmPassword, country, address, termsAccepted, privacyAccepted } = req.body;

    if (!fullName || !email || !mobile || !password) {
      return error(res, 'Required fields missing');
    }
    if (password !== confirmPassword) {
      return error(res, 'Passwords do not match');
    }
    if (!termsAccepted || !privacyAccepted) {
      return error(res, 'You must accept terms and privacy policy');
    }

    const existing = await User.findOne({ $or: [{ email }, { mobile }] });
    if (existing) {
      return error(res, 'Email or mobile already registered');
    }

    const passwordHash = await User.hashPassword(password);
    await User.create({
      fullName,
      email,
      mobile,
      passwordHash,
      country: country || '',
      address: address || '',
      termsAccepted,
      privacyAccepted,
      isVerified: false,
    });

    await createAndSendOtp(email, 'register');
    return success(res, { email }, 'Registration successful. Please verify OTP.', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const sendOtp = async (req, res) => {
  try {
    const { identifier, purpose } = req.body;
    if (!identifier || !purpose) return error(res, 'Identifier and purpose required');

    if (purpose === 'register') {
      const user = await User.findOne({ email: identifier });
      if (!user) return error(res, 'User not found');
    }

    if (purpose === 'forgot') {
      const user = await User.findOne({
        $or: [{ email: identifier }, { mobile: identifier }],
      });
      if (!user) return error(res, 'User not found');
      await createAndSendOtp(user.email, 'forgot');
      return success(res, null, 'OTP sent to registered email');
    }

    await createAndSendOtp(identifier, purpose);
    return success(res, null, 'OTP sent');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const verifyOtpHandler = async (req, res) => {
  try {
    const { identifier, code, purpose } = req.body;
    const valid = await verifyOtp(identifier, code, purpose);
    if (!valid) return error(res, 'Invalid or expired OTP');

    const user = await User.findOne({ email: identifier });
    if (!user) return error(res, 'User not found');

    if (purpose === 'register') {
      user.isVerified = true;
      await user.save();
      const token = signToken(user);
      return success(res, { token, user: formatUser(user) }, 'Account verified');
    }

    return success(res, { verified: true }, 'OTP verified');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const login = async (req, res) => {
  try {
    const { identifier, password } = req.body;
    if (!identifier || !password) return error(res, 'Credentials required');

    const user = await User.findOne({
      $or: [{ email: identifier }, { mobile: identifier }],
      role: 'user',
    });

    if (!user) return error(res, 'Invalid credentials', 401);
    if (user.isSuspended) return error(res, 'Account suspended', 403);
    if (!user.isVerified) return error(res, 'Please verify your account first', 403);

    const match = await user.comparePassword(password);
    if (!match) return error(res, 'Invalid credentials', 401);

    const token = signToken(user);
    return success(res, { token, user: formatUser(user) }, 'Login successful');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const forgotPassword = async (req, res) => {
  try {
    const { identifier } = req.body;
    const user = await User.findOne({
      $or: [{ email: identifier }, { mobile: identifier }],
    });
    if (!user) return error(res, 'User not found');

    await createAndSendOtp(user.email, 'forgot');
    return success(res, { email: user.email }, 'OTP sent to registered email');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const resetPassword = async (req, res) => {
  try {
    const { identifier, code, newPassword, confirmPassword } = req.body;
    if (newPassword !== confirmPassword) return error(res, 'Passwords do not match');

    const user = await User.findOne({
      $or: [{ email: identifier }, { mobile: identifier }],
    });
    if (!user) return error(res, 'User not found');

    const valid = await verifyOtp(user.email, code, 'forgot');
    if (!valid) return error(res, 'Invalid or expired OTP');

    user.passwordHash = await User.hashPassword(newPassword);
    await user.save();

    return success(res, null, 'Password reset successful');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getProfile = async (req, res) => {
  return success(res, formatUser(req.user));
};

module.exports = {
  register,
  sendOtp,
  verifyOtpHandler,
  login,
  forgotPassword,
  resetPassword,
  getProfile,
};
