<template>
  <div class="flex items-start justify-center min-h-screen py-8 bg-gray-100">
    <div class="flex w-full max-w-6xl mx-4 overflow-hidden bg-white border border-gray-300 rounded-lg shadow-lg">
      <main class="flex-1 p-8 overflow-y-auto">
<!-- Back button -->
      <div class="flex justify-end mb-1">
        <button @click="$router.back()" class="flex items-center gap-1.5 text-sm text-gray-500 hover:text-gray-700 hover:bg-gray-100 hover:shadow-sm px-3 py-1.5 rounded-lg transition-all duration-200">
          <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"/>
          </svg>
          กลับ
        </button>
      </div>

        <!-- Loading -->
        <div v-if="pending" class="py-20 text-center text-gray-400 text-sm">กำลังโหลดข้อมูล...</div>

        <!-- Error -->
        <div v-else-if="error" class="py-20 text-center text-red-400 text-sm">เกิดข้อผิดพลาด: {{ error.message }}</div>

        <template v-else>

          <!-- Driver Profile -->
          <div class="text-center mb-6">
            <div class="relative inline-block mb-3">
              <img
                :src="driver.profileImage || `https://ui-avatars.com/api/?name=${driver.firstName}+${driver.lastName}&background=1e3a5f&color=fff&size=96`"
                class="w-24 h-24 rounded-full object-cover border-4 border-white shadow-md"
              />
              <div class="absolute bottom-0 right-0 w-7 h-7 bg-blue-600 rounded-full flex items-center justify-center border-2 border-white">
                <svg width="12" height="12" fill="none" stroke="white" stroke-width="2.5" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
                </svg>
              </div>
            </div>
            <h1 class="text-2xl font-bold text-gray-800">{{ driver.firstName }} {{ driver.lastName }}</h1>
            <p class="text-sm text-gray-400 mt-0.5">
              ผู้ขับ<template v-if="driver.createdAt"> • เข้าร่วม {{ formatDate(driver.createdAt) }}</template>
            </p>            
            <div class="flex items-center justify-center gap-2 mt-3">
              <span class="flex items-center gap-1 px-3 py-1 text-xs font-medium bg-blue-50 text-blue-700 border border-blue-200 rounded-full">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="#fdc700" stroke="#fdc700" stroke-width="2">
                  <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                </svg>
                {{ ratingBadgeStyle.label }}
              </span>
            <!-- Trips badge -->
              <span class="flex items-center gap-1 px-3 py-1 text-xs font-medium bg-gray-100 text-gray-600 border border-gray-200 rounded-full">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
                   <path d="M5 11l1-3a2 2 0 012-1h8a2 2 0 012 1l1 3h1a1 1 0 011 1v3a1 1 0 01-1 1h-1a2 2 0 11-4 0H9a2 2 0 11-4 0H4a1 1 0 01-1-1v-3a1 1 0 011-1h1zm3-3l-1 3h10l-1-3H8z"/>
                </svg>
                {{ driver.totalTrips ?? 0 }}+ เที่ยว
              </span>
            </div>
          </div>

          <!-- Rating Overview -->
          <div class="flex gap-4 p-5 bg-gray-50 rounded-2xl border border-gray-200 mb-6">
            <!-- Big score -->
            <div class="text-center flex-shrink-0 pr-4 border-r border-gray-200 flex flex-col items-center justify-center">
              <div class="text-5xl font-bold text-gray-800">{{ avgRating }}</div>
              <div class="flex justify-center gap-0.5 mt-1.5 mb-1">
                <svg v-for="n in 5" :key="n" width="14" height="14" viewBox="0 0 24 24"
                  :fill="n <= Math.round(Number(avgRating)) ? '#fdc700' : 'none'"
                  :stroke="n <= Math.round(Number(avgRating)) ? '#fdc700' : '#d1d5db'"
                  stroke-width="2">
                  <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                </svg>
              </div>
              <p class="text-xs text-gray-400">{{ allReviews.length.toLocaleString() }} รีวิว</p>
            </div>

            <!-- Bar chart -->
            <div class="flex-1 space-y-1.5 justify-center flex flex-col">
              <div v-for="star in [5,4,3,2,1]" :key="star" class="flex items-center gap-2">
                <span class="text-xs text-gray-500 w-3">{{ star }}</span>
                <svg width="10" height="10" viewBox="0 0 24 24" fill="#fdc700" stroke="#fdc700" stroke-width="2" class="flex-shrink-0">
                  <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                </svg>
                <div class="flex-1 h-2 bg-gray-200 rounded-full overflow-hidden">
                  <div
                    class="h-full rounded-full transition-all duration-700"
                    :class="star >= 4 ? 'bg-blue-500' : star === 3 ? 'bg-yellow-400' : 'bg-red-400'"
                    :style="{ width: ratingPercent(star) + '%' }"
                  />
                </div>
                <span class="text-xs text-gray-400 w-7 text-right">{{ ratingPercent(star) }}%</span>
              </div>
            </div>
          </div>

          <!-- Top Qualities -->
          <div class="mb-6">
            <h2 class="text-sm font-semibold text-gray-700 mb-3">คุณสมบัติเด่น</h2>
            <div class="grid grid-cols-4 gap-2">
              <div v-for="q in qualities" :key="q.label"
                class="flex flex-col items-center gap-1.5 py-3 px-2 bg-gray-50 border border-gray-200 rounded-xl text-center">
                <div class="w-9 h-9 rounded-full bg-blue-50 border border-blue-100 flex items-center justify-center">
                  <span class="text-lg">{{ q.icon }}</span>
                </div>
                <span class="text-[10px] font-semibold text-gray-500 uppercase tracking-wide leading-tight">{{ q.label }}</span>
              </div>
            </div>
          </div>

          <!-- Filter tabs -->
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-sm font-semibold text-gray-700">รีวิวทั้งหมด</h2>
            <div class="flex gap-1 flex-wrap justify-end">
              <button
                v-for="f in filters"
                :key="f.value"
                @click="activeFilter = f.value"
                class="flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-medium border transition"
                :class="activeFilter === f.value
                  ? 'bg-blue-600 text-white border-blue-600'
                  : 'bg-white text-gray-500 border-gray-200 hover:border-blue-300'"
              >
                <template v-if="f.value !== 'all'">
                  <svg width="9" height="9" viewBox="0 0 24 24"
                    :fill="activeFilter === f.value ? 'white' : '#fdc700'"
                    :stroke="activeFilter === f.value ? 'white' : '#fdc700'"
                    stroke-width="2">
                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                  </svg>
                </template>
                {{ f.label }}
              </button>
            </div>
          </div>

          <!-- Review list -->
          <div class="space-y-3">
            <div v-if="filteredReviews.length === 0" class="py-10 text-center text-gray-400 text-sm border-2 border-dashed border-gray-200 rounded-2xl">
              ไม่มีรีวิวในหมวดนี้
            </div>

            <div
              v-for="(review, i) in filteredReviews"
              :key="review.id ?? i"
              class="p-4 border border-gray-200 rounded-2xl hover:shadow-sm transition"
            >
              <!-- Reviewer row -->
              <div class="flex items-start justify-between mb-2">
                <div class="flex items-center gap-2.5">
                  <img
                    :src="review.reviewer?.profileImage || `https://ui-avatars.com/api/?name=${review.reviewer?.firstName}+${review.reviewer?.lastName}&background=e0e7ff&color=3730a3&size=40`"
                    class="w-9 h-9 rounded-full object-cover border border-gray-200"
                  />
                  <div>
                    <p class="text-sm font-semibold text-gray-800">
                      {{ review.reviewer?.firstName }} {{ review.reviewer?.lastName }}
                    </p>
                    <p class="text-xs text-gray-400">{{ formatDate(review.createdAt) }}</p>
                  </div>
                </div>
                <!-- Stars -->
                <div class="flex gap-0.5 mt-0.5">
                  <svg v-for="n in 5" :key="n" width="13" height="13" viewBox="0 0 24 24"
                    :fill="n <= review.rating ? '#fdc700' : 'none'"
                    :stroke="n <= review.rating ? '#fdc700' : '#d1d5db'"
                    stroke-width="2">
                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                  </svg>
                </div>
              </div>

              <!-- Comment -->
              <p v-if="review.comment" class="text-sm text-gray-600 leading-relaxed">{{ review.comment }}</p>

              <!-- Tags -->
              <div v-if="review.tags?.length" class="flex flex-wrap gap-1.5 mt-2.5">
                <span v-for="tag in review.tags" :key="tag"
                  class="text-xs px-2 py-0.5 rounded-full bg-blue-50 text-blue-600 border border-blue-100">
                  {{ tag }}
                </span>
              </div>

              <!-- Images + Videos -->
              <div v-if="review.images?.length || review.videos?.length" class="flex gap-1 mt-2.5">
                <img
                  v-for="img in review.images" :key="img" :src="img"
                  @click="openPreview('image', img)"
                  class="flex-1 h-24 object-cover cursor-pointer hover:opacity-90 transition first:rounded-l-xl last:rounded-r-xl"
                />
                <div
                  v-for="vid in review.videos" :key="vid"
                  @click="openPreview('video', vid)"
                  class="relative flex-1 h-24 cursor-pointer overflow-hidden bg-gray-900 hover:opacity-90 transition first:rounded-l-xl last:rounded-r-xl"
                >
                  <video :src="vid" class="w-full h-full object-cover opacity-60" preload="metadata" muted playsinline />
                  <div class="absolute inset-0 flex items-center justify-center">
                    <div class="w-7 h-7 rounded-full bg-white/90 flex items-center justify-center shadow">
                      <svg width="10" height="10" viewBox="0 0 24 24" fill="#1f2937"><path d="M8 5v14l11-7z"/></svg>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Audios -->
              <div v-if="review.audios?.length" class="mt-2.5 space-y-1.5">
                <div
                  v-for="(aud, ai) in review.audios" :key="aud"
                  @click="openPreview('audio', aud)"
                  class="flex items-center gap-2.5 px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl cursor-pointer hover:bg-blue-50 hover:border-blue-200 transition"
                >
                  <div class="w-7 h-7 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0">
                    <svg width="12" height="12" fill="none" stroke="#3b82f6" stroke-width="2" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M9 19V6l12-3v13M9 19a2 2 0 11-4 0 2 2 0 014 0zm12-3a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                  </div>
                  <span class="text-xs text-gray-500">ไฟล์เสียง {{ ai + 1 }}</span>
                  <span class="ml-auto text-xs text-blue-400">แตะเพื่อฟัง</span>
                </div>
              </div>
            </div>
          </div>

        </template>
      </main>
    </div>
  </div>

  <!-- Preview Modal -->
  <Teleport to="body">
    <Transition name="fade">
      <div v-if="preview.show"
        class="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4"
        @click.self="closePreview">
        <div class="relative w-full max-w-3xl">
          <button @click="closePreview"
            class="absolute -top-11 right-0 w-9 h-9 rounded-full bg-white/20 hover:bg-white/30 text-white flex items-center justify-center transition">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
            </svg>
          </button>
          <div v-if="preview.type === 'image'" class="overflow-hidden rounded-xl shadow-xl">
            <img :src="preview.url" class="w-full max-h-[80vh] object-contain" />
          </div>
          <video v-else-if="preview.type === 'video'" :src="preview.url"
            controls autoplay playsinline
            class="w-full max-h-[80vh] shadow-xl bg-black" />
          <div v-else-if="preview.type === 'audio'" class="bg-white rounded-2xl p-6 shadow-2xl">
            <div class="flex items-center gap-3 mb-4">
              <div class="w-10 h-10 rounded-full bg-blue-100 flex items-center justify-center">
                <svg width="18" height="18" fill="none" stroke="#3b82f6" stroke-width="2" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M9 19V6l12-3v13M9 19a2 2 0 11-4 0 2 2 0 014 0zm12-3a2 2 0 11-4 0 2 2 0 014 0z"/>
                </svg>
              </div>
              <p class="text-sm font-semibold text-gray-700">ไฟล์เสียง</p>
            </div>
            <audio :src="preview.url" controls autoplay class="w-full" />
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

definePageMeta({ middleware: 'auth' })

const route = useRoute()
const driverId = route.params.driverId

const pending = ref(true)
const driver = ref({})
const allReviews = ref([])

const error = ref(null)  

onMounted(() => {
  const stored = JSON.parse(localStorage.getItem('reviews') || '[]')
  const user   = JSON.parse(localStorage.getItem('user') || '{}')

  const nameFromQuery = decodeURIComponent(String(route.query.driverName || ''))

  let driverReviews = stored.filter(r => String(r.driverId) === String(driverId))
  if (!driverReviews.length && nameFromQuery) {
    driverReviews = stored.filter(r => r.driverName === nameFromQuery)
  }

  const first = driverReviews[0]
  driver.value = {
    firstName:    first?.driverName?.split(' ')[0] ?? 'ไม่ระบุ',
    lastName:     first?.driverName?.split(' ').slice(1).join(' ') ?? '',
    profileImage: first?.driverImage ?? '',
    totalTrips:   driverReviews.length,
    createdAt:    null,
  }

  // ดึงชื่อ+รูปจาก user localStorage เป็น default reviewer
  const defaultReviewer = {
    firstName:    user.firstName    ?? user.name?.split(' ')[0] ?? 'คุณ',
    lastName:     user.lastName     ?? user.name?.split(' ').slice(1).join(' ') ?? '',
    profileImage: user.profilePicture ?? user.avatar ?? user.photo ?? user.image ?? '',
  }

  allReviews.value = driverReviews.map(r => ({
    ...r,
    reviewer: (r.reviewer?.firstName || r.reviewer?.profileImage)
      ? r.reviewer
      : defaultReviewer
  }))

  pending.value = false
})

// Stat
const avgRating = computed(() => {
  if (!allReviews.value.length) return '0.0'
  return (allReviews.value.reduce((s, r) => s + r.rating, 0) / allReviews.value.length).toFixed(1)
})

const ratingPercent = (star) => {
  if (!allReviews.value.length) return 0
  const count = allReviews.value.filter(r => r.rating === star).length
  return Math.round((count / allReviews.value.length) * 100)
}

const qualities = computed(() => {
  const tagMap = {
    'ขับปลอดภัย': ['ปลอดภัย', 'ขับประมาท', 'ไม่ปลอดภัย', 'ขับเร็ว', 'ขับดี'],
    'รถสะอาด':    ['สะอาด', 'สกปรก'],
    'เป็นมิตร':   ['เป็นมิตร', 'พูดจา', 'ติดต่อ', 'สื่อสาร', 'นัดพบ', 'แนะนำ'],
    'ตรงเวลา':    ['ตรงเวลา', 'มาสาย', 'ไม่ตรงเวลา'],
    'รู้เส้นทาง': ['เส้นทาง', 'หลงทาง'],
  }
  const icons = {
    'ขับปลอดภัย': '🛡️',
    'รถสะอาด':    '🚗',
    'เป็นมิตร':   '😊',
    'ตรงเวลา':    '⏰',
    'รู้เส้นทาง': '🗺️',
  }
  const allTags = allReviews.value.flatMap(r => r.tags ?? [])
  return Object.entries(tagMap)
    .map(([label, keywords]) => ({
      label,
      icon: icons[label],
      count: allTags.filter(t => keywords.some(k => t.includes(k))).length,
    }))
    .filter(q => q.count > 0)
    .sort((a, b) => b.count - a.count)
})
const filters = [
  { label: 'ทั้งหมด', value: 'all' },
  { label: '5', value: 5 },
  { label: '4', value: 4 },
  { label: '3', value: 3 },
  { label: '2', value: 2 },
  { label: '1', value: 1 },
]

const activeFilter = ref('all')

const filteredReviews = computed(() =>
  activeFilter.value === 'all'
    ? allReviews.value
    : allReviews.value.filter(r => r.rating === activeFilter.value)
)

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('th-TH', { year: 'numeric', month: 'short', day: 'numeric' })
}

const ratingBadgeStyle = computed(() => {
  const r = Number(avgRating.value)
  if (r >= 4.5) return {
    label: 'คะแนนดีเยี่ยม',
    class: 'bg-blue-50 text-blue-700 border-blue-200',
    starColor: '#fdc700'
  }
  if (r >= 4.0) return {
    label: 'คะแนนดี',
    class: 'bg-green-50 text-green-700 border-green-200',
    starColor: '#fdc700'
  }
  if (r >= 3.0) return {
    label: 'คะแนนปานกลาง',
    class: 'bg-yellow-50 text-yellow-700 border-yellow-200',
    starColor: '#fdc700'
  }
  return {
    label: 'คะแนนน้อย',
    class: 'bg-red-50 text-red-600 border-red-200',
    starColor: '#ef4444'
  }
})

const preview = ref({ show: false, type: '', url: '' })
const openPreview = (type, url) => { preview.value = { show: true, type, url } }
const closePreview = () => { preview.value = { show: false, type: '', url: '' } }
</script>

<style>
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>