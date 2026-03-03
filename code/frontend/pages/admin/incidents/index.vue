<template>
  <div class="h-screen flex flex-col bg-gray-50 overflow-hidden">
    <AdminHeader />
    <div class="flex flex-1 overflow-hidden">
      <AdminSidebar />
      <div id="main-content" class="main-content flex-1 p-6 lg:p-8 overflow-y-auto" style="margin-left: 280px;">

        <div class="mb-8">
          <h1 class="text-2xl font-semibold text-gray-800">Incident Management</h1>
          <p class="text-sm text-gray-500">Monitor and manage trip & system incidents</p>
        </div>

        <!-- Summary Stats -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
          <div class="bg-white p-4 rounded-xl border shadow-sm">
            <p class="text-xs text-gray-500 uppercase">Total Reports</p>
            <p class="text-2xl font-semibold text-gray-800">{{ totalCount }}</p>
          </div>
          <div class="bg-white p-4 rounded-xl border shadow-sm">
            <p class="text-xs text-gray-500 uppercase">In Progress</p>
            <p class="text-2xl font-semibold text-yellow-600">{{ inProgressCount }}</p>
          </div>
          <div class="bg-white p-4 rounded-xl border shadow-sm">
            <p class="text-xs text-gray-500 uppercase">Resolved</p>
            <p class="text-2xl font-semibold text-green-600">{{ resolvedCount }}</p>
          </div>
        </div>

        <!-- Controls -->
        <div class="bg-white p-4 rounded-2xl shadow-sm border mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <input v-model="searchQuery" type="text" placeholder="Search by title..."
            class="px-4 py-2 border rounded-xl text-sm w-full md:w-80 focus:ring-2 focus:ring-blue-500 outline-none" />
          <div class="flex gap-2 flex-wrap">
            <button v-for="f in filters" :key="f.value" @click="setFilter(f.value)"
              class="px-4 py-2 text-xs font-medium rounded-full border transition"
              :class="currentFilter === f.value ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-600 hover:bg-gray-100'">
              {{ f.label }}
            </button>
          </div>
        </div>

        <!-- Loading -->
        <div v-if="pending" class="text-center py-12 text-gray-400">กำลังโหลดข้อมูล...</div>

        <!-- Error -->
        <div v-else-if="error" class="text-center py-12 text-red-500">เกิดข้อผิดพลาด: {{ error.message }}</div>

        <!-- Table -->
        <div v-else class="bg-white rounded-2xl shadow-sm border overflow-hidden">
          <div class="overflow-x-auto">
            <table class="min-w-full text-sm">
              <thead class="bg-gray-100 text-xs uppercase text-gray-500">
                <tr>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('title')">
                    <div class="flex items-center gap-1">Title
                      <span v-if="sortKey !== 'title'" class="text-gray-300">⇅</span>
                      <span v-else-if="sortAsc" class="text-blue-600">▲</span>
                      <span v-else class="text-blue-600">▼</span>
                    </div>
                  </th>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('createdAt')">
                    <div class="flex items-center gap-1">Reported Time
                      <span v-if="sortKey !== 'createdAt'" class="text-gray-300">⇅</span>
                      <span v-else-if="sortAsc" class="text-blue-600">▲</span>
                      <span v-else class="text-blue-600">▼</span>
                    </div>
                  </th>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('type')">
                    <div class="flex items-center gap-1">Type
                      <span v-if="sortKey !== 'type'" class="text-gray-300">⇅</span>
                      <span v-else-if="sortAsc" class="text-blue-600">▲</span>
                      <span v-else class="text-blue-600">▼</span>
                    </div>
                  </th>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('category')">
                    <div class="flex items-center gap-1">Category
                      <span v-if="sortKey !== 'category'" class="text-gray-300">⇅</span>
                      <span v-else-if="sortAsc" class="text-blue-600">▲</span>
                      <span v-else class="text-blue-600">▼</span>
                    </div>
                  </th>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('status')">
                    <div class="flex items-center gap-1">Status
                      <span v-if="sortKey !== 'status'" class="text-gray-300">⇅</span>
                      <span v-else-if="sortAsc" class="text-blue-600">▲</span>
                      <span v-else class="text-blue-600">▼</span>
                    </div>
                  </th>
                </tr>
              </thead>

              <tbody v-if="paginatedIncidents.length">
                <tr v-for="item in paginatedIncidents" :key="item.id"
                  @click="goToDetail(item)"
                  class="border-t hover:bg-blue-50 transition cursor-pointer">
                  <td class="px-6 py-4">
                    <div class="font-medium text-blue-600">{{ item.title }}</div>
                    <div class="text-xs text-gray-400">{{ item.id }}</div>
                  </td>
                  <td class="px-6 py-4 text-gray-600">{{ formatDate(item.createdAt) }}</td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 text-xs font-medium rounded-full"
                      :class="item.type === 'TRIP' ? 'bg-blue-100 text-blue-700' : 'bg-purple-100 text-purple-700'">
                      {{ item.type ?? '-' }}
                    </span>
                  </td>
                  <td class="px-6 py-4 text-gray-600">{{ categoryLabel(item.category) }}</td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 text-xs font-semibold rounded-full" :class="statusClass(item.status)">
                      {{ statusLabel(item.status) }}
                    </span>
                  </td>
                </tr>
              </tbody>

              <tbody v-else>
                <tr>
                  <td colspan="5" class="text-center py-12 text-gray-400">No incidents found</td>
                </tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="flex justify-between items-center px-6 py-4 border-t text-sm">
            <div class="text-gray-500">Page {{ currentPage }} of {{ totalPages }}</div>
            <div class="flex gap-2">
              <button @click="prevPage" :disabled="currentPage === 1"
                class="px-4 py-2 border rounded-lg disabled:opacity-40 hover:bg-gray-100">Previous</button>
              <button @click="nextPage" :disabled="currentPage === totalPages"
                class="px-4 py-2 border rounded-lg disabled:opacity-40 hover:bg-gray-100">Next</button>
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
import { ref, computed, onMounted, onUnmounted } from 'vue'

useHead({
  link: [{ rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css' }]
})

definePageMeta({ middleware: 'auth' })

const { $api } = useNuxtApp()


const { data: reportData, pending, error } = await useAsyncData('admin-reports', async () => {
  const res = await $api('reports/admin', {
    params: { limit: 100 }
  })

  return Array.isArray(res) ? res : []
})

const incidents = computed(() => reportData.value ?? [])


const filters = [
  { label: 'ALL',         value: 'ALL' },
  { label: 'Received',    value: 'RECEIVED' },
  { label: 'In Progress', value: 'IN_PROGRESS' },
  { label: 'Resolved',    value: 'RESOLVED' },
  { label: 'Rejected',    value: 'REJECTED' },
]

const currentFilter = ref('ALL')
const searchQuery = ref('')
const sortKey = ref(null)
const sortAsc = ref(true)
const currentPage = ref(1)
const itemsPerPage = 15

const setFilter = (status) => { currentFilter.value = status; currentPage.value = 1 }

const sortBy = (key) => {
  if (sortKey.value === key) sortAsc.value = !sortAsc.value
  else { sortKey.value = key; sortAsc.value = true }
}

const filteredIncidents = computed(() => {
  let data = incidents.value
  if (currentFilter.value !== 'ALL') data = data.filter(i => i.status === currentFilter.value)
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    data = data.filter(i => i.title?.toLowerCase().includes(q) || i.id?.toLowerCase().includes(q))
  }
  if (sortKey.value) {
    data = [...data].sort((a, b) => {
      const A = a[sortKey.value], B = b[sortKey.value]
      if (A < B) return sortAsc.value ? -1 : 1
      if (A > B) return sortAsc.value ? 1 : -1
      return 0
    })
  }
  return data
})

const totalPages = computed(() => Math.max(1, Math.ceil(filteredIncidents.value.length / itemsPerPage)))
const paginatedIncidents = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  return filteredIncidents.value.slice(start, start + itemsPerPage)
})

const nextPage = () => { if (currentPage.value < totalPages.value) currentPage.value++ }
const prevPage = () => { if (currentPage.value > 1) currentPage.value-- }

const totalCount = computed(() => incidents.value.length)
const inProgressCount = computed(() => incidents.value.filter(i => i.status === 'IN_PROGRESS').length)
const resolvedCount = computed(() => incidents.value.filter(i => i.status === 'RESOLVED').length)

const statusLabel = (status) => ({
  'RECEIVED':    'Received',
  'IN_PROGRESS': 'In Progress',
  'RESOLVED':    'Resolved',
  'REJECTED':    'Rejected',
})[status] ?? status

const categoryLabel = (cat) => ({
  'TRIP':    'Trip',
  'SERVICE': 'Service',
  'OTHER':   'Other',
})[cat] ?? cat ?? '-'

const statusClass = (status) => ({
  'RECEIVED':    'bg-orange-100 text-orange-700',
  'IN_PROGRESS': 'bg-yellow-100 text-yellow-700',
  'RESOLVED':    'bg-green-100 text-green-700',
  'REJECTED':    'bg-red-100 text-red-700',
})[status] ?? 'bg-gray-100 text-gray-600'

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('th-TH')
}

// Sidebar logic
function defineGlobalScripts() {
  window.toggleSidebar = function () {
    const sidebar = document.getElementById('sidebar')
    const mainContent = document.getElementById('main-content')
    const toggleIcon = document.getElementById('toggle-icon')
    if (!sidebar || !mainContent || !toggleIcon) return
    sidebar.classList.toggle('collapsed')
    if (sidebar.classList.contains('collapsed')) {
      mainContent.style.marginLeft = '80px'
      toggleIcon.classList.replace('fa-chevron-left', 'fa-chevron-right')
    } else {
      mainContent.style.marginLeft = '280px'
      toggleIcon.classList.replace('fa-chevron-right', 'fa-chevron-left')
    }
  }
  window.toggleMobileSidebar = function () {
    const sidebar = document.getElementById('sidebar')
    const overlay = document.getElementById('overlay')
    if (!sidebar || !overlay) return
    sidebar.classList.toggle('mobile-open')
    overlay.classList.toggle('hidden')
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

const goToDetail = (item) => {
  const path = item.category === 'TRIP'
    ? `/admin/incidents/trip/${item.id}`
    : `/admin/incidents/system/${item.id}`
  navigateTo(path)
}

onMounted(() => {
  defineGlobalScripts()
  if (typeof window.__adminResizeHandler__ === 'function') window.__adminResizeHandler__()
})

onUnmounted(() => { cleanupGlobalScripts() })
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