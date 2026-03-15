const prisma = require('../utils/prisma');
const ApiError = require('../utils/ApiError');
const { BookingStatus, RouteStatus } = require('@prisma/client');

const REVIEW_SELECT = {
  id: true,
  bookingId: true,
  routeId: true,
  passengerId: true,
  driverId: true,
  rating: true,
  comment: true,
  tags: true,
  media: true,
  createdAt: true,
  updatedAt: true,
};

const REVIEW_LIST_SELECT = {
  id: true,
  bookingId: true,
  routeId: true,
  passengerId: true,
  driverId: true,
  rating: true,
  comment: true,
  tags: true,
  media: true,
  createdAt: true,
  updatedAt: true,
  passenger: {
    select: {
      id: true,
      firstName: true,
      lastName: true,
      profilePicture: true,
    },
  },
  driver: {
    select: {
      id: true,
      firstName: true,
      lastName: true,
      profilePicture: true,
      createdAt: true,
    },
  },
  route: {
    select: {
      id: true,
      routeSummary: true,
      startLocation: true,
      endLocation: true,
    },
  },
};

const ensureReviewModelReady = () => {
  if (!prisma.review) {
    throw new ApiError(503, 'Review schema is not ready. Please run Prisma migrate and generate first.');
  }
};

const createReviewForBooking = async ({ bookingId, passengerId, rating, comment, tags, media }) => {
  ensureReviewModelReady();

  const booking = await prisma.booking.findUnique({
    where: { id: bookingId },
    include: {
      route: { select: { id: true, driverId: true, status: true } },
      review: { select: { id: true } },
    },
  });

  if (!booking) throw new ApiError(404, 'Booking not found');
  if (booking.passengerId !== passengerId) throw new ApiError(403, 'Forbidden');
  if (booking.review) throw new ApiError(409, 'You already reviewed this trip');
  if (booking.status !== BookingStatus.CONFIRMED) {
    throw new ApiError(400, 'Review is allowed only for confirmed bookings');
  }
  if (booking.route.status !== RouteStatus.COMPLETED) {
    throw new ApiError(400, 'Review is allowed only when route is completed');
  }
  if (booking.route.driverId === passengerId) {
    throw new ApiError(400, 'Driver cannot review own trip via passenger review');
  }

  const review = await prisma.$transaction(async (tx) => {
    const created = await tx.review.create({
      data: {
        bookingId,
        routeId: booking.route.id,
        passengerId,
        driverId: booking.route.driverId,
        rating,
        comment: comment || null,
        tags: tags || [],
        media: media?.length ? media : null,
      },
      select: REVIEW_SELECT,
    });

    await tx.notification.create({
      data: {
        userId: booking.route.driverId,
        type: 'BOOKING',
        title: 'คุณได้รับรีวิวใหม่',
        body: `ผู้โดยสารให้คะแนน ${rating} ดาวสำหรับทริปล่าสุด`,
        metadata: {
          kind: 'REVIEW_CREATED',
          reviewId: created.id,
          bookingId,
          routeId: booking.route.id,
          rating,
        },
      },
    });

    return created;
  });

  return review;
};

const getMyReviewByBooking = async (bookingId, passengerId) => {
  ensureReviewModelReady();

  const review = await prisma.review.findFirst({
    where: { bookingId, passengerId },
    select: REVIEW_SELECT,
  });

  return review;
};

const getDriverReviewSummary = async (driverId) => {
  ensureReviewModelReady();

  const [aggregateRows, starRows] = await prisma.$transaction([
    prisma.review.groupBy({
      by: ['driverId'],
      where: { driverId },
      _avg: { rating: true },
      _count: { _all: true },
    }),
    prisma.review.groupBy({
      by: ['driverId', 'rating'],
      where: { driverId },
      _count: { _all: true },
    }),
  ]);

  const agg = aggregateRows[0] || null;
  const breakdown = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };

  for (const row of starRows) {
    breakdown[row.rating] = row._count._all;
  }

  return {
    driverId,
    average: agg?._avg?.rating ? Number(agg._avg.rating.toFixed(2)) : 0,
    total: agg?._count?._all || 0,
    breakdown,
  };
};

const getDriverReviews = async (driverId) => {
  ensureReviewModelReady();

  const driver = await prisma.user.findUnique({
    where: { id: driverId },
    select: {
      id: true,
      firstName: true,
      lastName: true,
      profilePicture: true,
      createdAt: true,
    },
  });

  if (!driver) {
    throw new ApiError(404, 'Driver not found');
  }

  const [summary, reviews] = await Promise.all([
    getDriverReviewSummary(driverId),
    prisma.review.findMany({
      where: { driverId },
      select: REVIEW_LIST_SELECT,
      orderBy: { createdAt: 'desc' },
    }),
  ]);

  return {
    driver,
    summary,
    reviews,
  };
};

const getMyWrittenReviews = async (passengerId) => {
  ensureReviewModelReady();

  return prisma.review.findMany({
    where: { passengerId },
    select: REVIEW_LIST_SELECT,
    orderBy: { createdAt: 'desc' },
  });
};

module.exports = {
  createReviewForBooking,
  getMyReviewByBooking,
  getDriverReviewSummary,
  getDriverReviews,
  getMyWrittenReviews,
};
