const mongoose = require('mongoose');

const serviceRequestSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property' },
    category: {
      type: String,
      enum: ['plumbing', 'electrical', 'cleaning', 'painting', 'pest_control', 'carpentry', 'appliance_repair'],
      required: true,
    },
    description: { type: String, required: true },
    status: {
      type: String,
      enum: ['open', 'assigned', 'in_progress', 'completed'],
      default: 'open',
    },
    vendorId: { type: mongoose.Schema.Types.ObjectId, ref: 'Vendor' },
    completionPhotos: [String],
    feedback: { type: String, default: '' },
    rating: { type: Number, min: 1, max: 5 },
  },
  { timestamps: true }
);

module.exports = mongoose.model('ServiceRequest', serviceRequestSchema);
