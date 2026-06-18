const RentPayment = require('../models/RentPayment');
const MaintenancePayment = require('../models/MaintenancePayment');
const Subscription = require('../models/Subscription');
const { verifyPaymentCallback } = require('../services/payment.service');

const handlePayuCallback = async (req, res, isSuccess) => {
  const params = { ...req.body, ...req.query };
  const valid = verifyPaymentCallback(params);
  const { txnid, mihpayid, status } = params;

  if (valid && txnid) {
    await Promise.all([
      RentPayment.findOneAndUpdate(
        { payuTxnId: txnid },
        { status: 'paid', paidAt: new Date(), payuPaymentId: mihpayid || '' }
      ),
      MaintenancePayment.findOneAndUpdate(
        { payuTxnId: txnid },
        { status: 'paid', paidAt: new Date(), payuPaymentId: mihpayid || '' }
      ),
      Subscription.findOneAndUpdate(
        { payuTxnId: txnid },
        {
          status: 'paid',
          paidAt: new Date(),
          payuPaymentId: mihpayid || '',
          expiresAt: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000),
        }
      ),
    ]);
  }

  const message = isSuccess && valid ? 'Payment successful' : 'Payment failed';
  res.send(`<html><body><h2>${message}</h2><p>Status: ${status || 'unknown'}</p><p>You can close this window.</p></body></html>`);
};

const payuSuccess = (req, res) => handlePayuCallback(req, res, true);
const payuFailure = (req, res) => handlePayuCallback(req, res, false);

module.exports = { payuSuccess, payuFailure };
