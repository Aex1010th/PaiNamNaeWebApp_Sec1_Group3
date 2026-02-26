<template>
  <div class="h-screen flex flex-col bg-gray-50 overflow-hidden">
    <AdminHeader />
    <div class="flex flex-1 overflow-hidden">
      <AdminSidebar />
      <div id="main-content" class="main-content flex-1 overflow-y-auto p-6 lg:p-8" style="margin-left: 280px;">

        <div class="mb-6 text-sm text-gray-500">
          Admin / Incidents / {{ route.params.id }}
        </div>

        <div v-if="loading" class="bg-white p-8 rounded-xl shadow animate-pulse">
          <div class="h-4 bg-gray-200 rounded w-1/2 mb-4"></div>
          <div class="h-4 bg-gray-200 rounded w-1/3"></div>
        </div>

        <div v-else-if="error" class="bg-white p-8 rounded-xl shadow text-red-600">
          {{ error }}
        </div>

        <div v-else-if="incident" class="grid grid-cols-3 gap-8">

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
            <select v-model="status" class="w-full border px-3 py-2 rounded">
              <option>OPEN</option>
              <option>IN_PROGRESS</option>
              <option>RESOLVED</option>
            </select>
            <textarea v-model="note" rows="4" placeholder="Internal note..."
              class="w-full border rounded p-3"></textarea>
            <button @click="saveAction" class="w-full bg-blue-600 text-white py-2 rounded">
              Save
            </button>
            <button @click="router.push('/admin/incidents')" class="w-full border py-2 rounded">
              Back
            </button>
          </div>

        </div>

      </div>
    </div>
  </div>
</template>

<script setup>
import AdminHeader from '~/components/admin/AdminHeader.vue'
import AdminSidebar from '~/components/admin/AdminSidebar.vue'
import { ref, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

useHead({
  link: [
    { rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css' }
  ]
})

const route = useRoute()
const router = useRouter()

const loading = ref(false)
const error = ref(null)
const incident = ref(null)
const status = ref('')
const note = ref('')

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

function saveAction() {
  console.log({ id: incident.value.id, newStatus: status.value, note: note.value })
}

function defineGlobalScripts() {
  window.toggleSidebar = function () {
    const sidebar = document.getElementById('sidebar')
    const mainContent = document.getElementById('main-content')
    const toggleIcon = document.getElementById('toggle-icon')
    if (!sidebar || !mainContent || !toggleIcon) return
    sidebar.classList.toggle('collapsed')
    mainContent.style.marginLeft = sidebar.classList.contains('collapsed') ? '80px' : '280px'
    toggleIcon.classList.replace(
      sidebar.classList.contains('collapsed') ? 'fa-chevron-left' : 'fa-chevron-right',
      sidebar.classList.contains('collapsed') ? 'fa-chevron-right' : 'fa-chevron-left'
    )
  }
  window.toggleMobileSidebar = function () {
    const sidebar = document.getElementById('sidebar')
    const overlay = document.getElementById('overlay')
    if (!sidebar || !overlay) return
    sidebar.classList.toggle('mobile-open')
    overlay.classList.toggle('hidden')
  }
  window.toggleSubmenu = function (menuId) {
    const menu = document.getElementById(menuId)
    const icon = document.getElementById(menuId + '-icon')
    if (!menu || !icon) return
    menu.classList.toggle('hidden')
    if (menu.classList.contains('hidden')) {
      icon.classList.replace('fa-chevron-up', 'fa-chevron-down')
    } else {
      icon.classList.replace('fa-chevron-down', 'fa-chevron-up')
    }
  }
  window.__adminResizeHandler__ = function () {
    const sidebar = document.getElementById('sidebar')
    const mainContent = document.getElementById('main-content')
    const overlay = document.getElementById('overlay')
    if (!sidebar || !mainContent || !overlay) return
    if (window.innerWidth >= 1024) {
      sidebar.classList.remove('mobile-open')
      overlay.classList.add('hidden')
      mainContent.style.marginLeft = sidebar.classList.contains('collapsed') ? '80px' : '280px'
    } else {
      mainContent.style.marginLeft = '0'
    }
  }
  window.addEventListener('resize', window.__adminResizeHandler__)
}

function cleanupGlobalScripts() {
  window.removeEventListener('resize', window.__adminResizeHandler__ || (() => {}))
  delete window.toggleSidebar
  delete window.toggleMobileSidebar
  delete window.toggleSubmenu
  delete window.__adminResizeHandler__
}

onMounted(() => {
  defineGlobalScripts()
  if (typeof window.__adminResizeHandler__ === 'function') window.__adminResizeHandler__()
  loadDetail()
})

onUnmounted(() => cleanupGlobalScripts())
</script>

<style>
.sidebar { transition: width 0.3s ease; }
.sidebar.collapsed { width: 80px; }
.sidebar:not(.collapsed) { width: 280px; }
.sidebar-item { transition: all 0.3s ease; }
.sidebar.collapsed .sidebar-text { display: none; }
.sidebar.collapsed .sidebar-item { justify-content: center; }
.main-content { transition: margin-left 0.3s ease; }
@media (max-width: 1024px) {
  .sidebar { position: fixed; z-index: 1000; transform: translateX(-100%); }
  .sidebar.mobile-open { transform: translateX(0); }
  .main-content { margin-left: 0 !important; }
}
</style>