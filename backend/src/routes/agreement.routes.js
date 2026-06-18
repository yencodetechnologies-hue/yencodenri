const express = require('express');
const agreementController = require('../controllers/agreement.controller');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', agreementController.createAgreement);
router.get('/', agreementController.getAgreements);
router.get('/:id', agreementController.getAgreement);
router.post('/:id/generate-pdf', agreementController.generatePdf);
router.post('/:id/e-sign', agreementController.eSign);

module.exports = router;
