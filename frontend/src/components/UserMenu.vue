<template>
    <div id="user-menu">
        <div class="bg-mainFrame border border-gray-600 rounded-t-lg px-5 py-2 flex justify-center">
            Edit my profile
        </div>
        <div @click="removePersist" class="bg-red border border-gray-600 rounded-b-lg px-5 py-2 flex justify-center">
            Logout
        </div>
    </div>
</template>

<script>
export default {
    name: 'UserMenu',
    data() {
        return {
            token: null
        };
    },
    methods: {
        removePersist() {
            localStorage.removeItem('token');
            this.token = '';
            this.$router.push('/login')
        }
    },
    computed: {
        // Computed properties go here
    },
};
</script>

<style scoped>
</style>