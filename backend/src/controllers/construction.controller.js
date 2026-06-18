const ConstructionProject = require('../models/ConstructionProject');
const { success, error } = require('../utils/response');

const createProject = async (req, res) => {
  try {
    const project = await ConstructionProject.create({ ...req.body, userId: req.user._id });
    return success(res, project, 'Construction request created', 201);
  } catch (err) {
    return error(res, err.message, 500);
  }
};

const getProjects = async (req, res) => {
  const projects = await ConstructionProject.find({ userId: req.user._id })
    .populate('propertyId')
    .sort({ createdAt: -1 });
  return success(res, projects);
};

const getProject = async (req, res) => {
  const project = await ConstructionProject.findOne({ _id: req.params.id, userId: req.user._id }).populate('propertyId');
  if (!project) return error(res, 'Project not found', 404);
  return success(res, project);
};

const requestQuotation = async (req, res) => {
  const project = await ConstructionProject.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    { status: 'requested', description: req.body.description || '' },
    { new: true }
  );
  if (!project) return error(res, 'Project not found', 404);
  return success(res, project, 'Quotation requested');
};

module.exports = { createProject, getProjects, getProject, requestQuotation };
