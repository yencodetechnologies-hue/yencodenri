const mongoose = require('mongoose');

const subscriptionSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property', required: true },
    baseAmount: { type: Number, default: 12000 },
    gstAmount: { type: Number, default: 2160 },
    totalAmount: { type: Number, default: 14160 },
    status: {
      type: String,
      enum: ['pending', 'paid', 'expired', 'cancelled'],
      default: 'pending',
    },
    paidAt: { type: Date },
    expiresAt: { type: Date },
    payuTxnId: { type: String, default: '' },
    payuPaymentId: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Subscription', subscriptionSchema);
