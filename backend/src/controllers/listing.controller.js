const PropertyListing = require('../models/PropertyListing');
const { success, error } = require('../utils/response');

const createListing = async (req, res) => {
  try {
    const listing = await PropertyListing.create({ ...req.body, userId: req.user._id });
    return success(res, listing, 'Listing created', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getMyListings = async (req, res) => {
  const listings = await PropertyListing.find({ userId: req.user._id }).sort({ createdAt: -1 });
  return success(res, listings);
};

const searchBuyListings = async (req, res) => {
  const { location, propertyType, minPrice, maxPrice } = req.query;
  const filter = { type: 'sell', status: 'approved' };

  if (location) filter.location = new RegExp(location, 'i');
  if (propertyType) filter.propertyType = propertyType;
  if (minPrice || maxPrice) {
    filter.price = {};
    if (minPrice) filter.price.$gte = Number(minPrice);
    if (maxPrice) filter.price.$lte = Number(maxPrice);
  }

  const listings = await PropertyListing.find(filter).populate('userId', 'fullName email mobile').sort({ createdAt: -1 });
  return success(res, listings);
};

const getListing = async (req, res) => {
  const listing = await PropertyListing.findById(req.params.id).populate('userId', 'fullName email mobile');
  if (!listing) return error(res, 'Listing not found', 404);
  return success(res, listing);
};

const addLead = async (req, res) => {
  const listing = await PropertyListing.findByIdAndUpdate(
    req.params.id,
    { $push: { leads: req.body } },
    { new: true }
  );
  if (!listing) return error(res, 'Listing not found', 404);
  return success(res, listing, 'Lead added');
};

const updateListing = async (req, res) => {
  const listing = await PropertyListing.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    req.body,
    { new: true }
  );
  if (!listing) return error(res, 'Listing not found', 404);
  return success(res, listing, 'Listing updated');
};

const uploadListingPhotos = async (req, res) => {
  const files = req.files || [];
  const urls = files.map((f) => `/uploads/${f.filename}`);

  const listing = await PropertyListing.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    { $push: { photos: { $each: urls } } },
    { new: true }
  );
  if (!listing) return error(res, 'Listing not found', 404);
  return success(res, listing, 'Photos uploaded');
};

module.exports = {
  createListing,
  getMyListings,
  searchBuyListings,
  getListing,
  addLead,
  updateListing,
  uploadListingPhotos,
};
