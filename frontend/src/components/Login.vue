<template>
    <div id="Login" class="h-full align-middle flex items-center justify-center">
        <img src="/gotham.jpg" alt="Gotham picture" class="hidden lg:block absolute top-0 left-0 h-full w-[66%] object-cover rounded-l-xl">
        <div class="flex flex-col items-center justify-center h-max lg:mt-0 lg:w-[34%] lg:h-[100%] lg:right-0 lg:top-0 lg:absolute">
            <h1>
                Welcome back 👋
            </h1>
            <div class="flex flex-col justify-start">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" v-model="username">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" v-model="password" @keyup.enter="signin">
            </div>
            <button @click="signin" class="bg-primary text-black border-2 border-primaryAccent hover:shadow-[0px_0px_9px_2px_#FFEFB7] transition-shadow duration-300 mt-4">
                Sign in 🦇
            </button>
        </div>
    </div>
</template>

<script>
import axiosInstance from '../../axios.js';
import { jwtDecode } from "jwt-decode";
import { isTokenValid } from '@/utils/auth.js';
import { toast } from "@steveyuowo/vue-hot-toast";

export default {
  name: 'Login',
  data() {
    return {
      username: '',
      password:'',
      token: null,
    };
  },
  methods: {
    async signin() {
      if (!this.username || !this.password) {
        toast.error('Username and password are required');
        return;
      }
      toast.promise(new Promise(async (resolve, reject) => {
        try {
          const response = await axiosInstance.post('login', {
            user: {
              username: this.username,
              password: this.password,
            }
          });
          const token = response.data.token;
          console.log('login success', token);
          localStorage.setItem('token', token);
          const decoded = jwtDecode(token);
          console.log('decoded', decoded);
          if(decoded) {
            this.$router.push('/');
          }
          resolve('Success!');
        } catch(error) {
          console.error('Login failed:', error);
          reject(new Error('Login failed'));
        }
      }), {
        success: 'Welcome back!',
        error: 'Error signing in',
        loading: 'Loading...',
        position: 'top-center'
      });
    },
  },
  mounted() {
    const token = localStorage.getItem('token');
    if (token && isTokenValid(token)) {
      this.$router.push('/');
    }
  },
};
</script>

<style scoped>
</style>