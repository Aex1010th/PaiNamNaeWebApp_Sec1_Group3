<template>
  <div class="flex items-start justify-center min-h-screen py-8 bg-gray-100">
    <div
      class="flex w-full max-w-6xl mx-4 overflow-hidden bg-white border border-gray-300 rounded-lg shadow-lg"
    >
      <ProfileSidebar />

      <main class="flex-1 p-8">

        <div class="mb-8 text-center">
          <div
            class="inline-flex items-center justify-center w-16 h-16 mb-4 bg-blue-600 rounded-full"
          >
            <svg
              class="w-8 h-8 text-white"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M5 5v14M5 5c5 0 5 4 10 4s5-4 5-4v10s0 4-5 4-5-4-10-4"
              />
            </svg>
          </div>

          <h1 class="mb-2 text-3xl font-bold text-gray-800">
            ประวัติการรายงานปัญหา
          </h1>
          <p class="max-w-md mx-auto text-gray-600">
            ตรวจสอบรายการรายงานปัญหาของคุณ
          </p>
        </div>

        <div
          v-if="reports.length === 0"
          class="py-10 text-center text-gray-500"
        >
          ยังไม่มีประวัติการรายงานปัญหา
        </div>

        <!--รายการรายงาน-->
        <div v-else>
          <NuxtLink
            v-for="report in reports"
            :key="report.id"
            :to="`/report/history/${report.id}`"
            class="block p-5 mb-4 transition border border-gray-200 rounded-lg cursor-pointer hover:shadow-md hover:border-red-400"
          >
            <div class="text-lg font-semibold text-red-600">
              {{ report.title }}
            </div>

            <div class="mt-1 text-sm text-gray-500">
              รายงานเมื่อ {{ formatDate(report.createdAt) }}
            </div>

            <div class="mt-2 text-sm">
              <span
                class="px-3 py-1 text-white rounded-full"
                :class="statusColor(report.status)"
              >
                {{ report.status }}
              </span>
            </div>
          </NuxtLink>
        </div>
      </main>
    </div>
  </div>
</template>

<script setup>
import ProfileSidebar from '~/components/ProfileSidebar.vue'

definePageMeta({
  middleware: 'auth'
})

const reports = useState('reports', () => [])

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('th-TH')
}

const statusColor = (status) => {
  switch (status) {
    case 'ส่งรายงานปัญหาแล้ว':
      return 'bg-orange-400'
    case 'แอดมินรับเรื่อง':
      return 'bg-yellow-500'
    case 'กำลังดำเนินการ':
      return 'bg-blue-500'
    case 'เสร็จสิ้น':
      return 'bg-green-600'
    default:
      return 'bg-gray-400'
  }
}
</script>