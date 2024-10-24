<template>
    <div id="user-menu" v-if="isMenuOpen">
        <div @click="editProfile" class="bg-mainFrame border border-gray-600 rounded-t-lg px-5 py-2 flex justify-center cursor-pointer hover:bg-frame">
            <p>Edit my profile</p>
        </div>
        <div @click="logout" class="bg-secondary border border-gray-600 rounded-b-lg px-5 py-2 flex justify-center cursor-pointer hover:bg-secondaryAccent">
            <p class="text-black">Logout</p>
        </div>
    </div>
</template>

<script>
import { toast } from "@steveyuowo/vue-hot-toast";

export default {
    name: 'UserMenu',
    props: {
        isMenuOpen: {
            type: Boolean,
            required: true
        }
    },
    methods: {
        editProfile() {
            this.$router.push('/editProfile');
            this.$emit('close-menu');
        },
        logout() {
            localStorage.removeItem('token');
            toast.success('Logged out successfully');
            this.$router.push('/login');
            this.$emit('close-menu');
        }
    }
};
</script>

<style scoped>
</style>