const Property = require('../models/Property');
const { success, error } = require('../utils/response');

const createProperty = async (req, res) => {
  try {
    const property = await Property.create({ ...req.body, userId: req.user._id });
    return success(res, property, 'Property created', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getProperties = async (req, res) => {
  const properties = await Property.find({ userId: req.user._id }).sort({ createdAt: -1 });
  return success(res, properties);
};

const getProperty = async (req, res) => {
  const property = await Property.findOne({ _id: req.params.id, userId: req.user._id });
  if (!property) return error(res, 'Property not found', 404);
  return success(res, property);
};

const updateProperty = async (req, res) => {
  const property = await Property.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    req.body,
    { new: true }
  );
  if (!property) return error(res, 'Property not found', 404);
  return success(res, property, 'Property updated');
};

const deleteProperty = async (req, res) => {
  const property = await Property.findOneAndDelete({ _id: req.params.id, userId: req.user._id });
  if (!property) return error(res, 'Property not found', 404);
  return success(res, null, 'Property deleted');
};

const uploadPhotos = async (req, res) => {
  try {
    const { type } = req.body;
    const files = req.files || [];
    const urls = files.map((f) => `/uploads/${f.filename}`);

    const update = type === 'interior'
      ? { $push: { interiorPhotos: { $each: urls } } }
      : { $push: { exteriorPhotos: { $each: urls } } };

    const property = await Property.findOneAndUpdate(
      { _id: req.params.id, userId: req.user._id },
      update,
      { new: true }
    );
    if (!property) return error(res, 'Property not found', 404);
    return success(res, property, 'Photos uploaded');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const uploadDocument = async (req, res) => {
  try {
    const { docType } = req.body;
    if (!req.file) return error(res, 'No file uploaded');

    const property = await Property.findOneAndUpdate(
      { _id: req.params.id, userId: req.user._id },
      {
        $push: {
          documents: {
            type: docType,
            filename: req.file.originalname,
            url: `/uploads/${req.file.filename}`,
          },
        },
      },
      { new: true }
    );
    if (!property) return error(res, 'Property not found', 404);
    return success(res, property, 'Document uploaded');
  } catch (err) {
    return error(res, err.message, 500);
  }
};

module.exports = {
  createProperty,
  getProperties,
  getProperty,
  updateProperty,
  deleteProperty,
  uploadPhotos,
  uploadDocument,
};
