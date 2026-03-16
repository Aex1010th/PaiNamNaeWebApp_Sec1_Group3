const { z } = require('zod');

const parseMaybeJson = (value) => {
  if (typeof value !== 'string') return value;
  const trimmed = value.trim();
  if (!trimmed) return undefined;
  try {
    return JSON.parse(trimmed);
  } catch {
    return value;
  }
};

const parseOptionalText = (value) => {
  if (value === undefined || value === null) return undefined;
  if (typeof value !== 'string') return value;
  const trimmed = value.trim();
  return trimmed.length ? trimmed : undefined;
};

const idParamSchema = z.object({
  bookingId: z.string().cuid({ message: 'Invalid booking ID format' }),
});

const driverIdParamSchema = z.object({
  driverId: z.string().cuid({ message: 'Invalid driver ID format' }),
});

const createReviewSchema = z.object({
  rating: z.preprocess((value) => Number(value), z.number().int().min(1).max(5)),
  comment: z.preprocess(parseOptionalText, z.string().max(500).optional()),
  tags: z.preprocess(parseMaybeJson, z.array(z.string().trim().min(1).max(50)).max(20).optional()),
  media: z.preprocess(parseMaybeJson, z.array(z.any()).optional()),
});

module.exports = {
  idParamSchema,
  driverIdParamSchema,
  createReviewSchema,
};
