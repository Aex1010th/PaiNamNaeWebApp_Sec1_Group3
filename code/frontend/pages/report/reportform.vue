<template>
  <div class="min-h-screen bg-gray-100 flex justify-center py-10">
    <div class="w-full max-w-2xl bg-white p-8 rounded-2xl shadow-sm border border-gray-100">

      <div class="text-center mb-2 flex items-center justify-center gap-2">
        <svg xmlns="http://www.w3.org/2000/svg"
        class="w-6 h-6 text-red-500"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor">

        <path stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M12 9v3m0 4h.01M10.29 3.86l-7.29 12.6A1 1 0 004 18h16a1 1 0 00.87-1.5l-7.29-12.6a1 1 0 00-1.74 0z"/>
        </svg>
        <h1 class="text-2xl font-semibold">
        รายงานปัญหา
      </h1>
      </div>
      <p class="text-center text-gray-400 text-sm mb-8">
        หากพบปัญหา กรุณาแจ้งรายละเอียดด้านล่าง ทีมงานจะรีบตรวจสอบและแก้ไขให้เร็วที่สุด
      </p>

      <!--Title ปัญหา-->
      <div class="mb-6">
        <label class="block mb-2 font-medium">หัวข้อปัญหา</label>
        <input
          v-model="form.title"
          type="text"
          placeholder="หัวข้อปัญหา"
          :class="[
          'w-full border rounded-2xl px-4 py-2.5 focus:outline-none focus:border-blue-200 transition',
          form.title ? 'bg-white border-blue-100' : 'bg-gray-50 border-gray-200'
          ]"
        />
      </div>

      <!--คำอธิบายปัญหา-->
      <div class="mb-6">
        <label class="block mb-2 font-medium">รายละเอียด</label>
        <textarea
          v-model="form.detail"
          rows="5"
          placeholder="อธิบายปัญหา"
          :class="[
          'w-full border rounded-2xl px-4 py-2.5 focus:outline-none focus:border-blue-200 transition',
          form.detail ? 'bg-white border-blue-100' : 'bg-gray-50 border-gray-200'
          ]"        
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
            รายงานปัญหาระบบ
          </button>

          <button
            type="button"
            @click="form.category = 'trip'"
            :class="categoryButton('trip')"
          >
            รายงานปัญหาการเดินทาง
          </button>
        </div>
      </div>

       <!-- Tag หลังเลือกหมวดหมู่ เปลี่ยนเป็นให้คลิกเลือกดูง่ายกว่า คลิกได้ 1 ประเภท-->
      <div class="mb-6">
        <label class="block mb-3 font-medium">ประเภท</label>

        <div class="flex flex-wrap gap-2">
          <template v-if="form.category === 'system'">

            <button
              type="button"
              @click="selectTag('แอปพลิเคชันขัดข้อง')"
              :class="tagClass('แอปพลิเคชันขัดข้อง')"
            >
              แอปพลิเคชันขัดข้อง
            </button>

            <button
              type="button"
              @click="selectTag('แผนที่ขัดข้อง')"
              :class="tagClass('แผนที่ขัดข้อง')"
            >
              แผนที่ขัดข้อง
            </button>

            <button
              type="button"
              @click="selectTag('ระบบทำงานล่าช้า')"
              :class="tagClass('ระบบทำงานล่าช้า')"
            >
              ระบบทำงานล่าช้า
            </button>

            <button
              type="button"
              @click="selectTag('อื่น ๆ')"
              :class="tagClass('อื่น ๆ')"
            >
              อื่น ๆ
            </button>

          </template>

          <!-- Trip -->
          <template v-if="form.category === 'trip'">

            <button
              type="button"
              @click="selectTag('อุบัติเหตุ')"
              :class="tagClass('อุบัติเหตุ')"
            >
              อุบัติเหตุ
            </button>

            <button
              type="button"
              :disabled="!hasTargetPassenger"
              @click="selectTag('พฤติกรรมผู้โดยสาร')"
              :class="tagClass('พฤติกรรมผู้โดยสาร')"
            >
              พฤติกรรมผู้โดยสาร
            </button>

            <button
              type="button"
              @click="selectTag('อื่น ๆ')"
              :class="tagClass('อื่น ๆ')"
            >
              อื่น ๆ
            </button>

          </template>

        </div>

        <p
          v-if="form.category === 'trip' && !hasTargetPassenger"
          class="mt-2 text-sm text-amber-600"
        >
          หากต้องการรายงานพฤติกรรมผู้โดยสาร กรุณาเข้าหน้านี้จากรายการผู้โดยสารที่ต้องการรายงาน
        </p>
      </div>

      <!--แนบไฟล์-->
      <div class="mb-8">
       <div class="p-4 border border-gray-200 rounded-2xl bg-white">

        <!-- upload box -->
        <label
          class="flex flex-col items-center justify-center w-full h-32 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer hover:border-blue-400 hover:bg-blue-50 transition"
        >

          <!--ไอคอนบวกตรงนี้-->
      <div class="text-gray-400 mb-2">
      <svg xmlns="http://www.w3.org/2000/svg"
        class="w-8 h-8"
        fill="none"
        viewBox="0 0 24 24"
        stroke="currentColor">

      <path stroke-linecap="round"
      stroke-linejoin="round"
            stroke-width="2"
      d="M12 4v16m8-8H4"/>
      </svg>
      </div>

          <p class="text-sm text-gray-500">
            คลิกเพื่อแนบไฟล์
          </p>
          <p class="text-xs text-gray-400">
            รูป / เสียง / วิดีโอ
          </p>
          <input
            type="file"
            accept="image/*,video/mp4,audio/*"
            multiple
            @change="handleUpload"
            class="hidden"
          />

        </label>

        <p class="px-4 py-2 text-gray-400 text-sm">
          แนบได้ไม่เกิน 3 ไฟล์ (รวม {{ getTotalFiles() }}/3)
        </p>

          <!-- รายชื่อไฟล์ -->
          <ul class="text-sm mt-2">
            <li v-for="(file, index) in allFiles" :key="index">
              • {{ file.name }}
            </li>
          </ul>

<!-- preview media -->
<div v-if="form.images.length || form.videos.length" class="mt-4">
  <div class="grid grid-cols-3 gap-3">

    <!-- image -->
    <div
      v-for="(file, index) in form.images"
      :key="'img'+index"
      class="relative"
    >
      <img
        :src="file.url"
        @click="openPreview('image', file.url)"
        class="w-full aspect-square object-cover rounded-xl cursor-pointer"
      />

      <button
        @click.stop="removeFile('image', index)"
        class="absolute top-1 right-1 bg-black/60 text-white w-5 h-5 rounded-full text-xs flex items-center justify-center"
      >
        ✕
      </button>
    </div>

    <!-- video -->
    <div
      v-for="(file, index) in form.videos"
      :key="'vid'+index"
      class="relative"
    >
      <video
        :src="file.url"
        controls
        @click="openPreview('video', file.url)"
        class="w-full aspect-square object-cover rounded-xl cursor-pointer"
      ></video>

      <button
        @click.stop="removeFile('video', index)"
        class="absolute top-1 right-1 bg-black/60 text-white w-5 h-5 rounded-full text-xs flex items-center justify-center"
      >
        ✕
      </button>
    </div>

  </div>
</div>

    <!-- preview audio -->
    <div v-if="form.audios.length" class="mt-4 space-y-2">
      <div
        v-for="(file, index) in form.audios"
        :key="index"
        class="flex items-center justify-between p-2 bg-gray-100 rounded hover:bg-gray-200"
      >
        <span
          class="cursor-pointer"
          @click="openPreview('audio', file.url)"
        >
          ▶ {{ file.name }}
        </span>

        <button
          @click.stop="removeFile('audio', index)"
          class="text-gray-500 hover:text-red-500 text-sm"
        >
          ลบ
        </button>
      </div>
    </div>

  </div>
</div>
      
      <div class="flex justify-end space-x-3 mt-8">
        <button
        type="button"
        class="px-5 py-2.5 bg-gray-100 text-gray-500 rounded-full hover:bg-gray-200 transition"
        @click="resetForm"
        >
        ยกเลิก
        </button>

        <button
        type="button"
        class="px-6 py-2.5 bg-red-100 text-red-600 rounded-full hover:bg-red-200 transition"
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
import Swal from 'sweetalert2'
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
    Swal.fire({
      title: 'ส่งรายงานสำเร็จ',
      text: 'ขอบคุณสำหรับการแจ้งปัญหา ทีมงานจะตรวจสอบให้เร็วที่สุด',
      icon: 'success',
      confirmButtonText: 'ตกลง',
      confirmButtonColor: '#2563eb'
    }).then(() => {
      resetForm()
      router.push('/')()
  })
  } catch (err) {
    alert('ส่งรายงานไม่สำเร็จ\n' + (err.data?.message || err.message || 'กรุณาลองใหม่'))
  } finally {
    isSubmitting.value = false
  }
}

const categoryButton = (type) => {
  return form.category === type
    ? 'px-5 py-2 bg-blue-100 text-blue-700 border border-blue-200 rounded-2xl text-sm transition'
    : 'px-5 py-2 bg-gray-100 text-gray-600 border border-gray-200 rounded-2xl text-sm hover:bg-gray-200 transition'
}

const selectTag = (tag) => {
  form.tag = tag
}

const tagClass = (tag) => {
  return form.tag === tag
    ? 'px-5 py-2 bg-blue-100 text-blue-700 border border-blue-200 rounded-2xl text-sm transition'
    : 'px-5 py-2 bg-gray-100 text-gray-600 border border-gray-200 rounded-2xl text-sm hover:bg-gray-200 transition'
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
    Swal.fire({
      title: 'อัปโหลดเกินจำนวน',
      text: 'กรุณาแนบไฟล์ทั้งหมดไม่เกิน 3 ไฟล์',
      icon: 'warning',
      confirmButtonText: 'ตกลง',
      confirmButtonColor: '#f59e0b'
    });
    return
  }

  files.forEach(file => {

    const url = URL.createObjectURL(file)

    if (file.type.startsWith('image')) {
      form.images.push({
        file,
        url,
        name: file.name
      })
    }

    else if (file.type.startsWith('video')) {

      if (file.type !== 'video/mp4') {
        Swal.fire({
          title: 'ไม่รองรับประเภทไฟล์นี้',
          text: 'รองรับเฉพาะวิดีโอไฟล์ .mp4 เท่านั้น',
          icon: 'warning',
          confirmButtonText: 'ตกลง',
          confirmButtonColor: '#f59e0b'
        });
        return
      }

      form.videos.push({
        file,
        url,
        name: file.name
      })
    }

    else if (file.type.startsWith('audio')) {
      form.audios.push({
        file,
        url,
        name: file.name
      })
    }

  })
}

//ลบไฟล์แนบเมื่อยังไม่กดส่ง
const removeFile = (type, index) => {
  if (type === 'image') form.images.splice(index, 1)
  if (type === 'video') form.videos.splice(index, 1)
  if (type === 'audio') form.audios.splice(index, 1)
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