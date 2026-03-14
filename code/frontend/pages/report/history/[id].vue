<template>
  <div class="min-h-screen bg-gray-100 flex justify-center pt-4">
    <div class="w-full max-w-5xl mx-auto">
      <div class="flex justify-start mb-2">
        <button
          @click="$router.back()"
          class="px-3 py-1.5 text-sm bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 transition"
        >
          ← กลับ
        </button>
      </div>

      <div class="w-full max-w-5xl bg-white p-8 rounded-xl shadow">

        <!-- Loading -->
        <div v-if="pending" class="text-center text-gray-400 py-10">
          กำลังโหลดข้อมูล...
        </div>

        <!-- Error -->
        <div v-else-if="error" class="text-center text-red-500 py-10">
          เกิดข้อผิดพลาด: {{ error.message }}
        </div>

        <!-- ไม่พบข้อมูล -->
        <div v-else-if="!report" class="text-center text-gray-500 py-10">
          ไม่พบข้อมูลการรายงานปัญหานี้
        </div>

        <div v-else>
          <h1 class="text-2xl font-semibold mb-8">{{ report.title }}</h1>

          <!-- Progress Steps -->
          <div class="flex items-center mb-12">
            <template v-for="(step, index) in steps" :key="step.key">
              <div class="flex flex-col items-center">
                <div
                  :class="stepClass(index)"
                  class="w-14 h-14 flex items-center justify-center rounded-full"
                >
                  <component :is="step.icon" class="w-5 h-5" />
                </div>
                <p class="mt-2 text-sm w-28 text-center">{{ step.label }}</p>
              </div>
              <div
                v-if="index !== steps.length - 1"
                :class="lineClass(index)"
                class="flex-1 h-1 mx-4 rounded"
              />
            </template>
          </div>

          <!-- วันที่ -->
          <div class="text-gray-600 mb-6 space-y-1">
           <p class="flex items-center gap-2">
              <!-- ไอคอนนาฬิกา -->
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
              รายงานเมื่อ: {{ formatDate(report.createdAt) }}
            </p>

            <p v-if="report.updatedAt" class="flex items-center gap-2">
              <!-- ไอคอนดินสอ -->
            <svg xmlns="http://www.w3.org/2000/svg"
                 class="w-4 h-4 text-gray-400"
                 fill="none"
                 viewBox="0 0 24 24"
                 stroke="currentColor">
              <path stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M11 5h2M16.5 3.5a2.121 2.121 0 113 3L7 19l-4 1 1-4 12.5-12.5z"/>
            </svg>
              อัปเดตล่าสุด: {{ formatDate(report.updatedAt) }}
            </p>
          </div>

          <!-- Status Box -->
          <div class="p-6 rounded-xl bg-blue-50 mb-8">
            <h2 class="font-semibold mb-2">{{ statusLabel(report.status) }}</h2>
            <p class="text-blue-700">
              {{ report.adminReply || 'แอดมินได้รับรายงานของคุณแล้ว' }}
            </p>
          </div>

          <!-- Details -->
          <div class="bg-gray-50 rounded-2xl p-8 border border-gray-100 shadow-sm">
            <h2 class="text-xl font-bold mb-6 text-gray-800">รายการปัญหาที่คุณรายงาน</h2>

            <div class="space-y-2">
              <div class="p-4 bg-white rounded-2xl shadow-sm">
                <h3 class="font-semibold mb-1">รายละเอียดปัญหา</h3>
                <p class="text-gray-700 whitespace-pre-line">{{ report.description }}</p>
              </div>

              <div class="p-4 bg-white rounded-2xl shadow-sm">
                <h3 class="font-semibold mb-1">หมวดหมู่</h3>
                <p class="text-gray-700">{{ categoryLabel(report.category) }}</p>
              </div>

              <div class="p-4 bg-white rounded-2xl shadow-sm">
                <h3 class="font-semibold mb-1">ประเภทปัญหา</h3>
                <p class="text-gray-700">{{ typeLabel(report.type) }}</p>
              </div>

              <div class="p-4 bg-white rounded-2xl shadow-sm">
                <h3 class="font-semibold mb-3">ไฟล์แนบ</h3>
                <!-- มีไฟล์ -->
                <div v-if="images.length || videos.length || audios.length">

                  <!-- รูปภาพ + วิดีโอ -->
                  <div v-if="images.length || videos.length">

                    <div class="grid grid-cols-3 md:grid-cols-4 gap-2">
                      <img
                        v-for="(img, i) in images"
                        :key="'img'+i"
                        :src="img.url"
                        @click="openPreview('image', img.url)"
                        class="rounded-lg shadow w-full aspect-square object-cover cursor-pointer hover:scale-[1.02] transition"
                      />

                      <video
                        v-for="(vid, i) in videos"
                        :key="'vid'+i"
                        :src="vid.url"
                        @click="openPreview('video', vid.url)"
                        class="rounded-lg shadow w-full aspect-square object-cover cursor-pointer hover:scale-[1.02] transition"
                      ></video>
                    </div>
                  </div>

                  <!-- เสียง -->
                  <div v-if="audios.length" class="mt-4">
                    <h3 class="font-semibold mb-3">ไฟล์เสียง</h3>

                    <div class="space-y-3">
                      <div
                        v-for="(aud, i) in audios"
                        :key="i"
                        @click="openPreview('audio', aud.url)"
                        class="cursor-pointer p-3 bg-gray-100 rounded hover:bg-gray-200"
                      >
                        คลิกเพื่อฟังเสียง
                      </div>
                    </div>
                  </div>

                </div>

                <!-- ไม่มีไฟล์เลย -->
                <div v-else class="text-sm text-gray-400">
                  ไม่มีไฟล์แนบ
                </div>

              </div>

            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Preview Modal -->
  <div
    v-if="preview.show"
    class="fixed inset-0 bg-white/40 backdrop-blur-sm flex items-center justify-center z-50"
    @click.self="closePreview"
  >
    <div class="relative max-w-5xl w-full px-4">
      <button
        @click="closePreview"
        class="absolute -top-12 right-0 bg-black/70 text-white w-10 h-10 rounded-full flex items-center justify-center hover:bg-black transition"
      >
        ✕
      </button>
      <img v-if="preview.type === 'image'" :src="preview.url" class="w-full max-h-[80vh] object-contain rounded-lg" />
      <video v-if="preview.type === 'video'" :src="preview.url" controls autoplay class="w-full max-h-[80vh] rounded-lg" />
      <div v-if="preview.type === 'audio'" class="bg-white p-6 rounded-lg">
        <audio :src="preview.url" controls autoplay class="w-full" />
      </div>
    </div>
  </div>
</template>

<script setup>
import {
  DocumentTextIcon,
  UserIcon,
  ArrowPathIcon,
  CheckIcon,
  XCircleIcon,
} from '@heroicons/vue/24/outline'

definePageMeta({ middleware: 'auth' })

const route = useRoute()
const { $api } = useNuxtApp()


const { data: report, pending, error } = await useAsyncData(
  `report-${route.params.id}`,
  async () => {
    const token = useCookie('token').value
    if (!token) throw createError({ statusCode: 401, message: 'กรุณาเข้าสู่ระบบก่อน' })

    const res = await $api(`reports/me/${route.params.id}`, {
      headers: { Authorization: `Bearer ${token}` }
    })
    return res.data ?? res
  }
)


const images = computed(() => report.value?.media?.filter(m => m.type === 'IMAGE') ?? [])
const videos = computed(() => report.value?.media?.filter(m => m.type === 'VIDEO') ?? [])
const audios = computed(() => report.value?.media?.filter(m => m.type === 'AUDIO') ?? [])


const steps = [
  { key: 'RECEIVED',    label: 'ส่งรายงานแล้ว',     icon: DocumentTextIcon },
  { key: 'IN_PROGRESS', label: 'กำลังดำเนินการ',     icon: ArrowPathIcon },
  { key: 'RESOLVED',    label: 'เสร็จสิ้น',          icon: CheckIcon },
  { key: 'REJECTED',    label: 'ถูกปฏิเสธ',          icon: XCircleIcon },
]


const getCurrentIndex = () => steps.findIndex(s => s.key === report.value?.status)

const stepClass = (index) => {
  const current = getCurrentIndex()
  if (report.value?.status === 'REJECTED') {
    return index === current ? 'bg-red-500 text-white' : 'bg-gray-200 text-gray-400'
  }
  if (index < current) return 'bg-green-500 text-white'
  if (index === current) return 'bg-blue-500 text-white'
  return 'bg-gray-200 text-gray-600'
}

const lineClass = (index) => {
  const current = getCurrentIndex()
  return index < current ? 'bg-green-500' : 'bg-gray-300'
}

// Label helpers
const statusLabel = (status) => ({
  'RECEIVED':    'ส่งรายงานปัญหาแล้ว',
  'IN_PROGRESS': 'กำลังดำเนินการ',
  'RESOLVED':    'เสร็จสิ้น',
  'REJECTED':    'ถูกปฏิเสธ',
})[status] ?? status

const categoryLabel = (cat) => ({
  'TRIP':    'การเดินทาง',
  'SERVICE': 'บริการ',
  'OTHER':   'อื่นๆ',
})[cat] ?? cat

const typeLabel = (type) => ({
  'PASSENGER_BEHAVIOR': 'พฤติกรรมผู้โดยสาร',
  'DRIVER_BEHAVIOR':    'พฤติกรรมคนขับ',
  'VEHICLE':            'ยานพาหนะ',
  'ROUTE':              'เส้นทาง',
  'OTHER':              'อื่นๆ',
})[type] ?? type ?? '-'

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('th-TH')
}

// Preview Modal
const preview = ref({ show: false, type: null, url: null })
const openPreview = (type, url) => { preview.value = { show: true, type, url } }
const closePreview = () => { preview.value.show = false }
</script>