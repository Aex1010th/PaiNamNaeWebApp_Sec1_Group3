<template>
  <div class="h-screen flex flex-col bg-gray-50 overflow-hidden">
    <AdminHeader />
    <div class="flex flex-1 overflow-hidden">
      <AdminSidebar />
      <div id="main-content" class="main-content flex-1 overflow-y-auto p-6 lg:p-8" style="margin-left: 280px;">

        <div class="mb-8 flex items-center justify-between">
          <div class="flex items-center gap-4">
            <button @click="goBack"
              class="flex items-center justify-center w-10 h-10 bg-white border rounded-xl shadow-sm hover:bg-gray-100 transition text-gray-600">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd"
                  d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z"
                  clip-rule="evenodd" />
              </svg>
            </button>
            <div>
              <h1 class="text-2xl font-semibold text-gray-800">System Incident Details</h1>
              <p class="text-sm text-gray-500">
                Viewing details for <span class="font-medium text-blue-600">{{ incidentId }}</span>
              </p>
            </div>
          </div>
        </div>

        <div v-if="incident" class="grid grid-cols-1 lg:grid-cols-3 gap-6">

          <div class="lg:col-span-2 space-y-6">

            <div class="bg-white rounded-2xl shadow-sm border p-6">
              <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">General Information</h2>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-y-6 gap-x-8">
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Title</p>
                  <p class="font-medium text-gray-800">{{ incident.title }}</p>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Status</p>
                  <span class="px-3 py-1 text-xs font-semibold rounded-full" :class="statusClass(incident.status)">
                    {{ incident.status }}
                  </span>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Category</p>
                  <p class="font-medium text-gray-800">{{ incident.category }}</p>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Reported Time</p>
                  <p class="font-medium text-gray-800">{{ incident.reportTime }}</p>
                </div>
                <div class="md:col-span-2 border-t pt-4 mt-2">
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Description</p>
                  <p class="font-medium text-gray-800 leading-relaxed whitespace-pre-line">{{ incident.description }}
                  </p>
                </div>
                <div class="md:col-span-2 border-t pt-4 mt-2">
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Reported By</p>
                  <p class="font-medium text-gray-800">{{ incident.user }}</p>
                </div>
              </div>
            </div>

            <div class="bg-white rounded-2xl shadow-sm border p-6">
              <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">Admin Response</h2>
              <div class="space-y-4">
                <textarea v-model="adminReply" rows="5"
                  placeholder="Write your response, findings, or reason for rejection here..."
                  class="w-full p-4 border rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm text-gray-700 resize-y"></textarea>
                <div class="flex items-center justify-between">
                  <p class="text-xs text-gray-500">* Please provide details before rejecting or resolving the incident.
                  </p>
                  <div class="flex gap-3">
                    <button @click="handleAction('REJECTED')" :disabled="!adminReply.trim()"
                      class="px-5 py-2.5 bg-white border border-red-200 text-red-600 rounded-xl hover:bg-red-50 transition font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                      Reject
                    </button>
                    <button @click="handleAction('RESOLVED')" :disabled="!adminReply.trim()"
                      class="px-5 py-2.5 bg-green-600 text-white rounded-xl hover:bg-green-700 transition font-medium shadow-sm disabled:opacity-50 disabled:cursor-not-allowed">
                      Mark as Resolved
                    </button>
                  </div>
                </div>
              </div>
            </div>

          </div>

          <div class="space-y-6">
            <div class="bg-white rounded-2xl shadow-sm border p-6">
              <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">Attached Media</h2>
              <div v-if="incident.media && incident.media.length > 0" class="space-y-4">
                <div v-for="file in incident.media" :key="file.id" class="border rounded-xl p-3 bg-gray-50">
                  <p class="text-xs font-medium text-gray-600 mb-2 truncate" :title="file.name">
                    📎 {{ file.name }}
                  </p>
                  <img v-if="file.type === 'image'" :src="file.url" alt="Attachment"
                    class="rounded-lg w-full h-auto object-contain max-h-48 bg-gray-200" />
                  <video v-else-if="file.type === 'video'" :src="file.url" controls
                    class="rounded-lg w-full max-h-48 bg-black"></video>
                  <audio v-else-if="file.type === 'audio'" :src="file.url" controls class="w-full mt-2 h-10"></audio>
                </div>
              </div>
              <div v-else class="text-center py-8 text-gray-400 text-sm border-2 border-dashed rounded-xl">
                No media attached
              </div>
            </div>
          </div>

        </div>

        <div v-else class="text-center py-20 flex flex-col items-center justify-center h-[60vh]">
          <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600 mb-4"></div>
          <p class="text-gray-500">Loading incident data...</p>
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

const incidentId = route.params.id
const incident = ref(null)
const adminReply = ref('')

const fetchIncidentDetail = () => {
  setTimeout(() => {
    incident.value = {
      id: incidentId,
      title: 'App crashed on startup during ride acceptance',
      reportTime: '2026-02-25 14:10',
      user: 'driver@email.com',
      type: 'SYSTEM',
      category: 'App Crash',
      status: 'PENDING',
      description: 'The app crashed immediately upon startup when attempting to accept a ride. The user reported seeing a black screen and an error message before the app closed.',
      media: [
        { id: 1, type: 'image', name: 'error_screenshot.jpg', url: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=400&auto=format&fit=crop' },
        { id: 2, type: 'video', name: 'screen_recording.mp4', url: 'https://www.w3schools.com/html/mov_bbb.mp4' },
        { id: 3, type: 'audio', name: 'voice_note.mp3', url: 'https://www.w3schools.com/html/horse.mp3' }
      ]
    }
  }, 500)
}

const goBack = () => router.back()

const handleAction = (newStatus) => {
  if (!adminReply.value.trim()) return
  incident.value.status = newStatus
  alert(`Incident has been marked as ${newStatus} successfully.`)
  router.push('/admin/incidents')
}

const statusClass = (status) => {
  switch (status) {
    case 'PENDING': return 'bg-yellow-100 text-yellow-700'
    case 'RESOLVED': return 'bg-green-100 text-green-700'
    case 'REJECTED': return 'bg-red-100 text-red-700'
    default: return 'bg-gray-100 text-gray-600'
  }
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
  window.removeEventListener('resize', window.__adminResizeHandler__ || (() => { }))
  delete window.toggleSidebar
  delete window.toggleMobileSidebar
  delete window.toggleSubmenu
  delete window.__adminResizeHandler__
}

onMounted(() => {
  defineGlobalScripts()
  if (typeof window.__adminResizeHandler__ === 'function') window.__adminResizeHandler__()
  if (incidentId) fetchIncidentDetail()
})

onUnmounted(() => cleanupGlobalScripts())
</script>

<style>
.sidebar {
  transition: width 0.3s ease;
}

.sidebar.collapsed {
  width: 80px;
}

.sidebar:not(.collapsed) {
  width: 280px;
}

.sidebar-item {
  transition: all 0.3s ease;
}

.sidebar.collapsed .sidebar-text {
  display: none;
}

.sidebar.collapsed .sidebar-item {
  justify-content: center;
}

.main-content {
  transition: margin-left 0.3s ease;
}

@media (max-width: 1024px) {
  .sidebar {
    position: fixed;
    z-index: 1000;
    transform: translateX(-100%);
  }

  .sidebar.mobile-open {
    transform: translateX(0);
  }

  .main-content {
    margin-left: 0 !important;
  }
}
</style>