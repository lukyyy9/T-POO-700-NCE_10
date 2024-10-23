<template>
    <div id="user-menu" v-if="isMenuOpen">
        <div @click="editProfile" class="bg-mainFrame border border-gray-600 rounded-t-lg px-5 py-2 flex justify-center cursor-pointer hover:bg-frame">
            Edit my profile
        </div>
        <div @click="logout" class="bg-secondary border text-black border-gray-600 rounded-b-lg px-5 py-2 flex justify-center cursor-pointer hover:bg-secondaryAccent">
            Logout
        </div>
    </div>
</template>

<script>
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
            this.$router.push('/login');
            this.$emit('close-menu');
        }
    }
};
</script>

<style scoped>
</style>