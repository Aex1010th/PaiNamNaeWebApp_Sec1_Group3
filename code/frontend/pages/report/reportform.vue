<template>
  <div class="min-h-screen bg-gray-100 flex justify-center py-10">
    <div class="w-full max-w-2xl bg-white p-8 rounded shadow">

      <h1 class="text-2xl font-semibold text-center mb-8">
        รายงานปัญหา
      </h1>

      <!--Title ปัญหา-->
      <div class="mb-6">
        <label class="block mb-2 font-medium">หัวข้อปัญหา</label>
        <input
          v-model="form.title"
          type="text"
          placeholder="หัวข้อปัญหา"
          class="w-full border-b border-gray-300 focus:outline-none focus:border-blue-500 py-2"
        />
      </div>

      <!--คำอธิบายปัญหา-->
      <div class="mb-6">
        <label class="block mb-2 font-medium">รายละเอียด</label>
        <textarea
          v-model="form.detail"
          rows="5"
          placeholder="อธิบายปัญหา"
          class="w-full border-b border-gray-300 focus:outline-none focus:border-blue-500 py-2 resize-none"
        ></textarea>
      </div>

      <!--หมวดหมู่ปัญหามี 2 อย่าง-->
      <div class="mb-6">
        <label class="block mb-3 font-medium">หมวดหมู่</label>
        <div class="flex space-x-4">
          <button
            type="button"
            @click="form.category = 'system'"
            :class="categoryButton('system')"
          >
            System Report
          </button>

          <button
            type="button"
            @click="form.category = 'trip'"
            :class="categoryButton('trip')"
          >
            Trip Report
          </button>
        </div>
      </div>

      <!--Tag หลังเลือกหมวดหมู่-->
      <div class="mb-6">
        <label class="block mb-2 font-medium">ประเภท</label>
        <select
          v-model="form.tag"
          :disabled="!form.category"
          class="w-full p-4 border border-gray-200 rounded-lg bg-gray-50 "
        >
          <option disabled value="">เลือกประเภทของปัญหา</option>

          <!-- System -->
          <template v-if="form.category === 'system'">
            <option>แอปพลิเคชันขัดข้อง</option>
            <option>แผนที่ขัดข้อง</option>
            <option>ระบบทำงานล่าช้า</option>
            <option>อื่น ๆ</option>
          </template>

          <!-- Trip -->
          <template v-else>
            <option>อุบัติเหตุ</option>
            <option :disabled="!hasTargetPassenger">พฤติกรรมผู้โดยสาร</option>
            <option>อื่น ๆ</option>
          </template>

        </select>
        <p
          v-if="form.category === 'trip' && !hasTargetPassenger"
          class="mt-2 text-sm text-amber-600"
        >
          หากต้องการรายงานพฤติกรรมผู้โดยสาร กรุณาเข้าหน้านี้จากรายการผู้โดยสารที่ต้องการรายงาน
        </p>
      </div>

      <!--แนบไฟล์-->
      <div class="mb-8">
        <label class="block mb-4 font-medium text-lg">แนบหลักฐาน</label>
        
        <!--ปุ่มเลือกประเภทหลักฐานภาพ วิดีโอ เสียง -->
        <div class="flex gap-3 mb-5">
            <button
            v-for="type in uploadTypes"
            :key="type.value"
            type="button"
            @click="activeUpload = type.value"
            :class="[
                'px-4 py-2 rounded transition',
                activeUpload === type.value
                ? 'bg-blue-600 text-white'
                : 'px-4 py-2 bg-gray-100 text-gray-600 rounded hover:bg-gray-200'
            ]">
            {{ type.label }}
            </button>
        </div>

        <div
        v-if="activeUpload"
        class="p-4 border border-gray-200 rounded-lg bg-gray-50"
        >
        <input
        type="file"
        :accept="getAcceptType(activeUpload)"
        multiple
        @change="handleUpload"
        class="mb-2" 
        />
        <p class="px-4 py-2 text-gray-400 ">
          เลือกไฟล์แนบรวมกันได้ไม่เกิน 3 ไฟล์ (รูป/เสียง/mp4)
          (รวม {{ getTotalFiles() }}/3)
        </p>
        <ul class="text-sm mt-2">
            <li v-for="(file, index) in form[activeUpload + 's']" :key="index">
                • {{ file.name }}
            </li>
        </ul>
        <!--preview-->
        <div v-if="form.images.length" class="mt-4">
          <div class="grid grid-cols-3 gap-3">
            <img
            v-for="(file, index) in form.images"
            :key="index"
            :src="file.url"
            @click="openPreview('image', file.url)"
            class="w-full h-full object-cover rounded cursor-pointer hover:scale-105 transition"/>
          </div>
        </div>
        <div v-if="form.videos.length" class="mt-4">
          <div class="space-y-3">
            <video
            v-for="(file, index) in form.videos"
            :key="index"
            :src="file.url"
            @click="openPreview('video', file.url)"
            class="w-full h-full object-cover rounded cursor-pointer hover:scale-105 transition">
            </video>
          </div>
        </div>
        
        <div v-if="form.audios.length" class="mt-4">
          <div class="space-y-2">
            <div
            v-for="(file, index) in form.audios"
            :key="index"
            @click="openPreview('audio', file.url)"
            class="p-2 bg-gray-100 rounded cursor-pointer hover:bg-gray-200"
            >
             ▶ {{ file.name }}
            </div>
          </div>
        </div>

        </div>

      </div>
      
      <div class="flex justify-end space-x-3 mt-8">
        <button
        type="button"
        class="px-4 py-2 bg-gray-100 text-gray-600 rounded hover:bg-gray-200"
        @click="resetForm"
        >
        ยกเลิก
        </button>

        <button
        type="button"
        class="px-6 py-2 bg-red-600 text-white rounded hover:bg-red"
        :disabled="isSubmitting"
        @click="submitForm"
        >
        {{ isSubmitting ? 'กำลังส่ง...' : 'ส่งรายงาน' }}
        </button>
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
import { reactive,ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'

const { $api } = useNuxtApp()
const reports = useReports()
const router = useRouter()
const route = useRoute()

const normalizeQueryId = (value) => {
  const raw = Array.isArray(value) ? value[0] : value
  if (raw === null || raw === undefined) return null

  const id = String(raw).trim()
  if (!id || id === 'undefined' || id === 'null') return null

  return id
}

const passengerId = normalizeQueryId(route.query.passenger)
const routeId = normalizeQueryId(route.query.route)
const hasTargetPassenger = !!passengerId
const form = reactive({
  title: '',
  detail: '',
  category: route.query.category || 'system',  tag: '',
  images: [],
  videos: [],
  audios: []
})

const resetForm = () => {
  form.title = ''
  form.detail = ''
  form.category = 'system'
  form.tag = ''
  form.images = []
  form.videos = []
  form.audios = []
  activeUpload.value = null
}

const isSubmitting = ref(false)

const submitForm = async () => {
  if (!form.title || !form.detail || !form.tag) {
    alert('กรุณากรอกข้อมูลให้ครบ')
    return
  }

  if (form.tag === 'พฤติกรรมผู้โดยสาร' && !hasTargetPassenger) {
    alert('กรุณาเลือกรายงานจากผู้โดยสารที่ต้องการรายงานก่อน')
    return
  }

  if (form.category === 'trip' && form.tag !== 'พฤติกรรมผู้โดยสาร' && !routeId) {
    alert('ไม่พบข้อมูลเส้นทาง กรุณาเข้าหน้านี้จากหน้ารายการเดินทาง')
    return
  }

  isSubmitting.value = true

  try {
    const categoryMap = { system: 'SYSTEM', trip: 'TRIP' }
    const typeMap = {
    'แอปพลิเคชันขัดข้อง': 'APPLICATION_PROBLEM',
    'แผนที่ขัดข้อง': 'MAP_PROBLEM',
    'ระบบทำงานล่าช้า': 'SYSTEM_SLOW',
    'อุบัติเหตุ': 'ACCIDENT',
    'พฤติกรรมผู้โดยสาร': 'PASSENGER_BEHAVIOR',
    'อื่น ๆ': 'OTHER'
    }

    const formData = new FormData()
    formData.append('title', form.title)
    formData.append('description', form.detail)
    formData.append('category', categoryMap[form.category])
    const mappedType = typeMap[form.tag]
    if (mappedType) {
      formData.append('type', mappedType)
    }

    if (routeId) formData.append('routeId', routeId)
    if (passengerId) formData.append('targetUserId', passengerId)

    form.images.forEach(item => formData.append('images', item.file))
    form.videos.forEach(item => formData.append('videos', item.file))
    form.audios.forEach(item => formData.append('audios', item.file))

    const res = await $api('/reports', {
      method: 'POST',
      body: formData
    })
      alert('ส่งรายงานปัญหาสำเร็จ ✓')
      resetForm()
      router.push('/')
  } catch (err) {
    alert('ส่งรายงานไม่สำเร็จ\n' + (err.data?.message || err.message || 'กรุณาลองใหม่'))
  } finally {
    isSubmitting.value = false
  }
}

const categoryButton = (type) => {
  return form.category === type
    ? 'px-4 py-2 bg-blue-600 text-white rounded'
    : 'px-4 py-2 bg-gray-100 text-gray-600 rounded hover:bg-gray-200'
}

const activeUpload = ref(null)

const uploadTypes = [
  { label: 'เพิ่มรูปภาพ', value: 'image' },
  { label: 'เพิ่มวิดีโอ', value: 'video' },
  { label: 'เพิ่มเสียง', value: 'audio' }
]

const getAcceptType = (type) => {
  if (type === 'image') return 'image/*'
  if (type === 'video') return 'video/mp4'
  if (type === 'audio') return 'audio/*'
}

const getTotalFiles = () => {
  return form.images.length + form.videos.length + form.audios.length
}

const getFileCount = (type) => {
  if (type === 'image') return form.images.length
  if (type === 'video') return form.videos.length
  if (type === 'audio') return form.audios.length
}

const handleUpload = (e) => {
  const files = Array.from(e.target.files)

  if (getTotalFiles() + files.length > 3) {
    alert('อัปโหลดไฟล์แนบรวมกันได้ไม่เกิน 3 ไฟล์')
    return
  }

  if (activeUpload.value === 'image') {
    form.images.push(
      ...files.map(file => ({
        file,
        url: URL.createObjectURL(file),
        name: file.name
      }))
    )
  }

  if (activeUpload.value === 'video') {
    const hasNonMp4 = files.some(file => file.type !== 'video/mp4')
    if (hasNonMp4) {
      alert('รองรับเฉพาะวิดีโอไฟล์ .mp4 เท่านั้น')
      return
    }

    form.videos.push(
      ...files.map(file => ({
        file,
        url: URL.createObjectURL(file),
        name: file.name
      }))
    )
  }

  if (activeUpload.value === 'audio') {
    form.audios.push(
      ...files.map(file => ({
        file,
        url: URL.createObjectURL(file),
        name: file.name
      }))
    )
  }
}

// preview
const preview = reactive({
  show: false,
  type: '',
  url: ''
})

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

</script>