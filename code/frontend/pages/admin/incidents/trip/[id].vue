<template>
  <div class="h-screen flex flex-col bg-gray-50 overflow-hidden">
    <AdminHeader />
    <div class="flex flex-1 overflow-hidden">
      <AdminSidebar />
      <div id="main-content" class="main-content flex-1 overflow-y-auto p-6 lg:p-8" style="margin-left: 280px;">

        <div class="mb-8 flex items-center justify-between">
          <div class="flex items-center gap-4">
            <button @click="$router.back()"
              class="flex items-center justify-center w-10 h-10 bg-white border rounded-xl shadow-sm hover:bg-gray-100 transition text-gray-600">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd"
                  d="M9.707 16.707a1 1 0 01-1.414 0l-6-6a1 1 0 010-1.414l6-6a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l4.293 4.293a1 1 0 010 1.414z"
                  clip-rule="evenodd" />
              </svg>
            </button>
            <div>
              <h1 class="text-2xl font-semibold text-gray-800">Trip Incident Details</h1>
              <p class="text-sm text-gray-500">
                Viewing details for <span class="font-medium text-blue-600">{{ route.params.id }}</span>
              </p>
            </div>
          </div>
        </div>

        <!-- Loading -->
        <div v-if="pending" class="text-center py-20 flex flex-col items-center justify-center h-[60vh]">
          <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-blue-600 mb-4"></div>
          <p class="text-gray-500">Loading incident data...</p>
        </div>

        <!-- Error -->
        <div v-else-if="error" class="text-center py-20 text-red-500">
          Error: {{ error.message }}
        </div>

        <div v-else-if="incident" class="grid grid-cols-1 lg:grid-cols-3 gap-6">

          <!-- Left -->
          <div class="lg:col-span-2 space-y-6">
            <div class="bg-white rounded-2xl shadow-sm border p-6">
              <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">General Information</h2>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-y-6 gap-x-8">
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Report ID</p>
                  <p class="font-medium text-gray-800">{{ incident.id }}</p>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Status</p>
                  <span class="px-3 py-1 text-xs font-semibold rounded-full" :class="statusClass(incident.status)">
                    {{ statusLabel(incident.status) }}
                  </span>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Reporter</p>
                  <p class="font-medium text-gray-800">
                    {{ incident.reporter ? `${incident.reporter.firstName} ${incident.reporter.lastName}` : '-' }}
                  </p>
                </div>
                <div v-if="incident.targetUser">
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Target User</p>
                  <p class="font-medium text-gray-800">
                    {{ `${incident.targetUser.firstName} ${incident.targetUser.lastName}` }}
                  </p>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Category</p>
                  <p class="font-medium text-gray-800">{{ incident.category ?? '-' }}</p>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Type</p>
                  <p class="font-medium text-gray-800">{{ incident.type ?? '-' }}</p>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Route ID</p>
                  <p class="font-medium text-gray-800">{{ incident.routeId ?? '-' }}</p>
                </div>
                <div>
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Reported Time</p>
                  <p class="font-medium text-gray-800">{{ formatDate(incident.createdAt) }}</p>
                </div>
                <div class="md:col-span-2 border-t pt-4 mt-2">
                  <p class="text-xs text-gray-500 mb-1 uppercase tracking-wider">Description</p>
                  <p class="font-medium text-gray-800 leading-relaxed whitespace-pre-line">{{ incident.description }}</p>
                </div>
              </div>
            </div>

            <!-- Admin Response -->
            <div class="bg-white rounded-2xl shadow-sm border p-6">
              <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">Admin Response</h2>

              <!-- Previous reply -->
              <div v-if="incident.adminReply" class="mb-4 p-4 bg-blue-50 rounded-xl border border-blue-100">
                <p class="text-xs text-blue-500 uppercase mb-1">Previous Reply</p>
                <p class="text-blue-700 text-sm">{{ incident.adminReply }}</p>
              </div>

              <div class="space-y-4">
                <div>
                  <label class="text-xs text-gray-500 uppercase mb-1 block">Update Status</label>
                  <select v-model="form.status"
                    class="w-full border rounded-xl px-3 py-2 text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                    <option value="RECEIVED">Received</option>
                    <option value="IN_PROGRESS">In Progress</option>
                    <option value="RESOLVED">Resolved</option>
                    <option value="REJECTED">Rejected</option>
                  </select>
                </div>

                <textarea v-model="form.adminReply" rows="5"
                  placeholder="Write your response, findings, or reason for rejection here..."
                  class="w-full p-4 border rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm text-gray-700 resize-y" />

                <div class="flex items-center justify-between">
                  <p class="text-xs text-gray-500">* Please provide details before rejecting or resolving.</p>
                  <div class="flex gap-3">
                    <button @click="submitUpdate('REJECTED')" :disabled="submitting || !form.adminReply.trim()"
                      class="px-5 py-2.5 bg-white border border-red-200 text-red-600 rounded-xl hover:bg-red-50 transition font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                      Reject
                    </button>
                    <button @click="submitUpdate('RESOLVED')" :disabled="submitting || !form.adminReply.trim()"
                      class="px-5 py-2.5 bg-green-600 text-white rounded-xl hover:bg-green-700 transition font-medium shadow-sm disabled:opacity-50 disabled:cursor-not-allowed">
                      Mark as Resolved
                    </button>
                    <button @click="submitUpdate()" :disabled="submitting"
                      class="px-5 py-2.5 bg-blue-600 text-white rounded-xl hover:bg-blue-700 transition font-medium shadow-sm disabled:opacity-50">
                      {{ submitting ? 'Saving...' : 'Save' }}
                    </button>
                  </div>
                </div>

                <p v-if="updateSuccess" class="text-center text-green-600 text-sm">✅ Updated successfully</p>
                <p v-if="updateError" class="text-center text-red-500 text-sm">{{ updateError }}</p>
              </div>
            </div>
          </div>

          <!-- Right: Media -->
          <div class="space-y-6">
            <div class="bg-white rounded-2xl shadow-sm border p-6">
              <h2 class="text-lg font-semibold text-gray-800 mb-4 border-b pb-2">Attached Media</h2>
              <div v-if="incident.media?.length" class="space-y-4">
                <div v-for="(file, i) in incident.media" :key="i" class="border rounded-xl p-3 bg-gray-50">
                  <p class="text-xs font-medium text-gray-600 mb-2 truncate">📎 {{ file.fileName ?? file.type }}</p>
                  <img v-if="file.type === 'IMAGE'" :src="file.url"
                    class="rounded-lg w-full max-h-48 object-contain bg-gray-200" />
                  <video v-else-if="file.type === 'VIDEO'" :src="file.url" controls
                    class="rounded-lg w-full max-h-48 bg-black" />
                  <audio v-else-if="file.type === 'AUDIO'" :src="file.url" controls class="w-full mt-2 h-10" />
                </div>
              </div>
              <div v-else class="text-center py-8 text-gray-400 text-sm border-2 border-dashed rounded-xl">
                No media attached
              </div>
            </div>
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

useHead({
  link: [{ rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css' }]
})

definePageMeta({ middleware: 'auth' })

const route = useRoute()
const { $api } = useNuxtApp()


const { data: incident, pending, error, refresh } = await useAsyncData(
  `admin-report-trip-${route.params.id}`,
  async () => {
    const res = await $api(`reports/admin/${route.params.id}`)
    return res.data ?? res
  }
)

const form = ref({
  status: incident.value?.status ?? 'RECEIVED',
  adminReply: incident.value?.adminReply ?? '',
})

const submitting = ref(false)
const updateSuccess = ref(false)
const updateError = ref('')

const submitUpdate = async (statusOverride) => {
  submitting.value = true
  updateSuccess.value = false
  updateError.value = ''

  try {
    await $api(`reports/admin/${route.params.id}`, {
      method: 'PATCH',
      body: {
        status: statusOverride ?? form.value.status,
        ...(form.value.adminReply.trim() ? { adminReply: form.value.adminReply } : {}),
      }
    })
    updateSuccess.value = true
    await refresh()
    form.value.status = incident.value?.status ?? form.value.status
  } catch (err) {
    updateError.value = err?.data?.message || err?.message || 'Update failed'
  } finally {
    submitting.value = false
  }
}

const formatDate = (date) => date ? new Date(date).toLocaleString('th-TH') : '-'

const statusLabel = (s) => ({
  RECEIVED: 'Received', IN_PROGRESS: 'In Progress', RESOLVED: 'Resolved', REJECTED: 'Rejected'
})[s] ?? s

const statusClass = (s) => ({
  RECEIVED:    'bg-orange-100 text-orange-700',
  IN_PROGRESS: 'bg-yellow-100 text-yellow-700',
  RESOLVED:    'bg-green-100 text-green-700',
  REJECTED:    'bg-red-100 text-red-700',
})[s] ?? 'bg-gray-100 text-gray-600'

// Sidebar
function defineGlobalScripts() {
  window.toggleSidebar = function () {
    const sidebar = document.getElementById('sidebar')
    const mainContent = document.getElementById('main-content')
    const toggleIcon = document.getElementById('toggle-icon')
    if (!sidebar || !mainContent || !toggleIcon) return
    sidebar.classList.toggle('collapsed')
    mainContent.style.marginLeft = sidebar.classList.contains('collapsed') ? '80px' : '280px'
    toggleIcon.classList.replace('fa-chevron-left', 'fa-chevron-right')
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
    icon.classList.replace('fa-chevron-down', 'fa-chevron-up')
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
  window.__adminResizeHandler__?.()
})

onUnmounted(() => cleanupGlobalScripts())
</script>

<style>
.sidebar { transition: width 0.3s ease; }
.sidebar.collapsed { width: 80px; }
.sidebar:not(.collapsed) { width: 280px; }
.sidebar.collapsed .sidebar-text { display: none; }
.sidebar.collapsed .sidebar-item { justify-content: center; }
.main-content { transition: margin-left 0.3s ease; }
@media (max-width: 1024px) {
  .sidebar { position: fixed; z-index: 1000; transform: translateX(-100%); }
  .sidebar.mobile-open { transform: translateX(0); }
  .main-content { margin-left: 0 !important; }
}
</style>