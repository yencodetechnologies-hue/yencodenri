const express = require('express');
const legalController = require('../controllers/legal.controller');
const upload = require('../config/multer');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', legalController.createCase);
router.get('/', legalController.getCases);
router.get('/:id', legalController.getCase);
router.post('/:id/documents', upload.array('documents', 10), legalController.uploadDocuments);
router.post('/:id/book-lawyer', legalController.bookLawyer);

module.exports = router;
