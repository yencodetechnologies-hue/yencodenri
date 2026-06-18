const express = require('express');
const serviceController = require('../controllers/service.controller');
const upload = require('../config/multer');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', serviceController.createRequest);
router.get('/', serviceController.getRequests);
router.get('/:id', serviceController.getRequest);
router.post('/:id/completion-photos', upload.array('photos', 5), serviceController.uploadCompletionPhotos);
router.post('/:id/feedback', serviceController.submitFeedback);

module.exports = router;
