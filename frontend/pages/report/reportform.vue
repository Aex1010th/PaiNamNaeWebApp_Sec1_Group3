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
            <option>พฤติกรรมผู้โดยสาร</option>
            <option>อื่น ๆ</option>
          </template>

        </select>
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
            เลือกภาพ วิดีโอ เสียง ได้ประเภทละไม่เกิน 3 ไฟล์
            ({{ getFileCount(activeUpload) }}/3)
        </p>
        <ul class="text-sm mt-2">
            <li v-for="(file, index) in form[activeUpload + 's']" :key="index">
                • {{ file.name }}
            </li>
        </ul>
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
        @click="submitForm"
        >
        ส่ง
        </button>
      </div>

    </div>
  </div>
</template>


<script setup>
import { reactive,ref } from 'vue'
import { useRouter } from 'vue-router'

const reports = useReports()

const router = useRouter()

const form = reactive({
  title: '',
  detail: '',
  category: 'system',
  tag: '',
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

const submitForm = () => {
  if (!form.title || !form.detail || !form.tag) {
    alert('กรุณากรอกข้อมูลให้ครบ')
    return
  }

  reports.value.push({
    id: Date.now(),
    title: form.title,
    description: form.description,
    createdAt: new Date().toLocaleString(),
    updatedAt: null,
    status: 'ส่งรายงานปัญหาแล้ว',
    adminMessage: ''
  })

  alert('ส่งรายงานปัญหาสำเร็จ ขอบคุณสำหรับการรายงานปัญหาของคุณ')

  resetForm()

  router.push('/')
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
  if (type === 'video') return 'video/*'
  if (type === 'audio') return 'audio/*'
}

const getFileCount = (type) => {
  if (type === 'image') return form.images.length
  if (type === 'video') return form.videos.length
  if (type === 'audio') return form.audios.length
}

const handleUpload = (e) => {
  const files = Array.from(e.target.files)

  if (activeUpload.value === 'image') {
    if (form.images.length + files.length > 3) {
      alert('อัปโหลดรูปได้ไม่เกิน 3 รูป')
      return
    }
    form.images.push(...files)
  }

  if (activeUpload.value === 'video') {
    if (form.videos.length + files.length > 3) {
      alert('อัปโหลดวิดีโอได้ไม่เกิน 3 ไฟล์')
      return
    }
    form.videos.push(...files)
  }

  if (activeUpload.value === 'audio') {
    if (form.audios.length + files.length > 3) {
      alert('อัปโหลดเสียงได้ไม่เกิน 3 ไฟล์')
      return
    }
    form.audios.push(...files)
  }
}

</script>