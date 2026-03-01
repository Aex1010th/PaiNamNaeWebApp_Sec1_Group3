const prisma = require('../utils/prisma');
const ApiError = require('../utils/ApiError');
const { ReportStatus, ReportType, ReportCategory } = require('@prisma/client');

const LIST_SELECT = {
	id: true,
	reporterId: true,
	targetUserId: true,
	targetUser: {
		select: {
			id: true,
			firstName: true,
			lastName: true,
		},
	},
	routeId: true,
	type: true,
	category: true,
	title: true,
	description: true,
	media: true,
	status: true,
	receivedAt: true,
	inProgressAt: true,
	resolvedAt: true,
	rejectedAt: true,
	adminReply: true,
	adminId: true,
	createdAt: true,
	updatedAt: true,
};

const DETAIL_SELECT = {
	...LIST_SELECT,
	reporter: {
		select: {
			id: true,
			firstName: true,
			lastName: true,
			profilePicture: true,
		},
	},
	targetUser: {
		select: {
			id: true,
			firstName: true,
			lastName: true,
			profilePicture: true,
		},
	},
};

const normalizeRole = (role) => (role === 'ADMIN' ? 'ADMIN' : 'USER');

const ensureRelatedEntities = async ({ routeId, targetUserId }) => {
	if (routeId) {
		const route = await prisma.route.findUnique({
			where: { id: routeId },
			select: { id: true },
		});

		if (!route) {
			throw new ApiError(404, 'Route not found');
		}
	}

	if (targetUserId) {
		const user = await prisma.user.findUnique({
			where: { id: targetUserId },
			select: { id: true },
		});

		if (!user) {
			throw new ApiError(404, 'Target user not found');
		}
	}
};

const validateConditionalFields = ({ category, type, routeId, targetUserId }) => {
	if (category === ReportCategory.TRIP && type !== ReportType.PASSENGER_BEHAVIOR && !routeId) {
		throw new ApiError(400, 'routeId is required for TRIP reports except PASSENGER_BEHAVIOR');
	}

	if (type === ReportType.PASSENGER_BEHAVIOR && !targetUserId) {
		throw new ApiError(400, 'targetUserId is required for PASSENGER_BEHAVIOR reports');
	}
};

const createReport = async (data, reporterId) => {
	validateConditionalFields(data);
	await ensureRelatedEntities(data);

	return prisma.report.create({
		data: {
			reporterId,
			targetUserId: data.targetUserId || null,
			routeId: data.routeId || null,
			type: data.type || null,
			category: data.category,
			title: data.title,
			description: data.description,
			media: data.media || null,
		},
		select: DETAIL_SELECT,
	});
};

const getReportById = async (id, opts = {}) => {
	const report = await prisma.report.findUnique({
		where: { id },
		select: DETAIL_SELECT,
	});

	if (!report) {
		throw new ApiError(404, 'Report not found');
	}

	if (normalizeRole(opts.role) !== 'ADMIN' && report.reporterId !== opts.requesterId) {
		throw new ApiError(403, 'Forbidden');
	}

	return report;
};

const getReports = async (opts = {}) => {
	const page = Number(opts.page || 1);
	const limit = Number(opts.limit || 20);
	const q = opts.q?.trim();
	const role = normalizeRole(opts.role);
	const sortOrder = opts.sortOrder === 'asc' ? 'asc' : 'desc';

	const where = {
		...(role !== 'ADMIN' ? { reporterId: opts.requesterId } : {}),
		...(opts.status ? { status: opts.status } : {}),
		...(opts.type ? { type: opts.type } : {}),
		...(opts.category ? { category: opts.category } : {}),
		...(q
			? {
				OR: [
					{ title: { contains: q, mode: 'insensitive' } },
					{ description: { contains: q, mode: 'insensitive' } },
				],
			}
			: {}),
	};

	const skip = (page - 1) * limit;

	const [total, data] = await prisma.$transaction([
		prisma.report.count({ where }),
		prisma.report.findMany({
			where,
			select: LIST_SELECT,
			orderBy: { createdAt: sortOrder },
			skip,
			take: limit,
		}),
	]);

	return {
		data,
		pagination: {
			page,
			limit,
			total,
			totalPages: Math.ceil(total / limit),
		},
	};
};

const updateReport = async (id, data, role, requesterId) => {
	const currentReport = await prisma.report.findUnique({
		where: { id },
		select: {
			id: true,
			reporterId: true,
			category: true,
			type: true,
			routeId: true,
			targetUserId: true,
			status: true,
		},
	});

	if (!currentReport) {
		throw new ApiError(404, 'Report not found');
	}

	const normalizedRole = normalizeRole(role);
	if (normalizedRole !== 'ADMIN' && currentReport.reporterId !== requesterId) {
		throw new ApiError(403, 'Forbidden');
	}

	const nextCategory = data.category ?? currentReport.category;
	const nextType = data.type ?? currentReport.type;
	const nextRouteId = data.routeId ?? currentReport.routeId;
	const nextTargetUserId = data.targetUserId ?? currentReport.targetUserId;

	validateConditionalFields({
		category: nextCategory,
		type: nextType,
		routeId: nextRouteId,
		targetUserId: nextTargetUserId,
	});

	await ensureRelatedEntities({ routeId: data.routeId, targetUserId: data.targetUserId });

	const updateData = {};

	if (data.title !== undefined) updateData.title = data.title;
	if (data.description !== undefined) updateData.description = data.description;
	if (data.type !== undefined) updateData.type = data.type;
	if (data.category !== undefined) updateData.category = data.category;
	if (data.media !== undefined) updateData.media = data.media;
	if (data.routeId !== undefined) updateData.routeId = data.routeId;
	if (data.targetUserId !== undefined) updateData.targetUserId = data.targetUserId;

	if (normalizedRole === 'ADMIN') {
		if (data.status !== undefined) {
			updateData.status = data.status;

			if (data.status === ReportStatus.IN_PROGRESS) {
				updateData.inProgressAt = new Date();
			}
			if (data.status === ReportStatus.RESOLVED) {
				updateData.resolvedAt = new Date();
			}
			if (data.status === ReportStatus.REJECTED) {
				updateData.rejectedAt = new Date();
			}
		}

		if (data.adminReply !== undefined) {
			updateData.adminReply = data.adminReply;
			updateData.adminId = requesterId;
		}
	} else {
		if (data.status !== undefined || data.adminReply !== undefined) {
			throw new ApiError(403, 'Forbidden');
		}

		if (currentReport.status !== ReportStatus.RECEIVED) {
			throw new ApiError(400, 'Only reports in RECEIVED status can be updated');
		}
	}

	return prisma.report.update({
		where: { id },
		data: updateData,
		select: DETAIL_SELECT,
	});
};

const deleteReport = async (id, role, requesterId) => {
	throw new ApiError(403, 'Deleting reports is not allowed');
};

module.exports = {
	createReport,
	getReportById,
	getReports,
	updateReport,
	deleteReport,
};
