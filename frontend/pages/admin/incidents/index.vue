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
            <p class="text-2xl font-semibold text-gray-800">{{ pagination.total ?? 0 }}</p>
          </div>
          <div class="bg-white p-4 rounded-xl border shadow-sm">
            <p class="text-xs text-gray-500 uppercase">Pending</p>
            <p class="text-2xl font-semibold text-yellow-600">{{ receivedCount }}</p>
          </div>
          <div class="bg-white p-4 rounded-xl border shadow-sm">
            <p class="text-xs text-gray-500 uppercase">Resolved</p>
            <p class="text-2xl font-semibold text-green-600">{{ resolvedCount }}</p>
          </div>
        </div>

        <!-- Controls -->
        <div class="bg-white p-4 rounded-2xl shadow-sm border mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search by title, ID, user..."
            class="px-4 py-2 border rounded-xl text-sm w-full md:w-80 focus:ring-2 focus:ring-blue-500 outline-none"
            @input="onSearch"
          />
          <div class="flex gap-2 flex-wrap">
            <button
              v-for="f in filters" :key="f.value"
              @click="setFilter(f.value)"
              class="px-4 py-2 text-xs font-medium rounded-full border transition"
              :class="currentFilter === f.value
                ? 'bg-blue-600 text-white border-blue-600'
                : 'bg-white text-gray-600 hover:bg-gray-100'"
            >{{ f.label }}</button>
          </div>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-2xl shadow-sm border overflow-hidden">
          <div class="overflow-x-auto">
            <table class="min-w-full text-sm">
              <thead class="bg-gray-100 text-xs uppercase text-gray-500">
                <tr>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('title')">
                    <div class="flex items-center gap-1">Title
                      <span :class="sortKey === 'title' ? 'text-blue-600' : 'text-gray-300'">
                        {{ sortKey === 'title' ? (sortOrder === 'asc' ? '▲' : '▼') : '⇅' }}
                      </span>
                    </div>
                  </th>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('createdAt')">
                    <div class="flex items-center gap-1">Reported Time
                      <span :class="sortKey === 'createdAt' ? 'text-blue-600' : 'text-gray-300'">
                        {{ sortKey === 'createdAt' ? (sortOrder === 'asc' ? '▲' : '▼') : '⇅' }}
                      </span>
                    </div>
                  </th>
                  <th class="px-6 py-4 text-left">User</th>
                  <th class="px-6 py-4 text-left">Type</th>
                  <th class="px-6 py-4 text-left">Category</th>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('status')">
                    <div class="flex items-center gap-1">Status
                      <span :class="sortKey === 'status' ? 'text-blue-600' : 'text-gray-300'">
                        {{ sortKey === 'status' ? (sortOrder === 'asc' ? '▲' : '▼') : '⇅' }}
                      </span>
                    </div>
                  </th>
                </tr>
              </thead>

              <tbody v-if="pending">
                <tr><td colspan="6" class="text-center py-12 text-gray-400">Loading...</td></tr>
              </tbody>

              <tbody v-else-if="reports.length">
                <tr
                  v-for="item in reports" :key="item.id"
                  @click="goToDetail(item)"
                  class="border-t hover:bg-blue-50 transition cursor-pointer"
                >
                  <td class="px-6 py-4">
                    <div class="font-medium text-blue-600">{{ item.title }}</div>
                    <div class="text-xs text-gray-400 font-mono">{{ item.id }}</div>
                  </td>
                  <td class="px-6 py-4 text-gray-600">{{ formatDate(item.receivedAt) }}</td>
                  <td class="px-6 py-4 text-gray-700">
                    {{ item.reporter?.firstName }} {{ item.reporter?.lastName }}
                  </td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 text-xs font-medium rounded-full"
                      :class="item.category === 'TRIP'
                        ? 'bg-blue-100 text-blue-700'
                        : 'bg-purple-100 text-purple-700'">
                      {{ item.category }}
                    </span>
                  </td>
                  <td class="px-6 py-4 text-gray-600">{{ typeLabel(item.type) }}</td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 text-xs font-semibold rounded-full" :class="statusClass(item.status)">
                      {{ item.status }}
                    </span>
                  </td>
                </tr>
              </tbody>

              <tbody v-else>
                <tr><td colspan="6" class="text-center py-12 text-gray-400">No incidents found</td></tr>
              </tbody>
            </table>
          </div>

          <!-- Pagination -->
          <div class="flex justify-between items-center px-6 py-4 border-t text-sm">
            <div class="text-gray-500">
              Page {{ pagination.page }} of {{ pagination.totalPages }}
            </div>
            <div class="flex gap-2">
              <button @click="prevPage" :disabled="pagination.page <= 1"
                class="px-4 py-2 border rounded-lg disabled:opacity-40 hover:bg-gray-100">Previous</button>
              <button @click="nextPage" :disabled="pagination.page >= pagination.totalPages"
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
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'

useHead({
  link: [{ rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css' }]
})


const searchQuery  = ref('')
const currentFilter = ref('')   // '' = ALL
const sortKey      = ref('createdAt')
const sortOrder    = ref('desc')
const currentPage  = ref(1)
const itemsPerPage = 15

const filters = [
  { label: 'ALL',         value: ''            },
  { label: 'RECEIVED',    value: 'RECEIVED'    },
  { label: 'IN_PROGRESS', value: 'IN_PROGRESS' },
  { label: 'RESOLVED',    value: 'RESOLVED'    },
  { label: 'REJECTED',    value: 'REJECTED'    },
]


const queryParams = computed(() => {
  const p = {
    page:      currentPage.value,
    limit:     itemsPerPage,
    sortOrder: sortOrder.value,
  }
  if (currentFilter.value) p.status = currentFilter.value
  if (searchQuery.value.trim()) p.q = searchQuery.value.trim()
  return p
})


const { data, pending, refresh } = await useFetch('/api/reports/admin', {
  credentials: 'include',
  query: queryParams,   
})

const reports    = computed(() => data.value?.data       ?? [])
const pagination = computed(() => data.value?.pagination ?? { page: 1, totalPages: 1, total: 0 })

const { data: summaryData } = await useFetch('/api/reports/admin', {
  credentials: 'include',
  query: { limit: 1, status: 'RECEIVED' }
})

const { data: resolvedData } = await useFetch('/api/reports/admin', {
  credentials: 'include',
  query: { limit: 1, status: 'RESOLVED' }
})

const receivedCount = computed(() => summaryData.value?.pagination?.total ?? 0)
const resolvedCount = computed(() => resolvedData.value?.pagination?.total ?? 0)

const setFilter = (status) => {
  currentFilter.value = status
  currentPage.value   = 1
}

let searchTimer = null
const onSearch = () => {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => { currentPage.value = 1 }, 400)
}

const sortBy = (key) => {
  if (sortKey.value === key) {
    sortOrder.value = sortOrder.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortKey.value   = key
    sortOrder.value = 'desc'
  }
  currentPage.value = 1
}

const nextPage = () => { if (currentPage.value < pagination.value.totalPages) currentPage.value++ }
const prevPage = () => { if (currentPage.value > 1) currentPage.value-- }


const goToDetail = (item) => {
  navigateTo(`/admin/incidents/${item.id}`)
}


const formatDate = (d) => d
  ? new Date(d).toLocaleString('th-TH', { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' })
  : '-'

const typeLabel = (t) => ({
  ACCIDENT:           'Accident',
  PASSENGER_BEHAVIOR: 'Passenger Behavior',
  APP_CRASH:          'App Crash',
  MAP_ERROR:          'Map Error',
  PERFORMANCE:        'Performance Issue',
  OTHER:              'Other',
}[t] ?? t ?? '-')

const statusClass = (s) => ({
  RECEIVED:    'bg-yellow-100 text-yellow-700',
  IN_PROGRESS: 'bg-blue-100   text-blue-700',
  RESOLVED:    'bg-green-100  text-green-700',
  REJECTED:    'bg-red-100    text-red-700',
}[s] ?? 'bg-gray-100 text-gray-600')


function defineGlobalScripts() {
  window.toggleSidebar = function () {
    const sidebar = document.getElementById('sidebar')
    const mainContent = document.getElementById('main-content')
    const toggleIcon = document.getElementById('toggle-icon')
    if (!sidebar || !mainContent || !toggleIcon) return
    sidebar.classList.toggle('collapsed')
    mainContent.style.marginLeft = sidebar.classList.contains('collapsed') ? '80px' : '280px'
    toggleIcon.classList.toggle('fa-chevron-left')
    toggleIcon.classList.toggle('fa-chevron-right')
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