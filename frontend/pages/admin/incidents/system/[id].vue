<template>
  <div class="p-6">
    <h1 class="text-xl font-semibold">System Report Detail</h1>
    <p class="text-gray-500 mt-2">
      Report ID: {{ route.params.id }}
    </p>
  </div>
</template>

<script setup>
const route = useRoute()
</script>