<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-100 p-6">
    <div class="w-full max-w-3xl bg-white p-8 rounded-lg shadow-lg">

      <div v-if="!report" class="text-center text-gray-500">
        ไม่พบข้อมูลรายงานนี้
      </div>

      <div v-else>
        <h1 class="text-2xl font-bold text-red-600 mb-4">
          {{ report.title }}
        </h1>

        <p class="text-gray-600 mb-2">
          รายงานเมื่อ: {{ formatDate(report.createdAt) }}
        </p>

        <p class="mb-4">
          สถานะ:
          <span class="px-3 py-1 rounded-full text-white"
                :class="statusColor(report.status)">
            {{ report.status }}
          </span>
        </p>

        <div class="mt-4">
          <h2 class="font-semibold mb-2">รายละเอียด</h2>
          <p class="text-gray-700">
            {{ report.description }}
          </p>
        </div>
      </div>

    </div>
  </div>
</template>

<script setup>
const route = useRoute()

//ดึง state เดิม
const reports = useState('reports', () => [])

//หา report ตาม id
const report = computed(() =>
  reports.value.find(r => r.id == route.params.id)
)

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('th-TH')
}

//สีสถานะ
const statusColor = (status) => {
  switch (status) {
    case 'ส่งรายงานปัญหาแล้ว':
      return 'bg-orange-500'
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