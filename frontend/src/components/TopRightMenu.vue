<template>
    <div id="top-right-menu">
        <button v-if="isHomePage" class="rounded-lg border-2 border-secondary bg-transparent mt-2">Go to graphs</button>
        <button v-if="!isHomePage && !isLoginPage" @click="goBack" class="rounded-lg border-2 border-secondary bg-transparent mt-2">Go back</button>
    </div>
</template>

<script>
export default {
    name: 'TopRightMenu',
    computed: {
        isHomePage() {
            return this.$route.path === '/';
        },
        isLoginPage() {
            return this.$route.path === '/login';
        }
    },
    methods: {
        goBack() {
            this.$router.go(-1);
        }
    }
};
</script>

<style scoped>
</style>