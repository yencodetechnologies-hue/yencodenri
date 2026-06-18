const Property = require('../models/Property');
const Tenant = require('../models/Tenant');
const RentPayment = require('../models/RentPayment');
const ServiceRequest = require('../models/ServiceRequest');
const Notification = require('../models/Notification');
const { success } = require('../utils/response');

const getDashboard = async (req, res) => {
  const userId = req.user._id;

  const [totalProperties, activeTenants, monthlyIncome, pendingRequests, notifications] = await Promise.all([
    Property.countDocuments({ userId }),
    Tenant.countDocuments({ userId, status: 'verified' }),
    RentPayment.aggregate([
      { $match: { userId, status: 'paid', paidAt: { $gte: new Date(new Date().getFullYear(), new Date().getMonth(), 1) } } },
      { $group: { _id: null, total: { $sum: '$amount' } } },
    ]),
    ServiceRequest.countDocuments({ userId, status: { $in: ['open', 'assigned', 'in_progress'] } }),
    Notification.find({ userId }).sort({ createdAt: -1 }).limit(10),
  ]);

  return success(res, {
    totalProperties,
    activeTenants,
    monthlyRentalIncome: monthlyIncome[0]?.total || 0,
    pendingServiceRequests: pendingRequests,
    notifications,
    quickActions: [
      { id: 'post_property', label: 'Post Property', route: '/properties/add' },
      { id: 'rent_property', label: 'Rent Property', route: '/listings/sell' },
      { id: 'buy_property', label: 'Buy Property', route: '/listings/buy' },
      { id: 'sell_property', label: 'Sell Property', route: '/listings/sell' },
      { id: 'construction', label: 'Construction Services', route: '/construction' },
      { id: 'legal', label: 'Legal Services', route: '/legal' },
    ],
  });
};

module.exports = { getDashboard };
