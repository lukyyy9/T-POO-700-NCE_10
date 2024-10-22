<template>
    <div id="top-right-menu">
        <button v-if="isHomePage" class="rounded-lg border-2 border-secondary bg-transparent mt-2">Go to graphs</button>
    </div>
</template>

<script>
export default {
    name: 'TopRightMenu',
    computed: {
        isHomePage() {
            return this.$route.path === '/';
        }
    }
};
</script>

<style scoped>
</style>