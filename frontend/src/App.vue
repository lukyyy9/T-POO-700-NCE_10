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
  <div id="app" class="from-primary to-[#EFD67F] bg-gradient-to-r w-full p-3 flex flex-col">
    <div class="flex justify-between mx-3">
      <img src="/logoFull.png" alt="Logo" class="h-9">
      <User @toggle-user-menu="toggleUserMenu" />
    </div>
    <div class="bg-mainFrame w-full h-[100vh] rounded-xl mt-3 p-3 relative overflow-y-scroll">
      <div class="flex justify-between">
        <h1 class="ml-3">Hello Maietry 👋</h1>
        <button class="rounded-lg border-2 border-secondary bg-transparent mt-2">Go to graphs</button>
      </div>
      <router-view />
    </div>
    <UserMenu v-if="showUserMenu" class="absolute top-12 right-3"/>
  </div>
</template>

<style scoped>
/* Ajoutez ici les styles nécessaires */
</style>