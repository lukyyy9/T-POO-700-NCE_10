<script setup>
import User from './components/User.vue';
import WorkingTime from './components/WorkingTime.vue';
</script>

<template>
  <User />
  <router-view />
  <WorkingTime/>
</template>

<style scoped>
/* Ajoutez ici les styles nécessaires */
</style>