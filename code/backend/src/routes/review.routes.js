const express = require('express');
const validate = require('../middlewares/validate');
const { protect } = require('../middlewares/auth');
const uploadReportMedia = require('../middlewares/uploadReportMedia.middleware');
const reviewController = require('../controllers/review.controller');
const {
  idParamSchema,
  driverIdParamSchema,
  createReviewSchema,
} = require('../validations/review.validation');

const router = express.Router();

router.get(
  '/booking/:bookingId/me',
  protect,
  validate({ params: idParamSchema }),
  reviewController.getMyReviewByBooking
);

router.post(
  '/booking/:bookingId',
  protect,
  uploadReportMedia.fields([
    { name: 'images', maxCount: 3 },
    { name: 'videos', maxCount: 3 },
    { name: 'audios', maxCount: 3 },
  ]),
  validate({ params: idParamSchema, body: createReviewSchema }),
  reviewController.createReview
);

router.get(
  '/driver/:driverId/summary',
  validate({ params: driverIdParamSchema }),
  reviewController.getDriverSummary
);

module.exports = router;
