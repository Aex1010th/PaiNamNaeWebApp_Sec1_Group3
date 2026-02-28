const { z } = require('zod');
const { ReportType, ReportCategory, ReportStatus } = require('@prisma/client');

const MEDIA_TYPES = ['FILE', 'AUDIO', 'IMAGE', 'VIDEO'];

const mediaItemSchema = z.object({
	url: z.string({ required_error: 'media.url is required' }).url('media.url must be a valid URL'),
	type: z.enum(MEDIA_TYPES, {
		required_error: 'media.type is required',
		invalid_type_error: 'media.type must be one of FILE, AUDIO, IMAGE, VIDEO',
	}),
	mimeType: z.string().min(1, 'media.mimeType cannot be empty').optional(),
	fileName: z.string().min(1, 'media.fileName cannot be empty').optional(),
	size: z.number().nonnegative('media.size must be greater than or equal to 0').optional(),
});

const createReportSchema = z
	.object({
		title: z
			.string({ required_error: 'title is required' })
			.trim()
			.min(3, 'title must be at least 3 characters long'),
		description: z
			.string({ required_error: 'description is required' })
			.trim()
			.min(1, 'description is required'),
		type: z.nativeEnum(ReportType, { invalid_type_error: 'Invalid report type' }).optional(),
		category: z.nativeEnum(ReportCategory, {
			required_error: 'category is required',
			invalid_type_error: 'Invalid report category',
		}),
		targetUserId: z.string().cuid('targetUserId must be a valid user ID').optional(),
		routeId: z.string().cuid('routeId must be a valid route ID').optional(),
		media: z
			.array(mediaItemSchema, { invalid_type_error: 'media must be an array' })
			.max(3, 'media can contain at most 3 files')
			.nullable()
			.optional(),
	})
	.refine((data) => !(data.category === ReportCategory.TRIP && !data.routeId), {
		message: 'routeId is required when category is TRIP',
		path: ['routeId'],
	})
	.refine((data) => !(data.type === ReportType.PASSENGER_BEHAVIOR && !data.targetUserId), {
		message: 'targetUserId is required for PASSENGER_BEHAVIOR reports',
		path: ['targetUserId'],
	});

const updateReportSchema = z
	.object({
		title: z.string().trim().min(3, 'title must be at least 3 characters long').optional(),
		description: z.string().trim().min(1, 'description cannot be empty').optional(),
		type: z.nativeEnum(ReportType, { invalid_type_error: 'Invalid report type' }).optional(),
		category: z.nativeEnum(ReportCategory, { invalid_type_error: 'Invalid report category' }).optional(),
		targetUserId: z.string().cuid('targetUserId must be a valid user ID').optional(),
		routeId: z.string().cuid('routeId must be a valid route ID').optional(),
		media: z
			.array(mediaItemSchema, { invalid_type_error: 'media must be an array' })
			.max(3, 'media can contain at most 3 files')
			.nullable()
			.optional(),
		status: z.nativeEnum(ReportStatus, { invalid_type_error: 'Invalid report status' }).optional(),
		adminReply: z.string().trim().min(1, 'adminReply cannot be empty').optional(),
	})
	.refine((data) => Object.keys(data).length > 0, {
		message: 'At least one field is required to update report',
	})
	.refine((data) => !(data.category === ReportCategory.TRIP && !data.routeId), {
		message: 'routeId is required when category is TRIP',
		path: ['routeId'],
	})
	.refine((data) => !(data.type === ReportType.PASSENGER_BEHAVIOR && !data.targetUserId), {
		message: 'targetUserId is required for PASSENGER_BEHAVIOR reports',
		path: ['targetUserId'],
	});

const reportIdParamSchema = z.object({
	id: z.string().cuid('Invalid report ID format'),
});

const getReportsQuerySchema = z.object({
	page: z.coerce.number().int().min(1).default(1),
	limit: z.coerce.number().int().min(1).max(100).default(20),
	q: z.string().trim().min(1).optional(),
	status: z.nativeEnum(ReportStatus).optional(),
	type: z.nativeEnum(ReportType).optional(),
	category: z.nativeEnum(ReportCategory).optional(),
	sortOrder: z.enum(['asc', 'desc']).default('desc'),
});

module.exports = {
	createReportSchema,
	updateReportSchema,
	reportIdParamSchema,
	getReportsQuerySchema,
};
