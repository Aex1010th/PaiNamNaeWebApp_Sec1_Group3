<template>
  <div class="flex items-start justify-center min-h-screen py-8 bg-gray-100">
    <div class="flex w-full max-w-6xl mx-4 overflow-hidden bg-white border border-gray-300 rounded-lg shadow-lg">
      <ProfileSidebar />

      <main class="flex-1 p-8">
        <div class="mb-8 text-center">
          <div class="inline-flex items-center justify-center w-16 h-16 mb-4 bg-blue-600 rounded-full">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M5 5v14M5 5c5 0 5 4 10 4s5-4 5-4v10s0 4-5 4-5-4-10-4" />
            </svg>
          </div>
          <h1 class="mb-2 text-3xl font-bold text-gray-800">ประวัติการรายงานปัญหา</h1>
          <p class="max-w-md mx-auto text-gray-600">ตรวจสอบรายการรายงานปัญหาของคุณ</p>
        </div>

        <div v-if="pending" class="py-10 text-center text-gray-400">กำลังโหลดข้อมูล...</div>
        <div v-else-if="error" class="py-10 text-center text-red-500">เกิดข้อผิดพลาด: {{ error.message }}</div>
        <div v-else-if="reports.length === 0" class="py-10 text-center text-gray-500">ยังไม่มีประวัติการรายงานปัญหา</div>

        <div v-else>
          <NuxtLink
            v-for="report in reports"
            :key="report.id"
            :to="`/report/history/${report.id}`"
            class="block p-5 mb-4 transition border border-gray-200 rounded-lg cursor-pointer hover:shadow-md"
          >
            <div class="flex items-center justify-between">
              <div class="text-lg font-semibold text-blue-600">{{ report.title }}</div>
              <span class="px-3 py-1 text-xs text-white rounded-full" :class="statusColor(report.status)">
                {{ statusLabel(report.status) }}
              </span>
            </div>
            <div class="mt-1 text-sm text-gray-500">
              รายงานเมื่อ {{ formatDate(report.createdAt) }}
            </div>
            <div
              v-if="report.targetUserId"
              class="mt-1 text-sm text-gray-600"
            >
              ผู้ถูกรายงาน: {{ targetUserName(report) }}
            </div>
          </NuxtLink>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import ProfileSidebar from '~/components/ProfileSidebar.vue'

definePageMeta({ middleware: 'auth' })

const { $api } = useNuxtApp()

const { data: apiResponse, pending, error } = await useAsyncData('user-reports', async () => {
  const token = useCookie('token').value
  if (!token) throw createError({ statusCode: 401, message: 'กรุณาเข้าสู่ระบบก่อน' })

  const response = await $api('reports/me')
  return Array.isArray(response) ? response : []
})

const reports = computed(() => apiResponse.value ?? [])

const targetUserName = (report) => {
  const firstName = report?.targetUser?.firstName || ''
  const lastName = report?.targetUser?.lastName || ''
  const fullName = `${firstName} ${lastName}`.trim()
  return fullName || 'ไม่ระบุชื่อ'
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('th-TH')
}

const statusLabel = (status) => ({
  'RECEIVED':    'ส่งรายงานปัญหาแล้ว',
  'IN_PROGRESS': 'กำลังดำเนินการ',
  'RESOLVED':    'เสร็จสิ้น',
  'REJECTED':    'ถูกปฏิเสธ',
})[status] ?? status

const statusColor = (status) => ({
  'RECEIVED':    'bg-orange-400',
  'IN_PROGRESS': 'bg-blue-500',
  'RESOLVED':    'bg-green-600',
  'REJECTED':    'bg-red-500',
})[status] ?? 'bg-gray-400'
</script>