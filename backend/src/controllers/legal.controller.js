const LegalCase = require('../models/LegalCase');
const upload = require('../config/multer');
const { success, error } = require('../utils/response');

const createCase = async (req, res) => {
  try {
    const legalCase = await LegalCase.create({ ...req.body, userId: req.user._id });
    return success(res, legalCase, 'Legal service requested', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getCases = async (req, res) => {
  const cases = await LegalCase.find({ userId: req.user._id })
    .populate('propertyId lawyerId')
    .sort({ createdAt: -1 });
  return success(res, cases);
};

const getCase = async (req, res) => {
  const legalCase = await LegalCase.findOne({ _id: req.params.id, userId: req.user._id })
    .populate('propertyId lawyerId');
  if (!legalCase) return error(res, 'Case not found', 404);
  return success(res, legalCase);
};

const uploadDocuments = async (req, res) => {
  const files = req.files || [];
  const urls = files.map((f) => `/uploads/${f.filename}`);

  const legalCase = await LegalCase.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    { $push: { documents: { $each: urls } } },
    { new: true }
  );
  if (!legalCase) return error(res, 'Case not found', 404);
  return success(res, legalCase, 'Documents uploaded');
};

const bookLawyer = async (req, res) => {
  const { lawyerId } = req.body;
  const legalCase = await LegalCase.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    { lawyerId, status: 'assigned' },
    { new: true }
  ).populate('lawyerId');
  if (!legalCase) return error(res, 'Case not found', 404);
  return success(res, legalCase, 'Lawyer booked');
};

module.exports = { createCase, getCases, getCase, uploadDocuments, bookLawyer };
