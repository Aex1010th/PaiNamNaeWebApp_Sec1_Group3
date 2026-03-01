const asyncHandler = require('express-async-handler');
const reportService = require('../services/report.service');
const upload = require('../middlewares/upload.middleware');

const createReport = asyncHandler(async (req, res) => {
  const userId = req.user.sub;

  const uploadedMedia = [
    ...(req.files?.images || []).map(f => ({
      url: f.path,
      type: 'IMAGE',
      mimeType: f.mimetype,
      fileName: f.originalname,
      size: f.size,
    })),
    ...(req.files?.videos || []).map(f => ({
      url: f.path,
      type: 'VIDEO',
      mimeType: f.mimetype,
      fileName: f.originalname,
      size: f.size,
    })),
    ...(req.files?.audios || []).map(f => ({
      url: f.path,
      type: 'AUDIO',
      mimeType: f.mimetype,
      fileName: f.originalname,
      size: f.size,
    })),
  ];

  const bodyMedia = req.body.media
    ? (typeof req.body.media === 'string' ? JSON.parse(req.body.media) : req.body.media)
    : [];

  const report = await reportService.createReport(
    { ...req.body, media: [...bodyMedia, ...uploadedMedia] },
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