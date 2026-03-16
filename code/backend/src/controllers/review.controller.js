const asyncHandler = require('express-async-handler');
const ApiError = require('../utils/ApiError');
const { uploadToCloudinary } = require('../utils/cloudinary');
const reviewService = require('../services/review.service');

const createReview = asyncHandler(async (req, res) => {
  const passengerId = req.user.sub;
  const { bookingId } = req.params;

  const bodyMedia = req.body.media
    ? (typeof req.body.media === 'string' ? JSON.parse(req.body.media) : req.body.media)
    : [];

  const files = [
    ...(req.files?.images || []),
    ...(req.files?.videos || []),
    ...(req.files?.audios || []),
  ];

  if ((bodyMedia?.length || 0) + files.length > 9) {
    throw new ApiError(400, 'review media can contain at most 9 files');
  }

  const uploaded = await Promise.all(
    files.map(async (file) => {
      const result = await uploadToCloudinary(file.buffer, 'painamnae/reviews');

      let mediaType = 'FILE';
      if (file.mimetype.startsWith('image/')) mediaType = 'IMAGE';
      else if (file.mimetype.startsWith('audio/')) mediaType = 'AUDIO';
      else if (file.mimetype === 'video/mp4') mediaType = 'VIDEO';

      return {
        url: result.url,
        publicId: result.public_id,
        type: mediaType,
        mimeType: file.mimetype,
        fileName: file.originalname,
        size: file.size,
      };
    })
  );

  const review = await reviewService.createReviewForBooking({
    bookingId,
    passengerId,
    rating: req.body.rating,
    comment: req.body.comment,
    tags: req.body.tags || [],
    media: [...(bodyMedia || []), ...uploaded],
  });

  res.status(201).json({
    success: true,
    message: 'Review created successfully',
    data: review,
  });
});

const getMyReviewByBooking = asyncHandler(async (req, res) => {
  const passengerId = req.user.sub;
  const { bookingId } = req.params;

  const review = await reviewService.getMyReviewByBooking(bookingId, passengerId);
  res.status(200).json({
    success: true,
    data: review,
  });
});

const getDriverSummary = asyncHandler(async (req, res) => {
  const { driverId } = req.params;
  const summary = await reviewService.getDriverReviewSummary(driverId);

  res.status(200).json({
    success: true,
    data: summary,
  });
});

const getDriverReviews = asyncHandler(async (req, res) => {
  const { driverId } = req.params;
  const data = await reviewService.getDriverReviews(driverId);

  res.status(200).json({
    success: true,
    data,
  });
});

const getMyWrittenReviews = asyncHandler(async (req, res) => {
  const passengerId = req.user.sub;
  const reviews = await reviewService.getMyWrittenReviews(passengerId);

  res.status(200).json({
    success: true,
    data: reviews,
  });
});

module.exports = {
  createReview,
  getMyReviewByBooking,
  getDriverSummary,
  getDriverReviews,
  getMyWrittenReviews,
};
