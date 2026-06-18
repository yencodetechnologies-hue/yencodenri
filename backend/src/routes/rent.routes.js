const express = require('express');
const rentController = require('../controllers/rent.controller');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', rentController.createPayment);
router.post('/verify', rentController.verifyRentPayment);
router.get('/history', rentController.getPaymentHistory);
router.get('/reminders', rentController.getPendingReminders);
router.patch('/:id/auto-pay', rentController.toggleAutoPay);

module.exports = router;
