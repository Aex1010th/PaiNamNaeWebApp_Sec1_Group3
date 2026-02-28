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
      <div v-if="!report" class="text-center text-gray-500">
        ไม่พบข้อมูลการรายงานปัญหานี้
      </div>

      <div v-else>
        <!-- Title -->
        <h1 class="text-2xl font-semibold mb-8">
          {{ report.title }}
        </h1>

        <!-- Progress -->
        <div class="flex items-center mb-12">
          <template v-for="(step, index) in steps" :key="step.label">

            <div class="flex flex-col items-center">
              <div
                :class="stepClass(index)"
                class="w-14 h-14 flex items-center justify-center rounded-full"
              >
                <component :is="step.icon" class="w-5 h-5" />
              </div>
              <p class="mt-2 text-sm w-28 text-center">
                {{ step.label }}
              </p>
            </div>

            <div
              v-if="index !== steps.length - 1"
              :class="lineClass(index)"
              class="flex-1 h-1 mx-4 rounded"
            ></div>

          </template>
        </div>

        <div class="text-gray-600 mb-6">
          <p>รายงานเมื่อ: {{ formatDate(report.createdAt) }}</p>
          <p v-if="report.updatedAt">
            อัปเดตล่าสุด: {{ formatDate(report.updatedAt) }}
          </p>
        </div>
        <!--status-->
        <div class="p-6 rounded-xl bg-blue-50 mb-8">
          <h2 class="font-semibold mb-2">{{ report.status }}</h2>
          <p class="text-blue-700">
            {{ report.adminMessage || 'แอดมินได้รับรายงานของคุณแล้ว' }}
          </p>
        </div>

        <!--details-->
        <div class="bg-gray-50 rounded-2xl p-8 border border-gray-100 shadow-sm">
          <h2 class="text-xl font-bold mb-6 text-gray-800">ปัญหาที่คุณได้รายงานไว้</h2>
          
          <div class="space-y-6">

          <div>
            <h2 class="font-semibold mb-1">รายละเอียดปัญหา</h2>
            <p class="text-gray-700 whitespace-pre-line">
              {{ report.description }}
            </p>
          </div>

          <div>
            <h2 class="font-semibold mb-1">หมวดหมู่</h2>
            <p class="text-gray-700 capitalize">
              {{ report.category }}
            </p>
          </div>

          <div>
            <h2 class="font-semibold mb-1">ประเภทปัญหา</h2>
            <p class="text-gray-700">
              {{ report.tag }}
            </p>
          </div>

          <div v-if="report.images?.length">
            <h2 class="font-semibold mb-3">รูปภาพ</h2>
            <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
              <img
                v-for="(img, index) in report.images"
                :key="index"
                :src="img.url"
                @click="openPreview('image', img.url)"
                class="rounded-lg shadow object-cover h-40 w-full cursor-pointer hover:scale-105 transition"
              />
            </div>
          </div>

          <div v-if="report.videos?.length">
            <h2 class="font-semibold mb-3">วิดีโอ</h2>
            <div class="space-y-4">
              <video
                v-for="(video, index) in report.videos"
                :key="index"
                :src="video.url"
                @click="openPreview('video', video.url)"
                class="rounded-lg w-full h-full object-cover cursor-pointer hover:scale-105 transition"
              ></video>
            </div>
          </div>

          <div v-if="report.audios?.length">
            <h2 class="font-semibold mb-3">ไฟล์เสียง</h2>
            <div class="space-y-3">
              <div
                v-for="(audio, index) in report.audios"
                :key="index"
                @click="openPreview('audio', audio.url)"
                class="cursor-pointer p-3 bg-gray-100 rounded hover:bg-gray-200"
              >
                คลิกเพื่อฟังเสียง
              </div>
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

      <img
        v-if="preview.type === 'image'"
        :src="preview.url"
        class="w-full max-h-[80vh] object-contain rounded-lg"
      />

      <video
        v-if="preview.type === 'video'"
        :src="preview.url"
        controls
        autoplay
        class="w-full max-h-[80vh] rounded-lg"
      ></video>

      <div
        v-if="preview.type === 'audio'"
        class="bg-white p-6 rounded-lg"
      >
        <audio
          :src="preview.url"
          controls
          autoplay
          class="w-full"
        ></audio>
      </div>

    </div>
  </div>
</template>

<script setup>
import {
  DocumentTextIcon,
  UserIcon,
  ArrowPathIcon,
  CheckIcon
} from '@heroicons/vue/24/outline'
const route = useRoute()
const reports = useState('reports', () => [])

const report = computed(() =>
  reports.value.find(r => r.id == route.params.id)
)

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('th-TH')
}

// cd frontend แล้วติดตั้ง npm install @heroicons/vue 
const steps = [
  { label: 'ส่งรายงานปัญหาแล้ว', icon: DocumentTextIcon },
  { label: 'แอดมินรับเรื่อง', icon: UserIcon },
  { label: 'กำลังดำเนินการ', icon: ArrowPathIcon },
  { label: 'เสร็จสิ้น', icon: CheckIcon }
]

const getCurrentIndex = () => {
  return steps.findIndex(s => s.label === report.value?.status)
}

// สีสถานะถ้าทำไปแล้วสีเขีียว กำลังทำอยู่สีน้ำเงิน ยังไม่ทำสีเทา
const stepClass = (index) => {
  const current = getCurrentIndex()

  if (index < current) {
    return 'bg-green-500 text-white'
  }

  if (index === current) {
    return 'bg-blue-500 text-white'
  }

  return 'bg-gray-200 text-gray-600'
}
// ถ้าก่อนหน้ากลมนี้เส็นแล้วเส้นจะสีเขียว ยังไม่เสร็จสีเทา
const lineClass = (index) => {
  const current = getCurrentIndex()
  return index < current ? 'bg-green-500' : 'bg-gray-300'
}

/* ----------Preview Logic---------- */

const preview = ref({
  show: false,
  type: null,
  url: null
})

const openPreview = (type, url) => {
  preview.value = {
    show: true,
    type,
    url
  }
}

const closePreview = () => {
  preview.value.show = false
}
</script>