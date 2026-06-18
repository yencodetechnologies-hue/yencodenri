const express = require('express');
const listingController = require('../controllers/listing.controller');
const upload = require('../config/multer');
const { authMiddleware } = require('../middleware/auth.middleware');

const router = express.Router();

router.get('/buy', listingController.searchBuyListings);
router.get('/:id', listingController.getListing);
router.post('/:id/leads', listingController.addLead);

router.use(authMiddleware);

router.post('/', listingController.createListing);
router.get('/', listingController.getMyListings);
router.put('/:id', listingController.updateListing);
router.post('/:id/photos', upload.array('photos', 10), listingController.uploadListingPhotos);

module.exports = router;
