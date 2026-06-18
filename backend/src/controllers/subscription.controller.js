const Subscription = require('../models/Subscription');
const FeeConfig = require('../models/FeeConfig');
const { createOrder, verifyPaymentCallback } = require('../services/payment.service');
const { success, error } = require('../utils/response');

const GST_RATE = 0.18;
const BASE_AMOUNT = 12000;

const getFees = async (_req, res) => {
  const fees = await FeeConfig.find({ isActive: true });
  return success(res, fees);
};

const createSubscription = async (req, res) => {
  try {
    const { propertyId } = req.body;
    const gstAmount = Math.round(BASE_AMOUNT * GST_RATE);
    const totalAmount = BASE_AMOUNT + gstAmount;

    const order = await createOrder(totalAmount, `sub_${Date.now()}`, {
      description: 'Annual property subscription',
      firstname: req.user.fullName,
      email: req.user.email,
      phone: req.user.mobile,
    });

    const subscription = await Subscription.create({
      userId: req.user._id,
      propertyId,
      baseAmount: BASE_AMOUNT,
      gstAmount,
      totalAmount,
      payuTxnId: order.txnid,
      status: 'pending',
    });

    return success(res, { subscription, order, breakdown: { baseAmount: BASE_AMOUNT, gstAmount, totalAmount } }, 'Subscription initiated', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const verifySubscription = async (req, res) => {
  try {
    const { subscriptionId, txnid, mihpayid, status, hash, amount, productinfo, firstname, email, key } = req.body;
    const valid = verifyPaymentCallback({ txnid, amount, productinfo, firstname, email, status, hash, key });

    const subscription = await Subscription.findOne({ _id: subscriptionId, userId: req.user._id });
    if (!subscription) return error(res, 'Subscription not found', 404);

    if (valid) {
      subscription.status = 'paid';
      subscription.paidAt = new Date();
      subscription.expiresAt = new Date(Date.now() + 365 * 24 * 60 * 60 * 1000);
      subscription.payuPaymentId = mihpayid || '';
      await subscription.save();
    } else {
      subscription.status = 'cancelled';
      await subscription.save();
      return error(res, 'Payment verification failed');
    }

    return success(res, subscription, 'Subscription activated');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getMySubscriptions = async (req, res) => {
  const subscriptions = await Subscription.find({ userId: req.user._id })
    .populate('propertyId')
    .sort({ createdAt: -1 });
  return success(res, subscriptions);
};

module.exports = { getFees, createSubscription, verifySubscription, getMySubscriptions };
