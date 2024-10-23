<script setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import User from './components/User.vue';
import UserMenu from './components/UserMenu.vue';
import TopRightMenu from './components/TopRightMenu.vue';
import axiosInstance from '../axios.js';
import { getUserId } from '@/utils/user';
import moment from 'moment';
import { Toaster, toast } from "@steveyuowo/vue-hot-toast";
import "@steveyuowo/vue-hot-toast/vue-hot-toast.css";

const isMenuOpen = ref(false);
const workingHours = ref('Calculating...');
const userId = ref(null);
const username = ref(null);
const route = useRoute();
const router = useRouter();
const isHomePage = computed(() => route.path === '/');
const isLoginPage = computed(() => route.path === '/login');

function toggleUserMenu() {
  isMenuOpen.value = !isMenuOpen.value;
}

function closeUserMenu() {
  isMenuOpen.value = false;
}

function goHome() {
  router.push('/');
}

async function getUsername() {
  try {
    const savedToken = localStorage.getItem('token');
    if (savedToken) {
      userId.value = getUserId(savedToken);
    } else {
      console.log('to token found');
    }

    const response = await axiosInstance.get(`users/${userId.value}`);
    username.value = response.data.data.username;
  } catch (error) {
    console.error('not token :', error);
  }
}

async function calculateHours() {
  try {
    //get CloksDay[]
    const response = await axiosInstance.get(`clocks/${userId.value}`);
    const clocksData = response.data.data;
    const clocksDay = [];
    const currentDay = moment().format('DD MMMM YY');

    clocksData.forEach(ele => {
      const dayClock = moment(ele.time).format('DD MMMM YY');
      if (currentDay === dayClock) {
        clocksDay.push(ele);
      };
    });

    if (clocksDay.length > 0) {
      let duration = 0;
      for (let i = 0; i < clocksDay.length - 1; i += 2) {
        if (clocksDay[i + 1]) {
          duration += moment(clocksDay[i + 1].time).diff(moment(clocksDay[i].time));
        }
      };
      const hours = Math.floor(duration / 3600000);
      let hoursString = String(hours).padStart(2, '0');
      const minutes = String(Math.floor((duration % 3600000) / 60000)).padStart(2, '0');
      const seconds = String(Math.floor((duration % 60000) / 1000)).padStart(2, '0');
      if (hours >= 8) {
        workingHours.value = `${hoursString} : ${minutes} : ${seconds} - time to go home !`;
      } else {
        workingHours.value = `${hoursString} : ${minutes} : ${seconds} - keep it up`;
      }
    } else {
      workingHours.value = 'Go back to work !';
    };
  } catch (error) {
    console.error('not clocks:', error);
  }

}


onMounted(() => {
  getUsername();
  calculateHours();
})


</script>

<template>
<Toaster />
<div id="app" class="from-primary to-[#EFD67F] bg-gradient-to-r w-full p-3 flex flex-col">
  <div class="flex justify-between mx-3">
    <img @click="goHome" src="/logoFull.png" alt="Logo" class="h-9 hidden lg:block hover:cursor-pointer">
    <img @click="goHome" src="/logo.png" alt="Logo" class="h-9 block lg:hidden hover:cursor-pointer">
    <div v-if=!isLoginPage class="flex gap-x-1 h-9 items-center">
      <button v-if=!isHomePage @click="clock"
        class="absolute bottom-5 right-4 z-10 mr-1 bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300 lg:static">Clock
        in 📝</button>
      <p class="text-black">{{workingHours}}</p>
    </div>
    <div class="lg:w-[150px] flex justify-end">
      <User @toggle-user-menu="toggleUserMenu" />
    </div>
  </div>
  <div class="bg-mainFrame w-full h-[100vh] rounded-xl mt-3 p-3 relative overflow-y-scroll">
    <div class="flex justify-between">
      <h1 v-if=!isLoginPage class="ml-3">Hello {{username}} 👋</h1>
      <TopRightMenu />
    </div>
    <router-view />
  </div>
  <UserMenu v-if="isMenuOpen" :isMenuOpen="isMenuOpen" @close-menu="closeUserMenu" class="absolute top-12 right-3" />
</div>
</template>

<style scoped>
</style>