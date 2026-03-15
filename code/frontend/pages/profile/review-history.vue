<template>
  <div class="flex items-start justify-center min-h-screen py-8 bg-gray-100">
    <div class="flex w-full max-w-6xl mx-4 overflow-hidden bg-white border border-gray-300 rounded-lg shadow-lg">
      <ProfileSidebar />

      <main class="flex-1 p-8">
        <div class="text-center mb-8">
          <div class="inline-flex items-center justify-center w-16 h-16 mb-4 bg-blue-600 rounded-full">
            <svg width="28" height="28" fill="none" viewBox="0 0 24 24">
              <path d="M12 2l2.4 7.4H22l-6.2 4.5 2.4 7.4L12 17l-6.2 4.3 2.4-7.4L2 9.4h7.6z" fill="white"/>
            </svg>
          </div>
          <h1 class="text-3xl font-bold text-gray-800 tracking-tight mb-1">ประวัติการรีวิว</h1>
          <p class="max-w-md mx-auto text-gray-500">ดูคะแนนและความคิดเห็นที่คุณเคยให้กับผู้ขับขี่ในแต่ละการเดินทาง</p>
        </div>

        <div class="grid grid-cols-3 gap-3 mb-6">
          <div class="border border-gray-200 rounded-2xl py-4 px-3 text-center">
            <span class="block text-2xl font-bold text-blue-600">{{ reviews.length }}</span>
            <span class="block text-xs text-gray-400 mt-0.5">รีวิวทั้งหมด</span>
          </div>
          <div class="border border-gray-200 rounded-2xl py-4 px-3 text-center">
            <span class="block text-2xl font-bold text-blue-600">{{ avgRating }}</span>
            <span class="block text-xs text-gray-400 mt-0.5">คะแนนเฉลี่ย</span>
          </div>
          <div class="border border-gray-200 rounded-2xl py-4 px-3 text-center">
            <span class="block text-2xl font-bold text-blue-600">{{ fiveStarCount }}</span>
            <span class="flex items-center justify-center gap-0.5 text-xs text-gray-400 mt-0.5">
              <svg width="11" height="11" viewBox="0 0 24 24" fill="#fdc700" stroke="#fdc700" stroke-width="2">
                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
              </svg>
              5 ดาว
            </span>
          </div>
        </div>

        <!-- Empty -->
        <div v-if="reviews.length === 0" class="border-2 border-dashed border-gray-200 rounded-2xl py-16 text-center">
          <svg class="mx-auto mb-3 opacity-30" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#9ca3af" stroke-width="1.5">
            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
          </svg>
          <p class="text-gray-400 text-sm">ยังไม่มีรีวิว</p>
        </div>

        <!-- Review list -->
        <div v-else class="flex flex-col gap-3">
          <div
            v-for="(review, i) in reviews"
            :key="review.createdAt"
            class="relative border border-gray-200 rounded-2xl p-5 hover:shadow-md transition-shadow duration-200 overflow-hidden"
          >
            <div class="flex items-start justify-between gap-3 mb-3">
              <div class="flex items-center gap-3">
                <!--รูปโปรไฟล์ -->
                <div class="w-10 h-10 rounded-full overflow-hidden flex-shrink-0 border-2 border-blue-100">
                  <img v-if="review.driverImage" :src="review.driverImage" class="w-full h-full object-cover" />
                  <div v-else class="w-full h-full bg-gradient-to-br from-blue-100 to-blue-200 flex items-center justify-center text-blue-600 font-semibold text-sm">
                    {{ getInitial(review.driverName) }}
                  </div>
                </div>
                <div>
                  <p class="text-sm font-semibold text-gray-800">{{ review.driverName }}</p>
                  <p class="text-xs text-gray-400 flex items-center gap-1 mt-0.5">
                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                      <path d="M3 12h18M3 6h18M3 18h18"/>
                    </svg>
                    {{ review.tripRoute }}
                  </p>
                  <!-- Stars -->
                  <div class="flex gap-0.5 mt-1">
                    <svg v-for="n in 5" :key="n" width="12" height="12" viewBox="0 0 24 24"
                      :fill="n <= review.rating ? '#fdc700' : 'none'"
                      :stroke="n <= review.rating ? '#fdc700' : '#d1d5db'"
                      stroke-width="2">
                      <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                    </svg>
                  </div>
                </div>
              </div>

              <!-- Rating badge -->
              <span class="flex-shrink-0 flex items-center gap-1 text-xs font-semibold px-2.5 py-1 rounded-full border" :class="ratingBadge(review.rating)">
                <svg width="11" height="11" viewBox="0 0 24 24" fill="#fdc700" stroke="#fdc700" stroke-width="2">
                  <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
                </svg>
                {{ review.rating }}/5
              </span>
            </div>

            <p v-if="review.comment" class="text-sm text-gray-500 italic bg-gray-50 rounded-xl px-3 py-2 mb-3 leading-relaxed">
              "{{ review.comment }}"
            </p>

            <div v-if="review.tags?.length" class="flex flex-wrap gap-1.5 mb-3">
              <span v-for="tag in review.tags" :key="tag"
                class="text-xs font-medium px-2.5 py-0.5 rounded-full bg-blue-50 text-blue-600 border border-blue-200">
                {{ tag }}
              </span>
            </div>

            <div class="flex gap-1 mb-3">
              <!-- Images -->
              <img
                v-for="img in review.images"
                :key="img"
                :src="img"
                @click="openPreview('image', img)"
                class="flex-1 h-20 object-cover cursor-pointer hover:opacity-90 transition first:rounded-l-xl last:rounded-r-xl"
              />

              <!-- Videos -->
              <div
                v-for="vid in review.videos"
                :key="vid"
                @click="openPreview('video', vid)"
                class="relative flex-1 h-20 cursor-pointer overflow-hidden bg-gray-900 hover:opacity-90 transition group first:rounded-l-xl last:rounded-r-xl"
              >
                <video :src="vid" class="w-full h-full object-cover opacity-70" preload="metadata" muted playsinline />
                <div class="absolute inset-0 flex items-center justify-center">
                  <div class="bg-white/80 rounded-full w-8 h-8 flex items-center justify-center">
                    <svg width="12" height="12" viewBox="0 0 24 24" fill="#1f2937">
                      <path d="M8 5v14l11-7z"/>
                    </svg>
                  </div>
                </div>
              </div>
            </div>

            <!-- Audios -->
            <div v-if="review.audios?.length" class="mb-3 space-y-1.5">
              <div v-for="(aud, ai) in review.audios" :key="aud"
                @click="openPreview('audio', aud)"
                class="flex items-center gap-2.5 px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl cursor-pointer hover:bg-blue-50 hover:border-blue-200 transition">
                <div class="w-7 h-7 rounded-full bg-blue-100 flex items-center justify-center flex-shrink-0">
                  <svg width="12" height="12" fill="none" stroke="#3b82f6" stroke-width="2" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M9 19V6l12-3v13M9 19a2 2 0 11-4 0 2 2 0 014 0zm12-3a2 2 0 11-4 0 2 2 0 014 0z"/>
                  </svg>
                </div>
                <span class="text-xs text-gray-500">ไฟล์เสียง {{ ai + 1 }}</span>
                <span class="ml-auto text-xs text-blue-400">แตะเพื่อฟัง</span>
              </div>
            </div>

            <!-- Footer -->
            <div class="flex items-center justify-between pt-2.5 border-t border-gray-100 mt-1">
              <span class="text-xs text-gray-400 flex items-center gap-1">
                <svg width="11" height="11" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3M12 22a10 10 0 100-20 10 10 0 000 20z"/>
                </svg>
                {{ formatDate(review.createdAt) }}
              </span>
              <span class="text-[11px] text-gray-300 font-mono">#TRIP-{{ review.bookingId }}</span>
            </div>
          </div>
        </div>

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

          <!-- Close button -->
          <button @click="closePreview"
            class="absolute -top-11 right-0 w-9 h-9 rounded-full bg-white/20 hover:bg-white/30 text-white flex items-center justify-center transition">
            <svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
            </svg>
          </button>

          <!-- Image -->
          <img v-if="preview.type === 'image'" :src="preview.url"
            class="w-full max-h-[80vh] object-contain" />

          <!-- Video -->
          <video v-else-if="preview.type === 'video'" :src="preview.url"
            controls autoplay
            class="w-full max-h-[80vh]" />

          <!-- Audio -->
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
import ProfileSidebar from '~/components/ProfileSidebar.vue'

const reviews = ref([])
const preview = ref({ show: false, type: '', url: '' })

const avgRating = computed(() => {
  if (!reviews.value.length) return '—'
  return (reviews.value.reduce((s, r) => s + r.rating, 0) / reviews.value.length).toFixed(1)
})

const fiveStarCount = computed(() =>
  reviews.value.filter(r => r.rating === 5).length
)

const getInitial = (name) => name?.charAt(0) ?? '?'

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('th-TH', {
    year: 'numeric', month: 'long', day: 'numeric',
  })
}

const ratingAccent = (rating) => {
  if (rating >= 5) return 'bg-gradient-to-b from-emerald-400 to-emerald-200'
  if (rating >= 4) return 'bg-gradient-to-b from-blue-400 to-blue-200'
  if (rating >= 3) return 'bg-gradient-to-b from-yellow-400 to-yellow-200'
  return 'bg-gradient-to-b from-red-400 to-red-200'
}

const ratingBadge = (rating) => {
  if (rating >= 5) return 'bg-emerald-50 text-emerald-700 border-emerald-200'
  if (rating >= 4) return 'bg-blue-50 text-blue-700 border-blue-200'
  if (rating >= 3) return 'bg-yellow-50 text-yellow-700 border-yellow-200'
  return 'bg-red-50 text-red-700 border-red-200'
}

const openPreview = (type, url) => {
  preview.value = { show: true, type, url }
}

const closePreview = () => {
  preview.value = { show: false, type: '', url: '' }
}

onMounted(() => {
  const data = localStorage.getItem('reviews')
  const user = JSON.parse(localStorage.getItem('user') || '{}')
  if (data) {
    const allReviews = JSON.parse(data)
    reviews.value = allReviews.filter(r => String(r.userId) === String(user.id))
  }
})
</script>

<style>
.fade-enter-active, .fade-leave-active { transition: opacity 0.2s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>