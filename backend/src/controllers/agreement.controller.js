const RentalAgreement = require('../models/RentalAgreement');
const Property = require('../models/Property');
const Tenant = require('../models/Tenant');
const User = require('../models/User');
const { generateRentalAgreementPdf } = require('../services/pdf.service');
const { success, error } = require('../utils/response');

const createAgreement = async (req, res) => {
  try {
    const agreement = await RentalAgreement.create({
      ...req.body,
      ownerId: req.user._id,
    });
    return success(res, agreement, 'Agreement created', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getAgreements = async (req, res) => {
  const agreements = await RentalAgreement.find({ ownerId: req.user._id })
    .populate('propertyId tenantId')
    .sort({ createdAt: -1 });
  return success(res, agreements);
};

const getAgreement = async (req, res) => {
  const agreement = await RentalAgreement.findOne({ _id: req.params.id, ownerId: req.user._id })
    .populate('propertyId tenantId');
  if (!agreement) return error(res, 'Agreement not found', 404);
  return success(res, agreement);
};

const generatePdf = async (req, res) => {
  try {
    const agreement = await RentalAgreement.findOne({ _id: req.params.id, ownerId: req.user._id });
    if (!agreement) return error(res, 'Agreement not found', 404);

    const property = await Property.findById(agreement.propertyId);
    const tenant = await Tenant.findById(agreement.tenantId);
    const owner = await User.findById(agreement.ownerId);

    const pdfUrl = await generateRentalAgreementPdf(agreement, property, tenant, owner);
    agreement.pdfUrl = pdfUrl;
    agreement.status = 'active';
    await agreement.save();

    return success(res, agreement, 'PDF generated');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const eSign = async (req, res) => {
  const agreement = await RentalAgreement.findOneAndUpdate(
    { _id: req.params.id, ownerId: req.user._id },
    { eSignStatus: 'signed' },
    { new: true }
  );
  if (!agreement) return error(res, 'Agreement not found', 404);
  return success(res, agreement, 'E-Sign completed');
};

module.exports = { createAgreement, getAgreements, getAgreement, generatePdf, eSign };
