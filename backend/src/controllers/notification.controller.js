const Notification = require('../models/Notification');
const { success, error } = require('../utils/response');

const getNotifications = async (req, res) => {
  const notifications = await Notification.find({ userId: req.user._id }).sort({ createdAt: -1 });
  return success(res, notifications);
};

const markRead = async (req, res) => {
  const notification = await Notification.findOneAndUpdate(
    { _id: req.params.id, userId: req.user._id },
    { isRead: true },
    { new: true }
  );
  if (!notification) return error(res, 'Notification not found', 404);
  return success(res, notification);
};

const markAllRead = async (req, res) => {
  await Notification.updateMany({ userId: req.user._id }, { isRead: true });
  return success(res, null, 'All notifications marked as read');
};

module.exports = { getNotifications, markRead, markAllRead };
