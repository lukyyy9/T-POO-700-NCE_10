<template>
    <div id="Login">
        <img src="/gotham.jpg" alt="Gotham picture" class="absolute top-0 left-0 h-full w-[66%] object-cover rounded-l-xl">
        <div class="w-[34%] flex flex-col items-center absolute right-0 top-0 h-full justify-center">
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
                this.$router.push('/')
            }
                
            } catch(error) {
                    console.error('Login failed:', error);
                }
        },
    },
    mounted() {
        if (localStorage.getItem('token')) {
            this.token = localStorage.getItem('token');
        }
    },
};
</script>

<style scoped>
</style>