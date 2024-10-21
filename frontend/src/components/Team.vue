<template>
    <div id="team" class="bg-frame rounded-xl w-full p-5">
        <div class="flex gap-x-6">
            <h2>My team</h2>
            <SearchBar />
        </div>
    </div>
</template>

<script>
import SearchBar from './SearchBar.vue';

export default {
    name: 'Team',
    components: {
        SearchBar
    },
    data() {
        return {
            // Your component data goes here
        };
    },
    methods: {
        // Your component methods go here
    },
    computed: {
        // Your computed properties go here
    },
    mounted() {
        // Lifecycle hook for when the component is mounted
    }
};
</script>

<style scoped>
</style>