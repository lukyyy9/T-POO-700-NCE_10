<script setup>
import { ref, computed, watch, onMounted, watchEffect } from 'vue';
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
const intervalId = ref(null);
const elapsed = ref('Calculating...');
const clocksDay = ref([]);
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

function startTimer() {
  intervalId.value = setInterval(() => {
    elapsed.value += 1;
            }, 1000);
}

function stopTimer() {
  clearInterval(intervalId.value);
  intervalId.value = null;
  }

function formatDuration(seconds) {
  const hours = Math.floor(seconds / 3600).toString().padStart(2, '0');
  const minutes = Math.floor((seconds % 3600) / 60).toString().padStart(2, '0');
  const secs = Math.floor(seconds % 60).toString().padStart(2, '0');
  if (hours >= 8) {
    return `${hours}:${minutes}:${secs} - Time to go home!`;
  } else if(hours === 0) {
    return `${hours}:${minutes}:${secs} - Go back to work!`;
  } else {
    return `${hours}:${minutes}:${secs} - Keep it up!`;
  }
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
    const response = await axiosInstance.get(`clocks/${userId.value}`);
    const clocksData = response.data.data;

    if(clocksData){
    //let clocksDay = [];
    clocksDay.value = clocksData.filter(clock => moment(clock.time).isSame(moment(), 'day'));

    let inSession = false;
    let sessionStart = null;
    let totalDuration = 0; 
    for (let i = 0; i < clocksDay.value.length; i++) {
      const clock = clocksDay.value[i];
      if (!clock.status) {
        sessionStart = moment(clock.time);
        inSession = true;
      } else if (inSession && sessionStart){
        totalDuration += moment(clock.time).diff(sessionStart);
        inSession = false;
        sessionStart = null;
      }
    }
    if (inSession && sessionStart) {
      totalDuration += moment().diff(sessionStart);
      startTimer();
    } else {
      stopTimer();
    }
    elapsed.value = Math.floor(totalDuration / 1000);

    } else {
      console.log('No clocks for today');
    }

  } catch (error) {
    console.error('not clocks:', error);
  }
}

onMounted(() => {
  getUsername();
  calculateHours();
});

watch(route, () => {
  getUsername();
  calculateHours();
});
// watchEffect(() => {
//   const timer = setInterval(() => {
//       calculateHours();
//     }, 1000);
//   return () => clearInterval(timer);
// })
</script>

<template>
<Toaster />
<div id="app" class="from-primary to-[#EFD67F] bg-gradient-to-r w-full sm:p-3 flex flex-col">
  <div class="justify-between mx-3 hidden sm:flex">
    <img @click="goHome" src="/logoFull.png" alt="Logo" class="h-9 hidden lg:block hover:cursor-pointer">
    <img @click="goHome" src="/logo.png" alt="Logo" class="h-9 block lg:hidden hover:cursor-pointer">
    <div v-if=!isLoginPage class="flex gap-x-1 h-9 items-center">
      <button v-if=!isHomePage @click="clock"
        class="mr-1 bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300">Clock
        in 📝</button>
      <p class="text-black">{{formatDuration(elapsed)}}</p>
    </div>
    <div class="lg:w-[150px] flex justify-end">
      <User @toggle-user-menu="toggleUserMenu" />
    </div>
  </div>
  <div class="bg-mainFrame w-full h-[100vh] sm:rounded-xl sm:mt-3 p-3 relative overflow-y-scroll">
    <div class="justify-between hidden sm:flex">
      <h1 v-if=!isLoginPage class="ml-3">Hello {{username}} 👋</h1>
      <TopRightMenu />
    </div>
    <router-view />
  </div>
  <div v-if=!isLoginPage class="bottom-0 w-full bg-primary z-10 h-14 flex items-center place-content-evenly sm:hidden">
    <button @click="goHome" class="block sm:hidden" :style="{ color: isHomePage ? '#111' : '#817447'  }">
      <font-awesome-icon :icon="['fas', 'house']" size="xl" />
    </button>
    <TopRightMenu />
    <div class="w-[68px] flex justify-center">
      <User @toggle-user-menu="toggleUserMenu" />
    </div>
  </div>
  <UserMenu v-if="isMenuOpen" :isMenuOpen="isMenuOpen" @close-menu="closeUserMenu" class="absolute sm:top-12 sm:right-3 right-2 bottom-16" />
</div>
</template>

<style scoped></style>