<script setup>
const route = useRoute()
</script>

<template>
  <div>
    <h1>รายละเอียดรายงาน ID: {{ route.params.id }}</h1>
  </div>
</template>