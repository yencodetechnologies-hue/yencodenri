const Tenant = require('../models/Tenant');
const { success, error } = require('../utils/response');

const createTenant = async (req, res) => {
  try {
    const tenant = await Tenant.create({ ...req.body, userId: req.user._id });
    return success(res, tenant, 'Tenant created', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getTenants = async (req, res) => {
  const tenants = await Tenant.find({ userId: req.user._id }).populate('propertyId').sort({ createdAt: -1 });
  return success(res, tenants);
};

const getTenant = async (req, res) => {
  const tenant = await Tenant.findOne({ _id: req.params.id, userId: req.user._id }).populate('propertyId');
  if (!tenant) return error(res, 'Tenant not found', 404);
  return success(res, tenant);
};

const updateTenant = async (req, res) => {
  const tenant = await Tenant.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    req.body,
    { new: true }
  );
  if (!tenant) return error(res, 'Tenant not found', 404);
  return success(res, tenant, 'Tenant updated');
};

const deleteTenant = async (req, res) => {
  const tenant = await Tenant.findOneAndDelete({ _id: req.params.id, userId: req.user._id });
  if (!tenant) return error(res, 'Tenant not found', 404);
  return success(res, null, 'Tenant deleted');
};

module.exports = { createTenant, getTenants, getTenant, updateTenant, deleteTenant };
