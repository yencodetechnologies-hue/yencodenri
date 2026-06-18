const express = require('express');
const adminController = require('../controllers/admin.controller');
const { authMiddleware, adminMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.post('/login', adminController.login);

router.use(authMiddleware, adminMiddleware);

router.get('/users', adminController.getUsers);
router.patch('/users/:id/verify', adminController.verifyUser);
router.patch('/users/:id/suspend', adminController.suspendUser);
router.patch('/users/:id/unsuspend', adminController.unsuspendUser);

router.get('/properties', adminController.getAllProperties);
router.patch('/properties/:id/verify', adminController.verifyProperty);

router.get('/tenants', adminController.getAllTenants);
router.patch('/tenants/:id/verify', adminController.verifyTenant);

router.get('/listings', adminController.getAllListings);
router.patch('/listings/:id/approve', adminController.approveListing);
router.patch('/listings/:id/reject', adminController.rejectListing);

router.get('/agreements', adminController.getAgreements);
router.get('/finance', adminController.getFinanceReports);

router.get('/vendors', adminController.getVendors);
router.post('/vendors', adminController.createVendor);
router.patch('/vendors/:id', adminController.updateVendor);

router.get('/service-requests', adminController.getServiceRequests);
router.patch('/service-requests/:id/assign', adminController.assignVendor);
router.patch('/service-requests/:id/status', adminController.updateServiceStatus);

module.exports = router;
