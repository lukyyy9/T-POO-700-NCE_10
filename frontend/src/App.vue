<script setup>
  import { ref } from 'vue';
  import User from './components/User.vue';
  import UserMenu from './components/UserMenu.vue';
  
  const showUserMenu = ref(false);
  
  function toggleUserMenu() {
      showUserMenu.value = !showUserMenu.value;
  }
  </script>

<template>
  <div id="app" class="bg-primary w-full p-3 flex flex-col">
    <div class="flex justify-between mx-3">
      <img src="/logoFull.png" alt="Logo" class="h-9">
      <User @toggle-user-menu="toggleUserMenu" />
    </div>
    <div class="bg-mainFrame w-full h-[100vh] rounded-xl mt-3 p-3 relative">
      <router-view />
    </div>
    <UserMenu v-if="showUserMenu" class="absolute top-12 right-3"/>
  </div>
</template>

<style scoped>
/* Ajoutez ici les styles nécessaires */
</style>