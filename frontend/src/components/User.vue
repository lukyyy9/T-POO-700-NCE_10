<template>
    <div class="flex justify-center items-center min-h-screen bg-gradient-to-br from-indigo-100 to-purple-100">
      <div id="User" class="bg-white shadow-2xl rounded-3xl p-8 max-w-md w-full mx-4">
        <h2 class="text-3xl font-bold text-center mb-6 text-indigo-600">User Management</h2>
        <div class="space-y-4">
          <input type="text" id="username" placeholder="Username" class="w-full px-4 py-3 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-300">
          <input type="text" id="email" placeholder="Email" class="w-full px-4 py-3 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-300">
          <input type="text" id="user_id" placeholder="User ID" class="w-full px-4 py-3 rounded-full border border-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition duration-300">
        </div>
        <div class="mt-8 space-y-4">
          <button @click="createUser" class="w-full bg-indigo-600 text-white font-semibold py-3 rounded-full hover:bg-indigo-700 transition duration-300 transform hover:scale-105">Create User</button>
          <button @click="updateUser" class="w-full bg-purple-600 text-white font-semibold py-3 rounded-full hover:bg-purple-700 transition duration-300 transform hover:scale-105">Update User</button>
          <button @click="getUser" class="w-full bg-blue-600 text-white font-semibold py-3 rounded-full hover:bg-blue-700 transition duration-300 transform hover:scale-105">Get User</button>
          <button @click="deleteUser" class="w-full bg-red-600 text-white font-semibold py-3 rounded-full hover:bg-red-700 transition duration-300 transform hover:scale-105">Delete User</button>
          <button @click="searchUser" class="w-full bg-green-600 text-white font-semibold py-3 rounded-full hover:bg-green-700 transition duration-300 transform hover:scale-105">Search User</button>
          <button @click="goToChartManager" class="w-full bg-yellow-600 text-white font-semibold py-3 rounded-full hover:bg-yellow-700 transition duration-300 transform hover:scale-105">Go to Chart Manager</button>
        </div>
      </div>
    </div>
  </template>

<script>
import axiosInstance from '../../axios.js';
export default {
    name: 'User',
    data() {
        return {
            user: {}
        };
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