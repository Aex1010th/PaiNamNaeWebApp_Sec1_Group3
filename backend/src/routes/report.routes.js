const express = require('express');
const validate = require('../middlewares/validate');
const { protect, requireAdmin } = require('../middlewares/auth');
const reportController = require('../controllers/report.controller');
const router = express.Router();
const {
  reportIdParamSchema,
  createReportSchema,
  updateReportSchema,
  getReportsQuerySchema,
} = require('../validations/report.validation');

// Get all reports (
router.get(
    '/admin',
    protect,
    requireAdmin,
    validate({ query: getReportsQuerySchema }),
    reportController.getReports
);

// Get report by ID
router.get(
    '/admin/:id',
    protect,
    requireAdmin,
    validate({ params: reportIdParamSchema }),
    reportController.getReportById
);

// Admin update report status
router.patch(
    '/admin/:id',
    protect,
    requireAdmin,
    validate({ params: reportIdParamSchema, body: updateReportSchema }),
    reportController.updateReport
);

// User get All reports
router.get(
    '/me',
    protect,
    validate({ query: getReportsQuerySchema }),
    reportController.getReports
);

// User get report by ID
router.get(
    '/me/:id',
    protect,
    validate({ params: reportIdParamSchema }),
    reportController.getReportById
);

// POST  Create a new report
router.post(
  '/',
  protect,
  validate({ body: createReportSchema }),
  reportController.createReport
);

module.exports = router;