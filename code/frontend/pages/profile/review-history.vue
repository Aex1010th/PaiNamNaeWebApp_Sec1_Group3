<template>
  <div class="flex items-start justify-center min-h-screen py-8 bg-gray-100">
    <div class="flex w-full max-w-6xl mx-4 overflow-hidden bg-white border border-gray-300 rounded-lg shadow-lg">
      <ProfileSidebar />

      <main class="flex-1 p-8">
        <div class="mb-8 text-center">
          <div class="inline-flex items-center justify-center w-16 h-16 mb-4 bg-blue-600 rounded-full">
    <svg class="w-8 h-8 text-white" fill="currentColor" viewBox="0 0 24 24">
      <path d="M12 2l3 7h7l-5.5 4.5L18 21l-6-3.5L6 21l1.5-7.5L2 9h7z"/>
    </svg>
          </div>

          <h1 class="mb-2 text-3xl font-bold text-gray-800">ประวัติการรีวิว</h1>
          <p class="max-w-md mx-auto text-gray-500">
            ดูคะแนนและความคิดเห็นที่คุณเคยให้กับผู้ขับขี่ในแต่ละการเดินทาง
          </p>
        </div>

        <!-- Reviews -->
        <div class="space-y-4">

          <div
            v-for="review in reviews"
            :key="review.id"
            class="p-5 border border-gray-200 rounded-lg hover:shadow-md transition"
          >
            <div class="flex justify-between items-center mb-2">

              <!-- ชื่อ -->
              <div class="font-semibold text-gray-800">
                {{ review.targetName }}
              </div>

              <!-- ดาว -->
              <div class="text-yellow-500 text-sm">
                ⭐ {{ review.rating }}/5
              </div>

            </div>

            <!-- ข้อความรีวิว -->
            <p class="text-gray-600 text-sm mb-2">
              {{ review.comment }}
            </p>

            <!-- วันที่ -->
            <div class="text-xs text-gray-400">
              {{ review.date }}
            </div>

          </div>

        </div>

      </main>
    </div>
  </div>
</template>
<script setup>
//mockup data
const reviews = ref([
  {
    id: 1,
    targetName: 'สมชาย ใจดี',
    rating: 5,
    comment: 'เดินทางดีมาก ตรงเวลา',
    date: '12 มีนาคม 2569'
  },
  {
    id: 2,
    targetName: 'วิชัย ทองดี',
    rating: 4,
    comment: 'บริการดี แต่รถมาช้านิดหน่อย',
    date: '10 มีนาคม 2569'
  }
])
</script>

