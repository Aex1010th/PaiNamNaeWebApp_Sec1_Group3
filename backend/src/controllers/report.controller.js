const asyncHandler = require('express-async-handler');
const reportService = require('../services/report.service');

const createReport = asyncHandler(async (req, res) => {
  const userId = req.user.sub;

  const report = await reportService.createReport(req.body, userId);

  res.status(201).json({
    success: true,
    message: 'Report created successfully',
    data: report,
  });
});

const getReport = asyncHandler(async (req, res) => {
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
  getReport,
  getReports,
  updateReport,
  deleteReport,
};