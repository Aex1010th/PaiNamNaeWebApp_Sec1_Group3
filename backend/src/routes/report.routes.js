const express = require('express');
const validate = require('../middlewares/validate');
const { protect, requireAdmin } = require('../middlewares/auth');
const reportController = require('../controllers/report.controller');
const {
  createReportSchema,
  updateReportSchema,
  reportIdParamSchema,
  getReportsQuerySchema,
} = require('../validations/report.validation');

const router = express.Router();

router.get(
  '/admin',
  protect,
  requireAdmin,
  validate({ query: getReportsQuerySchema }),
  reportController.getReports
);

router.get(
  '/admin/:id',
  protect,
  requireAdmin,
  validate({ params: reportIdParamSchema }),
  reportController.getReport
);

router.patch(
  '/admin/:id',
  protect,
  requireAdmin,
  validate({ params: reportIdParamSchema, body: updateReportSchema }),
  reportController.updateReport
);

router.delete(
  '/admin/:id',
  protect,
  requireAdmin,
  validate({ params: reportIdParamSchema }),
  reportController.deleteReport
);

router.post(
  '/',
  protect,
  validate({ body: createReportSchema }),
  reportController.createReport
);

router.get(
  '/',
  protect,
  validate({ query: getReportsQuerySchema }),
  reportController.getReports
);

router.get(
  '/:id',
  protect,
  validate({ params: reportIdParamSchema }),
  reportController.getReport
);

router.patch(
  '/:id',
  protect,
  validate({ params: reportIdParamSchema, body: updateReportSchema }),
  reportController.updateReport
);

router.delete(
  '/:id',
  protect,
  validate({ params: reportIdParamSchema }),
  reportController.deleteReport
);

module.exports = router;