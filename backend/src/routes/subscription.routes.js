const express = require('express');
const subscriptionController = require('../controllers/subscription.controller');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.get('/fees', subscriptionController.getFees);

router.use(authMiddleware);

router.post('/', subscriptionController.createSubscription);
router.post('/verify', subscriptionController.verifySubscription);
router.get('/', subscriptionController.getMySubscriptions);

module.exports = router;
