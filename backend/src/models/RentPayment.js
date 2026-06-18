const mongoose = require('mongoose');

const rentPaymentSchema = new mongoose.Schema(
  {
    agreementId: { type: mongoose.Schema.Types.ObjectId, ref: 'RentalAgreement', required: true },
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    amount: { type: Number, required: true },
    method: {
      type: String,
      enum: ['upi', 'credit_card', 'debit_card', 'net_banking', 'cash'],
      default: 'upi',
    },
    status: {
      type: String,
      enum: ['pending', 'paid', 'failed', 'overdue'],
      default: 'pending',
    },
    receiptUrl: { type: String, default: '' },
    dueDate: { type: Date, required: true },
    paidAt: { type: Date },
    autoPay: { type: Boolean, default: false },
    payuTxnId: { type: String, default: '' },
    payuPaymentId: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('RentPayment', rentPaymentSchema);
