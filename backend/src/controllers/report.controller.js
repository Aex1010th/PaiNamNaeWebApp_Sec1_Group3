const asyncHandler = require('express-async-handler');
const reportService = require('../services/report.service');
const ApiError = require('../utils/ApiError');
const { uploadToCloudinary } = require('../utils/cloudinary');

const createReport = asyncHandler(async (req, res) => {
  const userId = req.user.sub;

  const bodyMedia = req.body.media
    ? (typeof req.body.media === 'string' ? JSON.parse(req.body.media) : req.body.media)
    : [];

  const files = [
    ...(req.files?.images || []),
    ...(req.files?.videos || []),
    ...(req.files?.audios || []),
  ];

  if ((bodyMedia?.length || 0) + files.length > 3) {
    throw new ApiError(400, 'media can contain at most 3 files');
  }

  const uploaded = await Promise.all(
    files.map(async (file) => {
      const result = await uploadToCloudinary(file.buffer, 'painamnae/reports');

      let mediaType = 'FILE';
      if (file.mimetype.startsWith('image/')) mediaType = 'IMAGE';
      else if (file.mimetype.startsWith('audio/')) mediaType = 'AUDIO';
      else if (file.mimetype === 'video/mp4') mediaType = 'VIDEO';

      return {
        url: result.url,
        type: mediaType,
        mimeType: file.mimetype,
        fileName: file.originalname,
        size: file.size,
      };
    })
  );

  const report = await reportService.createReport(
    { ...req.body, media: [...(bodyMedia || []), ...uploaded] },
    userId
  );

  res.status(201).json({
    success: true,
    message: 'Report created successfully',
    data: report,
  });
});

const getReportById = asyncHandler(async (req, res) => {
  const userId = req.user.sub;
  const role = req.user.role;

  const report = await reportService.getReportById(req.params.id, {
    requesterId: userId,
    role,
  });

  res.status(200).json({
    success: true,
    message: 'Report retrieved successfully',
    data: report,
  });
});

const getReports = asyncHandler(async (req, res) => {
  const userId = req.user.sub;
  const role = req.user.role;

  const result = await reportService.getReports({
    ...req.query,
    requesterId: userId,
    role,
  });

  res.status(200).json({
    success: true,
    message: 'Reports retrieved successfully',
    data: result.data,
    pagination: result.pagination,
  });
});

const updateReport = asyncHandler(async (req, res) => {
  const userId = req.user.sub;
  const role = req.user.role;

  const report = await reportService.updateReport(req.params.id, req.body, role, userId);

  res.status(200).json({
    success: true,
    message: 'Report updated successfully',
    data: report,
  });
});

const deleteReport = asyncHandler(async (req, res) => {
  const userId = req.user.sub;
  const role = req.user.role;

  const result = await reportService.deleteReport(req.params.id, role, userId);

  res.status(200).json({
    success: true,
    message: 'Report deleted successfully',
    data: result,
  });
});

module.exports = {
  createReport,
  getReportById,
  getReports,
  updateReport,
  deleteReport,
};