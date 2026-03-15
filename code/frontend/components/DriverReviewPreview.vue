<template>
  <div class="flex items-center gap-6">
    <!-- กล่องคะแนน -->
    <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; padding: 0.75rem 1rem; background: white; border-radius: 0.5rem; border: 1px solid #e5e7eb;">
      <div style="display: flex; align-items: baseline;">
        <span style="font-size: 2.25rem; font-weight: 700; color: #111827; line-height: 1;">{{ averageRating }}</span>
        <span style="font-size: 1.25rem; color: #fbbf24; margin-left: 0.25rem;">★</span>
      </div>
      <div style="font-size: 0.75rem; color: #6b7280; margin-top: 0.25rem;">{{ totalReviews }} รีวิว</div>
    </div>

    <!-- ตารางกราฟ -->
    <div style="flex: 1;">
      <div style="display: flex; flex-direction: column; gap: 0.25rem;">
        <div v-for="star in [5, 4, 3, 2, 1]" :key="star" style="display: flex; align-items: center; gap: 0.5rem;">
          <!-- หมายเลข -->
          <span style="font-size: 0.75rem; font-weight: 500; color: #4b5563; width: 0.5rem;">{{ star }}</span>
          
          <!-- พื้นแท่ง -->
          <div style="width: 150px; height: 0.375rem; background-color: #e5e7eb; border-radius: 9999px; overflow: hidden; position: relative;">
            <!-- แท่งสี -->
            <div 
              style="height: 100%; background-color: #3b82f6; border-radius: 9999px; transition: width 0.5s ease;"
              :style="{ width: getStarPercentage(star) + '%' }"
            ></div>
          </div>
          
          <!-- เปอร์เซ็นต์ -->
          <span style="font-size: 0.75rem; color: #6b7280; width: 2rem; text-align: right; font-variant-numeric: tabular-nums;">{{ getStarPercentage(star) }}%</span>
        </div>
      </div>
    </div>

    <!-- Debug Info (ลบออกเมื่อใช้งานจริง) -->
    <div v-if="showDebug" style="position: absolute; top: 100%; left: 0; background: #fef3c7; padding: 0.5rem; font-size: 0.75rem; margin-top: 0.5rem; border-radius: 0.25rem; z-index: 10;">
      <div>Total: {{ totalReviews }}</div>
      <div v-for="star in [5,4,3,2,1]" :key="star">
        {{ star }}★: {{ getStarCount(star) }} ({{ getStarPercentage(star) }}%)
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
  reviews: {
    type: Object,
    default: () => ({
      average: 0,
      total: 0,
      breakdown: { 5: 0, 4: 0, 3: 0, 2: 0, 1: 0 }
    })
  },
  showDebug: {
    type: Boolean,
    default: false
  }
})

const averageRating = computed(() => {
  const avg = props.reviews.average || 0
  return avg.toFixed(1)
})

const totalReviews = computed(() => {
  return props.reviews.total || 0
})

function getStarPercentage(star) {
  if (!totalReviews.value) return 0
  const count = props.reviews.breakdown?.[star] || 0
  const percentage = (count / totalReviews.value) * 100
  return Math.round(percentage)
}

function getStarCount(star) {
  return props.reviews.breakdown?.[star] || 0
}
</script>