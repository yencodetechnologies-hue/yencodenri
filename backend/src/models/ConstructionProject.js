const mongoose = require('mongoose');

const progressSchema = new mongoose.Schema({
  title: String,
  description: String,
  date: { type: Date, default: Date.now },
  photos: [String],
});

const constructionProjectSchema = new mongoose.Schema(
  {
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    propertyId: { type: mongoose.Schema.Types.ObjectId, ref: 'Property' },
    serviceType: {
      type: String,
      enum: ['new_construction', 'renovation', 'interior_design', 'architecture', 'structural_consulting'],
      required: true,
    },
    description: { type: String, default: '' },
    quotation: { type: Number, default: 0 },
    quotationNotes: { type: String, default: '' },
    progress: [progressSchema],
    status: {
      type: String,
      enum: ['requested', 'quoted', 'in_progress', 'completed', 'cancelled'],
      default: 'requested',
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model('ConstructionProject', constructionProjectSchema);
