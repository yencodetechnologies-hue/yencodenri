const RentPayment = require('../models/RentPayment');
const RentalAgreement = require('../models/RentalAgreement');
const { createOrder, verifyPaymentCallback } = require('../services/payment.service');
const { success, error } = require('../utils/response');

const paymentNotes = (req, description) => ({
  description,
  firstname: req.user.fullName,
  email: req.user.email,
  phone: req.user.mobile,
});

const createPayment = async (req, res) => {
  try {
    const { agreementId, amount, method, dueDate, autoPay } = req.body;
    const agreement = await RentalAgreement.findOne({ _id: agreementId, ownerId: req.user._id });
    if (!agreement) return error(res, 'Agreement not found', 404);

    const order = await createOrder(amount, `rent_${Date.now()}`, paymentNotes(req, 'Rent payment'));

    const payment = await RentPayment.create({
      agreementId,
      userId: req.user._id,
      amount,
      method,
      dueDate,
      autoPay: autoPay || false,
      payuTxnId: order.txnid,
      status: 'pending',
    });

    return success(res, { payment, order }, 'Payment initiated', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const verifyRentPayment = async (req, res) => {
  try {
    const { paymentId, txnid, mihpayid, status, hash, amount, productinfo, firstname, email, key } = req.body;
    const valid = verifyPaymentCallback({ txnid, amount, productinfo, firstname, email, status, hash, key });

    const payment = await RentPayment.findOne({ _id: paymentId, userId: req.user._id });
    if (!payment) return error(res, 'Payment not found', 404);

    if (valid) {
      payment.status = 'paid';
      payment.paidAt = new Date();
      payment.payuPaymentId = mihpayid || '';
      payment.receiptUrl = `/uploads/receipt-${payment._id}.pdf`;
      await payment.save();
    } else {
      payment.status = 'failed';
      await payment.save();
      return error(res, 'Payment verification failed');
    }

    return success(res, payment, 'Payment successful');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getPaymentHistory = async (req, res) => {
  const payments = await RentPayment.find({ userId: req.user._id })
    .populate({ path: 'agreementId', populate: { path: 'propertyId tenantId' } })
    .sort({ createdAt: -1 });
  return success(res, payments);
};

const toggleAutoPay = async (req, res) => {
  const payment = await RentPayment.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    { autoPay: req.body.autoPay },
    { new: true }
  );
  if (!payment) return error(res, 'Payment not found', 404);
  return success(res, payment, 'Auto-pay updated');
};

const getPendingReminders = async (req, res) => {
  const pending = await RentPayment.find({
    userId: req.user._id,
    status: { $in: ['pending', 'overdue'] },
    dueDate: { $lte: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000) },
  }).populate('agreementId');
  return success(res, pending);
};

module.exports = {
  createPayment,
  verifyRentPayment,
  getPaymentHistory,
  toggleAutoPay,
  getPendingReminders,
};
