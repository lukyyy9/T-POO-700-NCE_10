<template>
    <div id="home">
        <div class="flex flex-col gap-y-3"> <!-- ONLY IF THE USER IS A USER OR A MANAGER -->
            <div class="flex flex-wrap gap-y-3 lg:gap-x-3 lg:flex-nowrap">
                <ClockManager />
                <WorkingTime />
            </div>
            <Team /> <!-- ONLY IF THE USER IS A MANAGER -->
        </div>
    </div>
</template>

<script>
import ClockManager from './ClockManager.vue';
import WorkingTime from './WorkingTime.vue';
import Team from './Team.vue';

export default {
    name: 'Home',
    components: {
        ClockManager,
        WorkingTime,
        Team
    },
    data() {
        return {
            // Add your component data here
        };
    },
    methods: {
        // Add your component methods here
    },
    mounted() {
        // Lifecycle hook when component is mounted
    }
};
</script>