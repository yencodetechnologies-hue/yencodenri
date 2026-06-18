const mongoose = require('mongoose');

const maintenancePaymentSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property', required: true },
    type: {
      type: String,
      enum: ['society', 'utility', 'property_tax'],
      required: true,
    },
    description: { type: String, default: '' },
    amount: { type: Number, required: true },
    status: {
      type: String,
      enum: ['pending', 'paid', 'failed'],
      default: 'pending',
    },
    paidAt: { type: Date },
    payuTxnId: { type: String, default: '' },
    payuPaymentId: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('MaintenancePayment', maintenancePaymentSchema);
