<script setup>
import User from './components/User.vue';


</script>

<template>
  <div id="app" class="bg-primary w-full p-3 flex flex-col">
    <div class="flex justify-between mx-3">
      <img src="/logoFull.png" alt="Logo" class="h-9">
      <User />
    </div>
    <div class="bg-mainFrame w-full h-[100vh] rounded-xl mt-3 p-3 relative">
      <router-view />
    </div>
    </div>
</template>

<style scoped>
/* Ajoutez ici les styles nécessaires */
</style>