const express = require('express');
const maintenanceController = require('../controllers/maintenance.controller');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', maintenanceController.createPayment);
router.post('/verify', maintenanceController.verifyPaymentHandler);
router.get('/history', maintenanceController.getHistory);

module.exports = router;
