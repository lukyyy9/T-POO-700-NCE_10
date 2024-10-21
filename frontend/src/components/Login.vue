<template>
    <div id="Login">
        <img src="/gotham.jpg" alt="Gotham picture" class="absolute top-0 left-0 h-full w-[66%] object-cover rounded-l-xl">
        <div class="w-[34%] flex flex-col items-center absolute right-0 top-0 h-full justify-center">
            <h1>
                Welcome back 👋
            </h1>
            <div class="flex flex-col justify-start">
                <label for="username">Username</label>
                <input type="text" id="username" name="username">
                <label for="password">Password</label>
                <input type="password" id="password" name="password">
            </div>
            <button class="bg-primary text-black border-2 border-primaryAccent hover:shadow-[0px_0px_9px_2px_#FFEFB7] transition-shadow duration-300">
                Sign in 🦇
            </button>
        </div>
    </div>
</template>

<script>
import axiosInstance from '../../axios.js';
export default {
    name: 'Login',
    data() {
        return {
            //data
        };
    },
    methods: {
        //methods
    },
    mounted() {
        //mounted
    }
};
</script>

<style scoped>
</style>