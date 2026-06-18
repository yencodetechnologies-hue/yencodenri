const mongoose = require('mongoose');

const rentalAgreementSchema = new mongoose.Schema(
  {
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property', required: true },
    ownerId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    tenantId: { type: mongoose.Schema.Types.ObjectId, ref: 'Tenant', required: true },
    rentAmount: { type: Number, required: true },
    securityDeposit: { type: Number, default: 0 },
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
    terms: { type: String, default: '' },
    pdfUrl: { type: String, default: '' },
    eSignStatus: {
      type: String,
      enum: ['pending', 'signed', 'declined'],
      default: 'pending',
    },
    status: {
      type: String,
      enum: ['draft', 'active', 'expired', 'terminated'],
      default: 'draft',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('RentalAgreement', rentalAgreementSchema);
