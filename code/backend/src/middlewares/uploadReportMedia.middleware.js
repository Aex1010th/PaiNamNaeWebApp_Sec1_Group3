const multer = require('multer');
const ApiError = require('../utils/ApiError');

const storage = multer.memoryStorage();

const uploadReportMedia = multer({
  storage,
  limits: { fileSize: 50 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    const isImage = file.mimetype.startsWith('image/');
    const isAudio = file.mimetype.startsWith('audio/');
    const isMp4Video = file.mimetype === 'video/mp4';

    if (isImage || isAudio || isMp4Video) {
      cb(null, true);
      return;
    }

    cb(new ApiError(400, 'Only image, audio, and mp4 video files are allowed'), false);
  },
});

module.exports = uploadReportMedia;
