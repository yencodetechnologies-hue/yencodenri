const mongoose = require('mongoose');

const legalCaseSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property' },
    serviceType: {
      type: String,
      enum: ['property_verification', 'document_verification', 'sale_deed_registration', 'rental_agreement_registration', 'legal_consultation'],
      required: true,
    },
    description: { type: String, default: '' },
    documents: [String],
    lawyerId: { type: mongoose.Schema.Types.ObjectId, ref: 'Vendor' },
    status: {
      type: String,
      enum: ['requested', 'assigned', 'in_progress', 'completed', 'cancelled'],
      default: 'requested',
    },
    notes: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('LegalCase', legalCaseSchema);
