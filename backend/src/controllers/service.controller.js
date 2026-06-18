const ServiceRequest = require('../models/ServiceRequest');
const { success, error } = require('../utils/response');

const createRequest = async (req, res) => {
  try {
    const request = await ServiceRequest.create({ ...req.body, userId: req.user._id });
    return success(res, request, 'Service request created', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getRequests = async (req, res) => {
  const requests = await ServiceRequest.find({ userId: req.user._id })
    .populate('propertyId vendorId')
    .sort({ createdAt: -1 });
  return success(res, requests);
};

const getRequest = async (req, res) => {
  const request = await ServiceRequest.findOne({ _id: req.params.id, userId: req.user._id })
    .populate('propertyId vendorId');
  if (!request) return error(res, 'Request not found', 404);
  return success(res, request);
};

const uploadCompletionPhotos = async (req, res) => {
  const files = req.files || [];
  const urls = files.map((f) => `/uploads/${f.filename}`);

  const request = await ServiceRequest.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    { $push: { completionPhotos: { $each: urls } }, status: 'completed' },
    { new: true }
  );
  if (!request) return error(res, 'Request not found', 404);
  return success(res, request, 'Completion photos uploaded');
};

const submitFeedback = async (req, res) => {
  const { feedback, rating } = req.body;
  const request = await ServiceRequest.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    { feedback, rating },
    { new: true }
  );
  if (!request) return error(res, 'Request not found', 404);
  return success(res, request, 'Feedback submitted');
};

module.exports = {
  createRequest,
  getRequests,
  getRequest,
  uploadCompletionPhotos,
  submitFeedback,
};
