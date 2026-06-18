const MaintenancePayment = require('../models/MaintenancePayment');
const { createOrder, verifyPaymentCallback } = require('../services/payment.service');
const { success, error } = require('../utils/response');

const createPayment = async (req, res) => {
  try {
    const { propertyId, type, description, amount } = req.body;
    const order = await createOrder(amount, `maint_${Date.now()}`, {
      description: description || `${type} payment`,
      firstname: req.user.fullName,
      email: req.user.email,
      phone: req.user.mobile,
    });

    const payment = await MaintenancePayment.create({
      userId: req.user._id,
      propertyId,
      type,
      description,
      amount,
      payuTxnId: order.txnid,
      status: 'pending',
    });

    return success(res, { payment, order }, 'Maintenance payment initiated', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const verifyPaymentHandler = async (req, res) => {
  try {
    const { paymentId, txnid, mihpayid, status, hash, amount, productinfo, firstname, email, key } = req.body;
    const valid = verifyPaymentCallback({ txnid, amount, productinfo, firstname, email, status, hash, key });

    const payment = await MaintenancePayment.findOne({ _id: paymentId, userId: req.user._id });
    if (!payment) return error(res, 'Payment not found', 404);

    payment.status = valid ? 'paid' : 'failed';
    if (valid) payment.paidAt = new Date();
    payment.payuPaymentId = mihpayid || '';
    await payment.save();

    return valid
      ? success(res, payment, 'Payment successful')
      : error(res, 'Payment verification failed');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getHistory = async (req, res) => {
  const payments = await MaintenancePayment.find({ userId: req.user._id })
    .populate('propertyId')
    .sort({ createdAt: -1 });
  return success(res, payments);
};

module.exports = { createPayment, verifyPaymentHandler, getHistory };
