import express from 'express';
import { route } from './user.routes';
import upload from '../middlewares/upload.middleware';
const { protect, requireAdmin } = require('../middlewares/auth');
const validate = require('../middlewares/validate');
const router = express.Router();

// Get all reports (
router.get(
    '/admin',
    protect,
    requireAdmin,
    validate({ query: listReportsQuerySchema }),
    reportController.admin.ListReports
);

// Get report by ID
router.get(
    '/admin/:id',
    protect,
    requireAdmin,
    validate({ params: reportIdschema }),
    reportController.admin.GetReportById
);

// Admin update report status
router.patch(
    '/admin/:id/status',
    protect,
    requireAdmin,
    validate({ params: reportIdschema, body: updateReportStatusSchema }),
    reportController.admin.UpdateReportStatus
);

// User get All reports
router.get(
    '/me',
    protect,
    validate({ query: listMyReportsQuerySchema }),
    reportController.getMyReports
);

// User get report by ID
router.get(
    '/me/:id',
    protect,
    validate({ params: reportIdschema }),
    reportController.getMyReportById
);

route.post(
    '/',
    protect,
    upload.fields([
    { name: 'images' },
    { name: 'videos' },
    { name: 'audios' }
  ]),
    validate({ body: createReportSchema }),
    reportController.createReport
);

module.exports = router;