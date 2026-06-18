const express = require('express');
const paymentController = require('../controllers/payment.controller');

const router = express.Router();

router.post('/payu/success', paymentController.payuSuccess);
router.get('/payu/success', paymentController.payuSuccess);
router.post('/payu/failure', paymentController.payuFailure);
router.get('/payu/failure', paymentController.payuFailure);

module.exports = router;
