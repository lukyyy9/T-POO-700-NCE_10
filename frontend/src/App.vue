<script setup>
import { ref } from 'vue';
import User from './components/User.vue';
import UserMenu from './components/UserMenu.vue';
import TopRightMenu from './components/TopRightMenu.vue';

const isMenuOpen = ref(false);

function toggleUserMenu() {
    isMenuOpen.value = !isMenuOpen.value;
}

function closeUserMenu() {
    isMenuOpen.value = false;
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
        <TopRightMenu />
      </div>
      <router-view />
    </div>
    <UserMenu v-if="isMenuOpen" :isMenuOpen="isMenuOpen" @close-menu="closeUserMenu" class="absolute top-12 right-3"/>
  </div>
</template>

<style scoped>
</style>