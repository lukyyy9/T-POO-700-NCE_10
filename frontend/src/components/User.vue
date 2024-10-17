<template>
    <div v-if="route.path !== '/login'" id="User" @click="$emit('toggle-user-menu')">
        <img src="/pfp.png" alt="Profile picture" class="h-9 rounded-full border-4 border-secondary shadow">
    </div>
</template>

<script>
import { useRoute } from 'vue-router';
import axiosInstance from '../../axios.js';

export default {
    name: 'User',
    data() {
        return {
            user: {}
        };
    },
    setup() {
        const route = useRoute();
        return { route };
    },
    methods: {
        createUser() {
            const username = document.getElementById('username').value;
            const email = document.getElementById('email').value;
            axiosInstance.post('users', {
                user: {
                    username: username,
                    email: email
                }
            })
                .then(response => {
                    console.log('User created:', response.data.data);
                })
                .catch(error => {
                    console.error('There was an error creating the user:', error);
                });
        },
        updateUser() {
            const user_id = document.getElementById('user_id').value;
            const username = document.getElementById('username').value;
            const email = document.getElementById('email').value;
            axiosInstance.put(`users/${user_id}`, {
                user: {
                    username: username,
                    email: email
                }
            })
                .then(response => {
                    console.log('User updated:', response.data.data);
                })
                .catch(error => {
                    console.error('There was an error updating the user:', error);
                });
        },
        getUser() {
            const user_id = document.getElementById('user_id').value;
            axiosInstance.get(`users/${user_id}`)
                .then(response => {
                    this.user = response.data;
                    console.log('User:', response.data.data);
                })
                .catch(error => {
                    console.error('There was an error getting the user:', error);
                });
        },
        deleteUser() {
            const user_id = document.getElementById('user_id').value;
            axiosInstance.delete(`users/${user_id}`)
                .then(response => {
                    console.log('User deleted:', response.data.data);
                })
                .catch(error => {
                    console.error('There was an error deleting the user:', error);
                });
        },
        searchUser() {
            const username = document.getElementById('username').value;
            const email = document.getElementById('email').value;
            axiosInstance.get(`users?email=${email}&username=${username}`)
                .then(response => {
                    this.user = response.data;
                    console.log('User:', response.data.data);
                })
                .catch(error => {
                    console.error('There was an error getting the user:', error);
                });
        },
        goToChartManager() {
            const user_id = document.getElementById('user_id').value;
            this.$router.push(`/chartManager/${user_id}`);
        }
    },
    mounted() {
        console.log(import.meta.env.VITE_AXIOSBASEURL);
    }
};
</script>

<style scoped>
</style>