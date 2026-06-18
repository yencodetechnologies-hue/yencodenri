const express = require('express');
const propertyController = require('../controllers/property.controller');
const upload = require('../config/multer');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.use(authMiddleware);

router.post('/', propertyController.createProperty);
router.get('/', propertyController.getProperties);
router.get('/:id', propertyController.getProperty);
router.put('/:id', propertyController.updateProperty);
router.delete('/:id', propertyController.deleteProperty);
router.post('/:id/photos', upload.array('photos', 10), propertyController.uploadPhotos);
router.post('/:id/documents', upload.single('document'), propertyController.uploadDocument);

module.exports = router;
