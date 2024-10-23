<template>
    <div id="edit-profile" class="bg-frame rounded-xl p-5 w-[100%] flex justify-center flex-col">
        <h2>Profile</h2>
        <div class="flex flex-col items-center">
            <label for="username">Username:</label>
            <input v-model="username" type="text" id="username" name="username">
            <label for="email">Email:</label>
            <input v-model="email" type="email" id="email" name="email">
            <label for="password">Password:</label>
            <input v-model="password" type="password" id="password" name="password">
            <button @click="submitProfile" class="rounded-lg border-2 border-secondary bg-transparent mt-2 w-fit">Submit</button>
        </div>
    </div>
</template>

<script>
import axiosInstance from '../../axios.js';
import { getUserId } from '@/utils/user';
import { toast } from "@steveyuowo/vue-hot-toast";

export default {
    name: 'EditProfile',
    data() {
        return {
            username: '',
            email: '',
            password: ''
        };
    },
    methods: {
        async submitProfile() {
            const token = localStorage.getItem('token');
            const userId = getUserId(token);

            if (!userId) {
                console.error('User ID not found');
                return;
            }

            const userData = {
                user: {
                    username: this.username,
                    email: this.email,
                    password: this.password
                }
            };

            toast.promise(new Promise(async (resolve, reject) => {
                try {
                    const response = await axiosInstance.put(`users/${userId}`, userData);
                    console.log('Profile updated successfully', response.data);
                    this.$router.push('/');
                    resolve('Profile updated successfully!');
                } catch (error) {
                    console.error('Error updating profile:', error);
                    reject(new Error('Error updating profile'));
                }
            }), {
                success: 'Profile updated successfully!',
                error: 'Error updating profile',
                loading: 'Updating profile...',
                position: 'top-center'
            });
        }
    }
};
</script>