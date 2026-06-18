const mongoose = require('mongoose');

const vendorSchema = new mongoose.Schema(
  {
    name: { type: String, required: true },
    category: {
      type: String,
      enum: ['plumbing', 'electrical', 'cleaning', 'painting', 'pest_control', 'carpentry', 'appliance_repair', 'legal', 'construction', 'broker'],
      required: true,
    },
    email: { type: String, default: '' },
    mobile: { type: String, default: '' },
    address: { type: String, default: '' },
    rating: { type: Number, default: 0, min: 0, max: 5 },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Vendor', vendorSchema);
