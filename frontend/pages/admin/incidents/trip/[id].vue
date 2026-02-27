<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

/* ======================================
   REPOSITORY
====================================== */
const incidentRepository = {
  async getById(id) {
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve({
          id,
          title: 'Driver was rude',
          status: 'OPEN',
          driverId: 'DRV-889',
          tripId: 'TRP-555',
          timeReported: '2026-02-26',
          description: 'Driver spoke aggressively during trip.'
        })
      }, 600)
    })
  }
}

/* ======================================
   STATE
====================================== */
const route = useRoute()
const router = useRouter()

const loading = ref(false)
const error = ref(null)
const incident = ref(null)

const status = ref('')
const note = ref('')

async function loadDetail() {
  try {
    loading.value = true
    incident.value = await incidentRepository.getById(route.params.id)
    status.value = incident.value.status
  } catch (e) {
    error.value = 'Failed to load incident'
  } finally {
    loading.value = false
  }
}

onMounted(loadDetail)

function saveAction() {
  console.log({
    id: incident.value.id,
    newStatus: status.value,
    note: note.value
  })
}
</script>

<template>
  <div class="min-h-screen bg-gray-50 p-10">

    <div class="mb-6 text-sm text-gray-500">
      Admin / Incidents / {{ route.params.id }}
    </div>

    <div v-if="loading"
         class="bg-white p-8 rounded-xl shadow animate-pulse">
      <div class="h-4 bg-gray-200 rounded w-1/2 mb-4"></div>
      <div class="h-4 bg-gray-200 rounded w-1/3"></div>
    </div>

    <div v-else-if="error"
         class="bg-white p-8 rounded-xl shadow text-red-600">
      {{ error }}
    </div>

    <div v-else-if="incident"
         class="grid grid-cols-3 gap-8">

      <!-- Main -->
      <div class="col-span-2 bg-white rounded-xl shadow p-8 space-y-6">
        <h2 class="text-2xl font-bold">{{ incident.title }}</h2>

        <div class="grid grid-cols-2 gap-6 text-sm">
          <div><strong>Driver:</strong> {{ incident.driverId }}</div>
          <div><strong>Trip:</strong> {{ incident.tripId }}</div>
          <div><strong>Reported:</strong> {{ incident.timeReported }}</div>
        </div>

        <div>
          <h3 class="font-semibold mb-2">Description</h3>
          <p class="text-gray-600">{{ incident.description }}</p>
        </div>
      </div>

      <!-- Action Panel -->
      <div class="bg-white rounded-xl shadow p-6 space-y-4 sticky top-10">
        <h3 class="font-semibold">Admin Action</h3>

        <select v-model="status"
          class="w-full border px-3 py-2 rounded">
          <option>OPEN</option>
          <option>IN_PROGRESS</option>
          <option>RESOLVED</option>
        </select>

        <textarea v-model="note"
          rows="4"
          placeholder="Internal note..."
          class="w-full border rounded p-3"></textarea>

        <button @click="saveAction"
          class="w-full bg-blue-600 text-white py-2 rounded">
          Save
        </button>

        <button @click="router.push('/admin/incidents')"
          class="w-full border py-2 rounded">
          Back
        </button>
      </div>

    </div>

  </div>
</template>