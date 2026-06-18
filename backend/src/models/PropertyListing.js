const mongoose = require('mongoose');

const leadSchema = new mongoose.Schema({
  name: String,
  email: String,
  mobile: String,
  message: String,
  createdAt: { type: Date, default: Date.now },
});

const propertyListingSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    type: { type: String, enum: ['buy', 'sell'], required: true },
    title: { type: String, required: true },
    description: { type: String, default: '' },
    location: { type: String, required: true },
    price: { type: Number, required: true },
    propertyType: {
      type: String,
      enum: ['apartment', 'villa', 'plot', 'commercial'],
      default: 'apartment',
    },
    photos: [String],
    documents: [String],
    contactName: { type: String, default: '' },
    contactEmail: { type: String, default: '' },
    contactMobile: { type: String, default: '' },
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected', 'sold', 'active'],
      default: 'pending',
    },
    leads: [leadSchema],
    rejectionReason: { type: String, default: '' },
  },
  { timestamps: true }
);

module.exports = mongoose.model('PropertyListing', propertyListingSchema);
