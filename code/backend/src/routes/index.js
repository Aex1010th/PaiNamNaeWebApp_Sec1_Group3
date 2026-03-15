const express = require('express');
const authRoutes = require('./auth.routes');
const userRoutes = require('../../../../backend/src/routes/user.routes');
const vehicleRoutes = require('../../../../backend/src/routes/vehicle.routes');
const routeRoutes   = require('../../../../backend/src/routes/route.routes');
const driverVerifRoutes = require('./driverVerification.routes');
const bookingRoutes = require('./booking.routes');
const notificationRoutes = require('../../../../backend/src/routes/notification.routes')
const mapRoutes = require('../../../../backend/src/routes/maps.routes')
const reportRoutes = require('../../../../backend/src/routes/report.routes');

const router = express.Router();

router.use('/auth', authRoutes);
router.use('/users', userRoutes);
router.use('/vehicles', vehicleRoutes);
router.use('/routes', routeRoutes);
router.use('/driver-verifications', driverVerifRoutes);
router.use('/bookings', bookingRoutes);
router.use('/notifications', notificationRoutes);
router.use('/api/maps', mapRoutes);
router.use('/reports', reportRoutes);

module.exports = router;