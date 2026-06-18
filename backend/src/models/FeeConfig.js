const mongoose = require('mongoose');

const feeConfigSchema = new mongoose.Schema(
  {
    serviceType: { type: String, required: true, unique: true },
    feeType: { type: String, required: true },
    amount: { type: Number, required: true },
    description: { type: String, default: '' },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model('FeeConfig', feeConfigSchema);
