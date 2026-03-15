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
                            <button v-for="star in 5" :key="star"
                                @click="rating = star"
                                class="transition-transform hover:scale-110 focus:outline-none">
                                <svg class="w-12 h-12 transition-colors duration-150"
                                    :class="star <= rating ? 'text-yellow-400' : 'text-gray-200'"
                                    fill="currentColor" viewBox="0 0 24 24">
                                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
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
                            <button v-for="tag in availableTags" :key="tag"
                                @click="toggleTag(tag)"
                                :class="[
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
                    <div class="space-y-4">
                        <label class="block text-sm font-medium text-gray-700">รูปภาพ / วิดีโอ (ไม่บังคับ)</label>

                        <!-- Images -->
                        <div>
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-xs text-gray-500">รูปภาพ ({{ images.length }}/3)</span>
                                <label v-if="images.length < 3"
                                    class="cursor-pointer px-3 py-1.5 text-xs text-blue-600 border border-blue-300 rounded-full hover:bg-blue-50 transition">
                                    + เพิ่มรูป
                                    <input type="file" accept="image/*" multiple class="hidden" @change="handleImageUpload" />
                                </label>
                            </div>
                            <div v-if="images.length" class="grid grid-cols-3 gap-2">
                                <div v-for="(img, idx) in images" :key="idx" class="relative group aspect-square">
                                    <img :src="img.url" class="w-full h-full object-cover rounded-lg" />
                                    <button @click="removeImage(idx)"
                                        class="absolute top-1 right-1 w-5 h-5 bg-red-500 text-white rounded-full text-xs opacity-0 group-hover:opacity-100 transition flex items-center justify-center">
                                        ✕
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Videos -->
                        <div>
                            <div class="flex items-center justify-between mb-2">
                                <span class="text-xs text-gray-500">วิดีโอ ({{ videos.length }}/3)</span>
                                <label v-if="videos.length < 3"
                                    class="cursor-pointer px-3 py-1.5 text-xs text-blue-600 border border-blue-300 rounded-full hover:bg-blue-50 transition">
                                    + เพิ่มวิดีโอ
                                    <input type="file" accept="video/*" multiple class="hidden" @change="handleVideoUpload" />
                                </label>
                            </div>
                            <div v-if="videos.length" class="space-y-2">
                                <div v-for="(vid, idx) in videos" :key="idx"
                                    class="flex items-center justify-between p-3 bg-gray-50 rounded-lg border border-gray-200">
                                    <div class="flex items-center gap-2 min-w-0">
                                        <span class="text-xl">🎬</span>
                                        <span class="text-sm text-gray-700 truncate">{{ vid.name }}</span>
                                    </div>
                                    <button @click="removeVideo(idx)"
                                        class="ml-2 w-6 h-6 bg-red-100 text-red-500 rounded-full text-xs flex items-center justify-center hover:bg-red-200 transition flex-shrink-0">
                                        ✕
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Audio -->
                    <div>
                        <div class="flex items-center justify-between mb-2">
                            <span class="text-xs text-gray-500">ไฟล์เสียง ({{ audios.length }}/3)</span>
                            <label v-if="audios.length < 3"
                                class="cursor-pointer px-3 py-1.5 text-xs text-blue-600 border border-blue-300 rounded-full hover:bg-blue-50 transition">
                                + เพิ่มเสียง
                                <input type="file" accept="audio/*" multiple class="hidden" @change="handleAudioUpload" />
                            </label>
                        </div>
                        <div v-if="audios.length" class="space-y-2">
                            <div v-for="(aud, idx) in audios" :key="idx"
                                class="p-3 bg-gray-50 rounded-lg border border-gray-200 space-y-2">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center gap-2 min-w-0">
                                        <span class="text-xl">🎵</span>
                                        <span class="text-sm text-gray-700 truncate">{{ aud.name }}</span>
                                    </div>
                                    <button @click="removeAudio(idx)"
                                        class="ml-2 w-6 h-6 bg-red-100 text-red-500 rounded-full text-xs flex items-center justify-center hover:bg-red-200 transition flex-shrink-0">
                                        ✕
                                    </button>
                                </div>
                                <audio :src="aud.url" controls class="w-full h-8" />
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
                        <button @click="submitReview" :disabled="rating === 0 || isSubmitting"
                            class="flex-1 px-4 py-3 text-sm text-white bg-blue-600 rounded-xl hover:bg-blue-700 disabled:opacity-50 disabled:cursor-not-allowed transition font-medium">
                            {{ isSubmitting ? 'กำลังส่ง...' : 'ส่งรีวิว' }}
                        </button>
                    </div>

                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'
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

// ดึงข้อมูลจาก query params (ส่งมาจากหน้า myTrip)
const driverName = computed(() => route.query.driverName || 'ผู้ขับ')
const driverImage = computed(() => route.query.driverImage || `https://ui-avatars.com/api/?name=Driver&background=random&size=64`)
const tripRoute = computed(() => route.query.tripRoute || '')

// แทนที่ availableTags เดิม
const tagsByRating = {
    1: ['🤬 ขับประมาท', '💢 พูดจาไม่ดี', '🚫 ไม่ตรงเวลาเลย', '😱 รู้สึกไม่ปลอดภัย', '🚗 รถสกปรกมาก', '❌ ไม่แนะนำเลย', '📵 ติดต่อไม่ได้'],
    2: ['😤 ขับเร็วเกินไป', '⏰ มาสายมาก', '🙁 ไม่ค่อยเป็นมิตร', '🗺️ หลงทาง', '🚙 รถไม่สะอาด', '💬 สื่อสารไม่ดี', '📍 นัดพบลำบาก'],
    3: ['🙂 พอใช้ได้', '⏱️ มาตรงเวลาพอสมควร', '🚗 รถพอสะอาด', '💬 สื่อสารพอใช้', '🛣️ รู้เส้นทางบ้าง', '😐 ปกติทั่วไป', '🔇 ไม่ค่อยพูด'],
    4: ['😊 เป็นมิตร', '⏰ ตรงเวลา', '🧹 รถสะอาด', '💬 สื่อสารดี', '🛣️ รู้เส้นทางดี', '🚗 ขับดี', '👍 แนะนำได้'],
    5: ['🌟 ยอดเยี่ยมมาก', '🏆 ดีที่สุด', '😁 เป็นมิตรมาก', '⚡ ตรงเวลาเป๊ะ', '✨ รถสะอาดมาก', '🗣️ สื่อสารเยี่ยม', '🎯 รู้เส้นทางแม่น', '💯 แนะนำเลย', '🔒 ปลอดภัยมาก'],
}

const availableTags = computed(() => tagsByRating[rating.value] || [])

// เคลียร์ tags เมื่อเปลี่ยน rating
watch(rating, () => { selectedTags.value = [] })

// เพิ่ม audio state
const audios = ref([])

function handleAudioUpload(e) {
    const files = Array.from(e.target.files)
    if (audios.value.length + files.length > 3) {
        toast.error('เกินจำนวน', 'อัปโหลดไฟล์เสียงได้สูงสุด 3 ไฟล์')
        return
    }
    files.forEach(file => {
        audios.value.push({
            file,
            url: URL.createObjectURL(file),
            name: file.name
        })
    })
    e.target.value = ''
}

function removeAudio(idx) { audios.value.splice(idx, 1) }

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

const user = JSON.parse(localStorage.getItem('user'))

async function submitReview() {
    if (rating.value === 0) {
        error.value = 'กรุณาให้คะแนนก่อนส่งรีวิว'
        return
    }

    error.value = ''
    isSubmitting.value = true

    try {

        const reviewData = {
            userId: user?.id,
            bookingId,
            driverName: driverName.value,
            driverId: route.query.driverId,
            driverImage: driverImage.value,
            tripRoute: tripRoute.value,
            rating: rating.value,
            comment: comment.value,
            tags: selectedTags.value,
            images: images.value.map(i => i.url),
            videos: videos.value.map(v => v.url),
            audios: audios.value.map(a => a.url),
            createdAt: new Date(),
            reviewer: {                             
            firstName:    user?.firstName    ?? '',
            lastName:     user?.lastName     ?? '',
            profileImage: user?.profilePicture ?? '',
            }
        }

        // ดึงของเก่ามาก่อน
        const existing = JSON.parse(localStorage.getItem('reviews') || '[]')

        // เพิ่มรีวิวใหม่
        existing.unshift(reviewData)

        // เก็บกลับ
        localStorage.setItem('reviews', JSON.stringify(existing))

        toast.success('ขอบคุณสำหรับรีวิว!', 'รีวิวของคุณถูกบันทึกแล้ว')

        router.push('/profile/review-history')

    } catch (err) {
        error.value = 'เกิดข้อผิดพลาด'
    } finally {
        isSubmitting.value = false
    }
}


const images = ref([])
const videos = ref([])

function handleImageUpload(e) {
    const files = Array.from(e.target.files)
    if (images.value.length + files.length > 3) {
        toast.error('เกินจำนวน', 'อัปโหลดรูปภาพได้สูงสุด 3 รูป')
        return
    }
    files.forEach(file => {
        images.value.push({
            file,
            url: URL.createObjectURL(file),
            name: file.name
        })
    })
    e.target.value = ''
}

function handleVideoUpload(e) {
    const files = Array.from(e.target.files)
    if (videos.value.length + files.length > 3) {
        toast.error('เกินจำนวน', 'อัปโหลดวิดีโอได้สูงสุด 3 คลิป')
        return
    }
    files.forEach(file => {
        videos.value.push({
            file,
            url: URL.createObjectURL(file),
            name: file.name
        })
    })
    e.target.value = ''
}

function removeImage(idx) { images.value.splice(idx, 1) }
function removeVideo(idx) { videos.value.splice(idx, 1) }
</script>