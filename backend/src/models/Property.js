const mongoose = require('mongoose');

const documentSchema = new mongoose.Schema({
  type: {
    type: String,
    enum: ['ec', 'patta', 'sale_deed', 'tax_receipt', 'khata', 'other'],
    required: true,
  },
  filename: String,
  url: String,
  uploadedAt: { type: Date, default: Date.now },
});

const propertySchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    name: { type: String, required: true },
    holderName: { type: String, required: true },
    relationship: { type: String, default: '' },
    address: { type: String, required: true },
    contactPerson: { type: String, default: '' },
    email: { type: String, default: '' },
    localContact: { type: String, default: '' },
    exteriorPhotos: [String],
    interiorPhotos: [String],
    propertyType: {
      type: String,
      enum: ['apartment', 'villa', 'plot', 'commercial'],
      required: true,
    },
    documents: [documentSchema],
    verificationStatus: {
      type: String,
      enum: ['pending', 'under_review', 'verified', 'rejected'],
      default: 'pending',
    },
    rejectionReason: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('Property', propertySchema);
