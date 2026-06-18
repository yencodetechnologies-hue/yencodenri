const express = require('express');
const dashboardController = require('../controllers/dashboard.controller');
const notificationController = require('../controllers/notification.controller');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();
const notifRouter = express.Router();

router.get('/dashboard', authMiddleware, dashboardController.getDashboard);

notifRouter.use(authMiddleware);
notifRouter.get('/', notificationController.getNotifications);
notifRouter.patch('/:id/read', notificationController.markRead);
notifRouter.patch('/read-all', notificationController.markAllRead);

module.exports = { dashboardRouter: router, notificationRouter: notifRouter };
