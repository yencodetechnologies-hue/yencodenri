const User = require('../models/User');
const Property = require('../models/Property');
const Tenant = require('../models/Tenant');
const PropertyListing = require('../models/PropertyListing');
const ServiceRequest = require('../models/ServiceRequest');
const Subscription = require('../models/Subscription');
const RentPayment = require('../models/RentPayment');
const Vendor = require('../models/Vendor');
const RentalAgreement = require('../models/RentalAgreement');
const { signToken, formatUser } = require('../utils/jwt');
const { success, error } = require('../utils/response');

const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email, role: 'admin' });
    if (!user) return error(res, 'Invalid admin credentials', 401);

    const match = await user.comparePassword(password);
    if (!match) return error(res, 'Invalid admin credentials', 401);

    const token = signToken(user);
    return success(res, { token, user: formatUser(user) }, 'Admin login successful');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getUsers = async (req, res) => {
  const users = await User.find({ role: 'user' }).select('-passwordHash').sort({ createdAt: -1 });
  return success(res, users);
};

const verifyUser = async (req, res) => {
  const user = await User.findByIdAndUpdate(req.params.id, { isVerified: true }, { new: true }).select('-passwordHash');
  if (!user) return error(res, 'User not found', 404);
  return success(res, user, 'User verified');
};

const suspendUser = async (req, res) => {
  const user = await User.findByIdAndUpdate(req.params.id, { isSuspended: true }, { new: true }).select('-passwordHash');
  if (!user) return error(res, 'User not found', 404);
  return success(res, user, 'User suspended');
};

const unsuspendUser = async (req, res) => {
  const user = await User.findByIdAndUpdate(req.params.id, { isSuspended: false }, { new: true }).select('-passwordHash');
  if (!user) return error(res, 'User not found', 404);
  return success(res, user, 'User unsuspended');
};

const getAllProperties = async (req, res) => {
  const properties = await Property.find().populate('userId', 'fullName email').sort({ createdAt: -1 });
  return success(res, properties);
};

const verifyProperty = async (req, res) => {
  const { status, rejectionReason } = req.body;
  const property = await Property.findByIdAndUpdate(
    req.params.id,
    { verificationStatus: status, rejectionReason: rejectionReason || '' },
    { new: true }
  );
  if (!property) return error(res, 'Property not found', 404);
  return success(res, property, 'Property status updated');
};

const getAllTenants = async (req, res) => {
  const tenants = await Tenant.find().populate('userId propertyId').sort({ createdAt: -1 });
  return success(res, tenants);
};

const verifyTenant = async (req, res) => {
  const { status, identityVerified, backgroundVerified, policeVerified, rejectionReason } = req.body;
  const tenant = await Tenant.findByIdAndUpdate(
    req.params.id,
    { status, identityVerified, backgroundVerified, policeVerified, rejectionReason: rejectionReason || '' },
    { new: true }
  );
  if (!tenant) return error(res, 'Tenant not found', 404);
  return success(res, tenant, 'Tenant status updated');
};

const getAllListings = async (req, res) => {
  const listings = await PropertyListing.find().populate('userId', 'fullName email').sort({ createdAt: -1 });
  return success(res, listings);
};

const approveListing = async (req, res) => {
  const listing = await PropertyListing.findByIdAndUpdate(req.params.id, { status: 'approved' }, { new: true });
  if (!listing) return error(res, 'Listing not found', 404);
  return success(res, listing, 'Listing approved');
};

const rejectListing = async (req, res) => {
  const { rejectionReason } = req.body;
  const listing = await PropertyListing.findByIdAndUpdate(
    req.params.id,
    { status: 'rejected', rejectionReason: rejectionReason || '' },
    { new: true }
  );
  if (!listing) return error(res, 'Listing not found', 404);
  return success(res, listing, 'Listing rejected');
};

const getAgreements = async (req, res) => {
  const agreements = await RentalAgreement.find()
    .populate('propertyId tenantId ownerId')
    .sort({ createdAt: -1 });
  return success(res, agreements);
};

const getFinanceReports = async (req, res) => {
  const subscriptions = await Subscription.find({ status: 'paid' });
  const rentPayments = await RentPayment.find({ status: 'paid' });

  const subscriptionRevenue = subscriptions.reduce((sum, s) => sum + s.totalAmount, 0);
  const rentRevenue = rentPayments.reduce((sum, p) => sum + p.amount, 0);
  const gstCollected = subscriptions.reduce((sum, s) => sum + s.gstAmount, 0);

  return success(res, {
    subscriptionRevenue,
    rentRevenue,
    gstCollected,
    totalRevenue: subscriptionRevenue + rentRevenue,
    subscriptionCount: subscriptions.length,
    rentPaymentCount: rentPayments.length,
  });
};

const getVendors = async (req, res) => {
  const vendors = await Vendor.find().sort({ createdAt: -1 });
  return success(res, vendors);
};

const createVendor = async (req, res) => {
  const vendor = await Vendor.create(req.body);
  return success(res, vendor, 'Vendor created', 201);
};

const updateVendor = async (req, res) => {
  const vendor = await Vendor.findByIdAndUpdate(req.params.id, req.body, { new: true });
  if (!vendor) return error(res, 'Vendor not found', 404);
  return success(res, vendor, 'Vendor updated');
};

const getServiceRequests = async (req, res) => {
  const requests = await ServiceRequest.find()
    .populate('userId', 'fullName email')
    .populate('vendorId')
    .sort({ createdAt: -1 });
  return success(res, requests);
};

const assignVendor = async (req, res) => {
  const { vendorId } = req.body;
  const request = await ServiceRequest.findByIdAndUpdate(
    req.params.id,
    { vendorId, status: 'assigned' },
    { new: true }
  ).populate('vendorId');
  if (!request) return error(res, 'Request not found', 404);
  return success(res, request, 'Vendor assigned');
};

const updateServiceStatus = async (req, res) => {
  const { status } = req.body;
  const request = await ServiceRequest.findByIdAndUpdate(req.params.id, { status }, { new: true });
  if (!request) return error(res, 'Request not found', 404);
  return success(res, request, 'Status updated');
};

module.exports = {
  login,
  getUsers,
  verifyUser,
  suspendUser,
  unsuspendUser,
  getAllProperties,
  verifyProperty,
  getAllTenants,
  verifyTenant,
  getAllListings,
  approveListing,
  rejectListing,
  getAgreements,
  getFinanceReports,
  getVendors,
  createVendor,
  updateVendor,
  getServiceRequests,
  assignVendor,
  updateServiceStatus,
};
