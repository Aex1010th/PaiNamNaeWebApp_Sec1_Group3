<template>
    <div class="min-h-screen bg-gray-50 flex items-center justify-center px-4 py-12">
        <div class="w-full max-w-lg">
            <!-- Card -->
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden">

                <!-- Header -->
                <div class="bg-gradient-to-r from-blue-600 to-blue-500 px-8 py-6 text-white">
                    <h1 class="text-2xl font-bold">รีวิวการเดินทาง</h1>
                    <p class="mt-1 text-blue-100 text-sm">แบ่งปันประสบการณ์เพื่อช่วยผู้ใช้คนอื่น</p>
                </div>

                <div class="px-8 py-6 space-y-6">

                    <!-- Driver Info -->
                    <div class="flex items-center space-x-4 p-4 bg-gray-50 rounded-xl">
                        <img :src="driverImage" class="w-14 h-14 rounded-full object-cover border-2 border-blue-100" />
                        <div>
                            <p class="text-xs text-gray-500">คุณกำลังรีวิว</p>
                            <p class="font-semibold text-gray-900 text-lg">{{ driverName }}</p>
                            <p class="text-sm text-gray-500">{{ tripRoute }}</p>
                        </div>
                    </div>

                    <!-- Star Rating -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-3">คะแนนความพึงพอใจ</label>
                        <div class="flex justify-center gap-3">
                            <button v-for="star in 5" :key="star" @click="rating = star"
                                class="transition-transform hover:scale-110 focus:outline-none">
                                <svg class="w-12 h-12 transition-colors duration-150"
                                    :class="star <= rating ? 'text-yellow-400' : 'text-gray-200'" fill="currentColor"
                                    viewBox="0 0 24 24">
                                    <path
                                        d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                                </svg>
                            </button>
                        </div>
                        <p class="text-center mt-2 text-sm font-medium" :class="ratingColor">{{ ratingLabel }}</p>
                    </div>

                    <!-- Comment -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">ความคิดเห็น (ไม่บังคับ)</label>
                        <textarea v-model="comment" rows="4" placeholder="เล่าประสบการณ์การเดินทางของคุณ..."
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm resize-none focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition" />
                        <p class="text-right text-xs text-gray-400 mt-1">{{ comment.length }}/500</p>
                    </div>

                    <!-- Tags -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">แท็กที่ตรงกับประสบการณ์</label>
                        <div v-if="rating === 0" class="text-sm text-gray-400 italic">
                            เลือกคะแนนก่อนเพื่อดูแท็กที่เกี่ยวข้อง
                        </div>
                        <div v-else class="flex flex-wrap gap-2">
                            <button v-for="tag in availableTags" :key="tag" @click="toggleTag(tag)" :class="[
                                'px-3 py-1.5 rounded-full text-sm border transition-all duration-150',
                                selectedTags.includes(tag)
                                    ? 'bg-blue-600 text-white border-blue-600'
                                    : 'bg-white text-gray-600 border-gray-300 hover:border-blue-400'
                            ]">
                                {{ tag }}
                            </button>
                        </div>
                    </div>

                    <!-- Media Upload -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-3">รูปภาพ / วิดีโอ / เสียง
                            (ไม่บังคับ)</label>

                        <div class="p-4 border border-gray-200 rounded-2xl bg-white">

                            <!-- Upload Box -->
                            <label
                                class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:border-blue-400 hover:bg-blue-50 transition">
                                <div class="text-gray-400 mb-2">
                                    <svg xmlns="http://www.w3.org/2000/svg" class="w-8 h-8" fill="none"
                                        viewBox="0 0 24 24" stroke="currentColor">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M12 4v16m8-8H4" />
                                    </svg>
                                </div>
                                <p class="text-sm text-gray-500">คลิกเพื่อแนบไฟล์</p>
                                <p class="text-xs text-gray-400">รูป / เสียง / วิดีโอ</p>
                                <input type="file" accept="image/*,video/mp4,audio/*" multiple @change="handleUpload"
                                    class="hidden" />
                            </label>

                            <p class="px-4 py-2 text-gray-400 text-sm">
                                แนบได้ไม่เกิน 3 ไฟล์ (รวม {{ getTotalFiles() }}/3)
                            </p>

                            <!-- Preview รูปและวิดีโอ -->
                            <div v-if="images.length || videos.length" class="mt-4">
                                <div class="grid grid-cols-3 gap-3">
                                    <div v-for="(file, index) in images" :key="'img' + index" class="relative">
                                        <img :src="file.url" @click="openPreview('image', file.url)"
                                            class="w-full aspect-square object-cover rounded-xl cursor-pointer" />
                                        <button @click.stop="removeFile('image', index)"
                                            class="absolute top-1 right-1 bg-black/60 text-white w-5 h-5 rounded-full text-xs flex items-center justify-center">✕</button>
                                    </div>

                                    <div v-for="(file, index) in videos" :key="'vid' + index" class="relative">
                                        <video :src="file.url" controls
                                            class="w-full aspect-square object-cover rounded-xl cursor-pointer"></video>
                                        <button @click.stop="removeFile('video', index)"
                                            class="absolute top-1 right-1 bg-black/60 text-white w-5 h-5 rounded-full text-xs flex items-center justify-center">✕</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Preview เสียง -->
                            <div v-if="audios.length" class="mt-4 space-y-2">
                                <div v-for="(file, index) in audios" :key="index"
                                    class="flex items-center justify-between p-2 bg-gray-100 rounded hover:bg-gray-200">
                                    <span class="flex items-center gap-2 text-sm text-gray-700 truncate">
                                        🎵 {{ file.name }}
                                    </span>
                                    <button @click.stop="removeFile('audio', index)"
                                        class="text-gray-500 hover:text-red-500 text-sm ml-2 flex-shrink-0">ลบ</button>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Error -->
                    <p v-if="error" class="text-sm text-red-600 text-center">{{ error }}</p>

                    <!-- Buttons -->
                    <div class="flex gap-3 pt-2">
                        <NuxtLink :to="{ path: '/myTrip', query: { tab: 'completed' } }"
                            class="flex-1 px-4 py-3 text-sm text-gray-600 border border-gray-300 rounded-xl text-center hover:bg-gray-50 transition">
                            ยกเลิก
                        </NuxtLink>
                        <button @click="submitReview" :disabled="rating === 0 || isSubmitting || hasExistingReview"
                            class="flex-1 px-4 py-3 text-sm text-white bg-blue-600 rounded-xl hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition font-medium">
                            {{ submitButtonText }}
                        </button>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- Preview Modal -->
    <div v-if="preview.show" class="fixed inset-0 bg-white/40 backdrop-blur-sm flex items-center justify-center z-50"
        @click.self="closePreview">
        <div class="relative max-w-5xl w-full px-4">
            <button @click="closePreview"
                class="absolute -top-12 right-0 bg-black/70 text-white w-10 h-10 rounded-full flex items-center justify-center hover:bg-black transition">✕</button>

            <img v-if="preview.type === 'image'" :src="preview.url"
                class="w-full max-h-[80vh] object-contain rounded-lg" />

            <video v-if="preview.type === 'video'" :src="preview.url" controls autoplay
                class="w-full max-h-[80vh] rounded-lg"></video>

            <div v-if="preview.type === 'audio'" class="bg-white p-6 rounded-lg">
                <audio :src="preview.url" controls autoplay class="w-full"></audio>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch } from 'vue'
import { useToast } from '~/composables/useToast'

definePageMeta({ middleware: 'auth' })

const route = useRoute()
const router = useRouter()
const { toast } = useToast()
const { $api } = useNuxtApp()

const bookingId = route.params.bookingId

// --- State ---
const rating = ref(0)
const comment = ref('')
const selectedTags = ref([])
const isSubmitting = ref(false)
const error = ref('')
const hasExistingReview = ref(false)

const images = ref([])
const videos = ref([])
const audios = ref([])

// ดึงข้อมูลจาก query params
const driverName = computed(() => route.query.driverName || 'ผู้ขับ')
const driverImage = computed(() => route.query.driverImage || `https://ui-avatars.com/api/?name=Driver&background=random&size=64`)
const tripRoute = computed(() => route.query.tripRoute || '')

// Tags แยกตาม rating
const tagsByRating = {
    1: ['🤬 ขับประมาท', '💢 พูดจาไม่ดี', '🚫 ไม่ตรงเวลาเลย', '😱 รู้สึกไม่ปลอดภัย', '🚗 รถสกปรกมาก', '❌ ไม่แนะนำเลย', '📵 ติดต่อไม่ได้'],
    2: ['😤 ขับเร็วเกินไป', '⏰ มาสายมาก', '🙁 ไม่ค่อยเป็นมิตร', '🗺️ หลงทาง', '🚙 รถไม่สะอาด', '💬 สื่อสารไม่ดี', '📍 นัดพบลำบาก'],
    3: ['🙂 พอใช้ได้', '⏱️ มาตรงเวลาพอสมควร', '🚗 รถพอสะอาด', '💬 สื่อสารพอใช้', '🛣️ รู้เส้นทางบ้าง', '😐 ปกติทั่วไป', '🔇 ไม่ค่อยพูด'],
    4: ['😊 เป็นมิตร', '⏰ ตรงเวลา', '🧹 รถสะอาด', '💬 สื่อสารดี', '🛣️ รู้เส้นทางดี', '🚗 ขับดี', '👍 แนะนำได้'],
    5: ['🌟 ยอดเยี่ยมมาก', '🏆 ดีที่สุด', '😁 เป็นมิตรมาก', '⚡ ตรงเวลาเป๊ะ', '✨ รถสะอาดมาก', '🗣️ สื่อสารเยี่ยม', '🎯 รู้เส้นทางแม่น', '💯 แนะนำเลย', '🔒 ปลอดภัยมาก'],
}

const availableTags = computed(() => tagsByRating[rating.value] || [])

watch(rating, () => { selectedTags.value = [] })

// --- Rating label & color ---
const ratingLabel = computed(() => {
    const labels = ['', 'แย่มาก', 'พอใช้', 'ดี', 'ดีมาก', 'ยอดเยี่ยม']
    return labels[rating.value] || 'เลือกคะแนน'
})

const ratingColor = computed(() => {
    const colors = ['text-gray-400', 'text-red-500', 'text-orange-500', 'text-yellow-500', 'text-green-500', 'text-green-600']
    return colors[rating.value] || 'text-gray-400'
})

function toggleTag(tag) {
    const idx = selectedTags.value.indexOf(tag)
    if (idx === -1) selectedTags.value.push(tag)
    else selectedTags.value.splice(idx, 1)
}

// --- File Upload ---
const getTotalFiles = () => images.value.length + videos.value.length + audios.value.length

const handleUpload = (e) => {
    const files = Array.from(e.target.files)

    if (getTotalFiles() + files.length > 3) {
        toast.error('เกินจำนวน', 'แนบไฟล์ทั้งหมดได้สูงสุด 3 ไฟล์')
        e.target.value = ''
        return
    }

    files.forEach(file => {
        const url = URL.createObjectURL(file)

        if (file.type.startsWith('image')) {
            images.value.push({ file, url, name: file.name })
        } else if (file.type.startsWith('video')) {
            if (file.type !== 'video/mp4') {
                toast.error('ไม่รองรับ', 'รองรับเฉพาะวิดีโอ .mp4 เท่านั้น')
                return
            }
            videos.value.push({ file, url, name: file.name })
        } else if (file.type.startsWith('audio')) {
            audios.value.push({ file, url, name: file.name })
        }
    })

    e.target.value = ''
}

const removeFile = (type, index) => {
    if (type === 'image') images.value.splice(index, 1)
    if (type === 'video') videos.value.splice(index, 1)
    if (type === 'audio') audios.value.splice(index, 1)
}

// --- Preview Modal ---
const preview = reactive({ show: false, type: '', url: '' })

const openPreview = (type, url) => {
    preview.show = true
    preview.type = type
    preview.url = url
}

const closePreview = () => {
    preview.show = false
    preview.type = ''
    preview.url = ''
}

// --- Submit ---
const submitButtonText = computed(() => {
    if (isSubmitting.value) return 'กำลังส่ง...'
    if (hasExistingReview.value) return 'ส่งรีวิวแล้ว'
    return 'ส่งรีวิว'
})

async function submitReview() {
    if (rating.value === 0) {
        error.value = 'กรุณาให้คะแนนก่อนส่งรีวิว'
        return
    }
    if (hasExistingReview.value) {
        error.value = 'คุณส่งรีวิวทริปนี้ไปแล้ว'
        return
    }

    error.value = ''
    isSubmitting.value = true

    try {
        const formData = new FormData()
        formData.append('rating', String(rating.value))

        if (comment.value?.trim()) {
            formData.append('comment', comment.value.trim())
        }
        if (selectedTags.value.length) {
            formData.append('tags', JSON.stringify(selectedTags.value))
        }

        images.value.forEach((item) => formData.append('images', item.file))
        videos.value.forEach((item) => formData.append('videos', item.file))
        audios.value.forEach((item) => formData.append('audios', item.file))

        await $api(`/reviews/booking/${bookingId}`, {
            method: 'POST',
            body: formData,
        })

        hasExistingReview.value = true
        toast.success('ขอบคุณสำหรับรีวิว!', 'รีวิวของคุณถูกบันทึกแล้ว')
        router.push('/profile/review-history')

    } catch (err) {
        error.value = err?.data?.message || err?.statusMessage || 'เกิดข้อผิดพลาด ลองใหม่อีกครั้ง'
    } finally {
        isSubmitting.value = false
    }
}

// --- Load existing review ---
onMounted(async () => {
    try {
        const review = await $api(`/reviews/booking/${bookingId}/me`)
        if (!review) return

        hasExistingReview.value = true
        rating.value = review.rating || 0
        comment.value = review.comment || ''
        selectedTags.value = Array.isArray(review.tags) ? review.tags : []
    } catch (err) {
        console.error('Failed to load existing review', err)
    }
})
</script>