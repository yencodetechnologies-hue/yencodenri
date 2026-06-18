const express = require('express');
const constructionController = require('../controllers/construction.controller');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', constructionController.createProject);
router.get('/', constructionController.getProjects);
router.get('/:id', constructionController.getProject);
router.post('/:id/quotation', constructionController.requestQuotation);

module.exports = router;
