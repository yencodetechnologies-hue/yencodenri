const express = require('express');
const authRoutes = require('./auth.routes');
const adminRoutes = require('./admin.routes');
const propertyRoutes = require('./property.routes');
const tenantRoutes = require('./tenant.routes');
const agreementRoutes = require('./agreement.routes');
const rentRoutes = require('./rent.routes');
const maintenanceRoutes = require('./maintenance.routes');
const serviceRoutes = require('./service.routes');
const listingRoutes = require('./listing.routes');
const constructionRoutes = require('./construction.routes');
const legalRoutes = require('./legal.routes');
const subscriptionRoutes = require('./subscription.routes');
const paymentRoutes = require('./payment.routes');
const { dashboardRouter, notificationRouter } = require('./dashboard.routes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/admin', adminRoutes);
router.use('/properties', propertyRoutes);
router.use('/tenants', tenantRoutes);
router.use('/agreements', agreementRoutes);
router.use('/rent', rentRoutes);
router.use('/maintenance', maintenanceRoutes);
router.use('/service-requests', serviceRoutes);
router.use('/listings', listingRoutes);
router.use('/construction', constructionRoutes);
router.use('/legal', legalRoutes);
router.use('/subscriptions', subscriptionRoutes);
router.use('/payments', paymentRoutes);
router.use('/', dashboardRouter);
router.use('/notifications', notificationRouter);

module.exports = router;
