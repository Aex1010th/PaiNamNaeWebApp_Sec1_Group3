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
          <p class="max-w-md mx-auto text-gray-500">ติดตามสถานะและรายละเอียดของปัญหาที่คุณรายงาน</p>
        </div>

        <!-- Stats bar -->
        <div class="grid grid-cols-3 gap-3 mb-6 mt-6">
  
          <div class="block p-5 transition border border-gray-200 rounded-2xl text-center hover:shadow-md">
            <span class="block text-2xl font-bold text-blue-600">{{ totalReports }}</span>
            <span class="block text-xs text-gray-400 mt-0.5">รายงานทั้งหมด</span>
          </div>

          <div class="block p-5 transition border border-gray-200 rounded-2xl text-center hover:shadow-md">
            <span class="block text-2xl font-bold text-blue-600">{{ inProgressCount }}</span>
            <span class="block text-xs text-gray-400 mt-0.5">กำลังดำเนินการ</span>
          </div>

          <div class="block p-5 transition border border-gray-200 rounded-2xl text-center hover:shadow-md">
            <span class="block text-2xl font-bold text-blue-600">{{ resolvedCount }}</span>
            <span class="block text-xs text-gray-400 mt-0.5 flex items-center justify-center gap-1">
            <svg width="14" height="14" viewBox="0 0 24 24" fill="#22c55e" stroke="white" stroke-width="2">
              <circle cx="12" cy="12" r="10"/>
              <path stroke-linecap="round" stroke-linejoin="round" d="M8 12l3 3 5-5"/>
            </svg>
              เสร็จสิ้น
            </span>
          </div>
        </div>

        <div v-if="pending" class="py-10 text-center text-gray-400">กำลังโหลดข้อมูล...</div>
        <div v-else-if="error" class="py-10 text-center text-red-500">เกิดข้อผิดพลาด: {{ error.message }}</div>
        <div v-else-if="reports.length === 0" class="py-10 text-center text-gray-500">ยังไม่มีประวัติการรายงานปัญหา</div>

        <div v-else>
          <NuxtLink
            v-for="report in reports"
            :key="report.id"
            :to="`/report/history/${report.id}`"
            class="block p-5 mb-4 transition border border-gray-200 rounded-2xl cursor-pointer hover:shadow-md"
          >
            <div class="flex items-center justify-between mb-2">
              <div class="text-lg font-semibold text-blue-600">{{ report.title }}</div>
              <span class="px-3 py-1 text-xs font-medium rounded-full border" :class="statusColor(report.status)">
                {{ statusLabel(report.status) }}
              </span>
            </div>
            <div class="mt-1 flex items-center gap-1 text-sm text-gray-500">
              <!-- clock icon -->
              <svg xmlns="http://www.w3.org/2000/svg" 
                   class="w-4 h-4 text-gray-400"
                   fill="none" 
                   viewBox="0 0 24 24" 
                   stroke="currentColor">
                <path stroke-linecap="round" 
                      stroke-linejoin="round" 
                      stroke-width="2" 
                      d="M12 8v4l3 3M12 22a10 10 0 100-20 10 10 0 000 20z"/>
              </svg>
              รายงานเมื่อ {{ formatDate(report.createdAt) }}
            </div>
            <div
              v-if="report.targetUserId"
              class="mt-1 flex items-center gap-1 text-sm text-gray-500">
                <!-- user icon -->
              <svg xmlns="http://www.w3.org/2000/svg"
                   class="w-4 h-4 text-gray-500"
                   fill="none"
                   viewBox="0 0 24 24"
                   stroke="currentColor">
                <path stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M20 21v-2a4 4 0 00-4-4H8a4 4 0 00-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
             </svg>
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

const totalReports = computed(() => reports.value.length)

const inProgressCount = computed(() =>
  reports.value.filter(r => r.status === 'IN_PROGRESS').length
)

const resolvedCount = computed(() =>
  reports.value.filter(r => r.status === 'RESOLVED').length
)

const statusLabel = (status) => ({
  'RECEIVED':    'ส่งรายงานปัญหาแล้ว',
  'IN_PROGRESS': 'กำลังดำเนินการ',
  'RESOLVED':    'เสร็จสิ้น',
  'REJECTED':    'ถูกปฏิเสธ',
})[status] ?? status

const statusColor = (status) => ({
  'RECEIVED': 'bg-orange-50 text-orange-700 border-orange-200',
  'IN_PROGRESS': 'bg-blue-50 text-blue-700 border-blue-200',
  'RESOLVED': 'bg-emerald-50 text-emerald-700 border-emerald-200',
  'REJECTED': 'bg-red-50 text-red-700 border-red-200',
})[status] ?? 'bg-gray-50 text-gray-700 border-gray-200'
</script>