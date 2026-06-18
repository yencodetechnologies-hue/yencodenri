const mongoose = require('mongoose');

const tenantSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property' },
    name: { type: String, required: true },
    mobile: { type: String, required: true },
    email: { type: String, default: '' },
    aadhaarPassport: { type: String, default: '' },
    panCard: { type: String, default: '' },
    currentAddress: { type: String, default: '' },
    occupation: { type: String, default: '' },
    employerDetails: { type: String, default: '' },
    emergencyContact: { type: String, default: '' },
    identityVerified: { type: Boolean, default: false },
    backgroundVerified: { type: Boolean, default: false },
    policeVerified: { type: Boolean, default: false },
    status: {
      type: String,
      enum: ['pending', 'verified', 'rejected'],
      default: 'pending',
    },
    rejectionReason: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Tenant', tenantSchema);
