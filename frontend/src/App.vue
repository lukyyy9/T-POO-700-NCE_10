<script setup>
import { ref, computed } from 'vue';
import { useRoute } from 'vue-router';
import User from './components/User.vue';
import UserMenu from './components/UserMenu.vue';
import TopRightMenu from './components/TopRightMenu.vue';

const isMenuOpen = ref(false);
const route = useRoute();
const isHomePage = computed(() => route.path === '/');
const isLoginPage = computed(() => route.path === '/login');

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
      <div v-if=!isLoginPage class="flex gap-x-1 h-9 items-center">
        <button v-if=!isHomePage @click="clock" class="mr-1 bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300">Clock in 📝</button>
        <p class="text-black">00:24:35</p>
        <p class="text-black">-</p>
        <p class="text-black">keep it up !</p>
      </div>
      <div class="w-[150px] flex justify-end">
        <User @toggle-user-menu="toggleUserMenu" />
      </div>
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