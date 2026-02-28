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
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
          <div class="bg-white p-4 rounded-xl border shadow-sm">
            <p class="text-xs text-gray-500 uppercase">Total Reports</p>
            <p class="text-2xl font-semibold text-gray-800">{{ totalCount }}</p>
          </div>
      
          <div class="bg-white p-4 rounded-xl border shadow-sm">
            <p class="text-xs text-gray-500 uppercase">Pending</p>
            <p class="text-2xl font-semibold text-yellow-600">{{ inProgressCount }}</p>
          </div>
          <div class="bg-white p-4 rounded-xl border shadow-sm">
            <p class="text-xs text-gray-500 uppercase">RESOLVED</p>
            <p class="text-2xl font-semibold text-green-600">{{ resolvedCount }}</p>
          </div>
        </div>

        <!-- Controls -->
        <div class="bg-white p-4 rounded-2xl shadow-sm border mb-6 flex flex-col md:flex-row md:items-center md:justify-between gap-4">
          <input v-model="searchQuery" type="text" placeholder="Search by title, ID, user..."
            class="px-4 py-2 border rounded-xl text-sm w-full md:w-80 focus:ring-2 focus:ring-blue-500 outline-none" />
          <div class="flex gap-2 flex-wrap">
            <button v-for="status in filters" :key="status" @click="setFilter(status)"
              class="px-4 py-2 text-xs font-medium rounded-full border transition"
              :class="currentFilter === status ? 'bg-blue-600 text-white border-blue-600' : 'bg-white text-gray-600 hover:bg-gray-100'">
              {{ status }}
            </button>
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
                      <span v-if="sortKey !== 'title'" class="text-gray-300">⇅</span>
                      <span v-else-if="sortAsc" class="text-blue-600">▲</span>
                      <span v-else class="text-blue-600">▼</span>
                    </div>
                  </th>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('reportTime')">
                    <div class="flex items-center gap-1">Reported Time
                      <span v-if="sortKey !== 'reportTime'" class="text-gray-300">⇅</span>
                      <span v-else-if="sortAsc" class="text-blue-600">▲</span>
                      <span v-else class="text-blue-600">▼</span>
                    </div>
                  </th>
                  <th class="px-6 py-4 text-left cursor-pointer select-none" @click="sortBy('user')">
                    <div class="flex items-center gap-1">User
                      <span v-if="sortKey !== 'user'" class="text-gray-300">⇅</span>
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
                <tr v-for="item in paginatedIncidents" :key="item.id" @click="goToDetail(item)"
                  class="border-t hover:bg-blue-50 transition cursor-pointer">
                  <td class="px-6 py-4">
                    <div class="font-medium text-blue-600">{{ item.title }}</div>
                    <div class="text-xs text-gray-400">{{ item.id }}</div>
                  </td>
                  <td class="px-6 py-4 text-gray-600">{{ item.reportTime }}</td>
                  <td class="px-6 py-4 text-gray-700">{{ item.user }}</td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 text-xs font-medium rounded-full"
                      :class="item.type === 'TRIP' ? 'bg-blue-100 text-blue-700' : 'bg-purple-100 text-purple-700'">
                      {{ item.type }}
                    </span>
                  </td>
                  <td class="px-6 py-4 text-gray-600">{{ item.category }}</td>
                  <td class="px-6 py-4">
                    <span class="px-3 py-1 text-xs font-semibold rounded-full" :class="statusClass(item.status)">
                      {{ item.status }}
                    </span>
                  </td>
                </tr>
              </tbody>

              <tbody v-else>
                <tr>
                  <td colspan="6" class="text-center py-12 text-gray-400">No incidents found</td>
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
  link: [
    { rel: 'stylesheet', href: 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css' }
  ]
})

const goToDetail = async (item) => {
  if (item.type === 'TRIP') {
    await navigateTo(`/admin/incidents/trip/${item.id}`)
  } else {
    await navigateTo(`/admin/incidents/system/${item.id}`)
  }
}


const incidents = ref([
  { id: 'RPT-001', title: 'Passenger was aggressive', reportTime: '2026-02-26 10:30', user: 'driver1@email.com', type: 'TRIP', category: 'Passenger Behavior', status: 'PENDING' },

  { id: 'RPT-002', title: 'App crashed', reportTime: '2026-02-25 14:10', user: 'driver@email.com', type: 'SYSTEM', category: 'App Crash', status: 'REJECTED' },

  { id: 'RPT-003', title: 'Minor collision during trip', reportTime: '2026-02-24 09:00', user: 'driver2@email.com', type: 'TRIP', category: 'Accident', status: 'RESOLVED' },

  { id: 'RPT-004', title: 'Passenger damaged vehicle interior', reportTime: '2026-02-23 11:45', user: 'driver3@email.com', type: 'TRIP', category: 'Passenger Behavior', status: 'PENDING' },

  { id: 'RPT-005', title: 'Unexpected issue during trip', reportTime: '2026-02-22 16:30', user: 'driver4@email.com', type: 'TRIP', category: 'Other', status: 'PENDING' },

  { id: 'RPT-006', title: 'App freezing', reportTime: '2026-02-21 13:15', user: 'driver@email.com', type: 'SYSTEM', category: 'Performance Issue', status: 'REJECTED' },

  { id: 'RPT-007', title: 'Passenger refused to pay cash fee', reportTime: '2026-02-20 11:00', user: 'driver5@email.com', type: 'TRIP', category: 'Passenger Behavior', status: 'PENDING' },

  { id: 'RPT-008', title: 'App not loading', reportTime: '2026-02-19 15:45', user: 'driver@email.com', type: 'SYSTEM', category: 'App Loading Issue', status: 'REJECTED' },

  { id: 'RPT-009', title: 'Vehicle involved in minor accident', reportTime: '2026-02-18 14:30', user: 'driver6@email.com', type: 'TRIP', category: 'Accident', status: 'RESOLVED' },

  { id: 'RPT-010', title: 'Unusual trip issue reported', reportTime: '2026-02-17 10:20', user: 'driver7@email.com', type: 'TRIP', category: 'Other', status: 'PENDING' },

  { id: 'RPT-011', title: 'Passenger was verbally abusive', reportTime: '2026-02-26 10:30', user: 'driver1@email.com', type: 'TRIP', category: 'Passenger Behavior', status: 'PENDING' },

  { id: 'RPT-012', title: 'App crashed', reportTime: '2026-02-25 14:10', user: 'driver@email.com', type: 'SYSTEM', category: 'App Crash', status: 'REJECTED' },

  { id: 'RPT-013', title: 'Small road accident occurred', reportTime: '2026-02-24 09:00', user: 'driver2@email.com', type: 'TRIP', category: 'Accident', status: 'RESOLVED' },

  { id: 'RPT-014', title: 'Passenger refused to follow safety rules', reportTime: '2026-02-26 10:30', user: 'driver1@email.com', type: 'TRIP', category: 'Passenger Behavior', status: 'PENDING' },

  { id: 'RPT-015', title: 'App crashed', reportTime: '2026-02-25 14:10', user: 'driver@email.com', type: 'SYSTEM', category: 'App Crash', status: 'REJECTED' },

  { id: 'RPT-016', title: 'Other issue during trip', reportTime: '2026-02-24 09:00', user: 'driver2@email.com', type: 'TRIP', category: 'Other', status: 'RESOLVED' }
])

const filters = ['ALL', 'PENDING', 'REJECTED', 'RESOLVED']
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
    data = data.filter(i => i.title.toLowerCase().includes(q) || i.id.toLowerCase().includes(q) || i.user.toLowerCase().includes(q))
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

const totalPages = computed(() => Math.ceil(filteredIncidents.value.length / itemsPerPage))
const paginatedIncidents = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  return filteredIncidents.value.slice(start, start + itemsPerPage)
})

const nextPage = () => { if (currentPage.value < totalPages.value) currentPage.value++ }
const prevPage = () => { if (currentPage.value > 1) currentPage.value-- }

const statusClass = (status) => {
  switch (status) {
    case 'PENDING': return 'bg-yellow-100 text-yellow-700'
    case 'REJECTED': return 'bg-red-100 text-red-700'
    case 'RESOLVED': return 'bg-green-100 text-green-700'
    default: return 'bg-gray-100 text-gray-600'
  }
}

const totalCount = computed(() => incidents.value.length)
const openCount = computed(() => incidents.value.filter(i => i.status === 'PENDING').length)
const inProgressCount = computed(() => incidents.value.filter(i => i.status === 'IN_PROGRESS' || i.status === 'REJECTED').length)
const resolvedCount = computed(() => incidents.value.filter(i => i.status === 'RESOLVED').length)

// ✅ sidebar toggle logic เหมือนหน้าอื่น
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
})

onUnmounted(() => {
  cleanupGlobalScripts()
})
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