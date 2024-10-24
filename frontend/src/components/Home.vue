<template>
    <div id="home">
        <div class="flex flex-col gap-y-3"> <!-- ONLY IF THE USER IS A USER OR A MANAGER -->
            <div class="flex flex-wrap gap-y-3 lg:gap-x-3 lg:flex-nowrap">
                <ClockManager />
                <WorkingTime />
            </div>
            <Team /> <!-- ONLY IF THE USER IS A MANAGER -->
        </div>
        <div> <!-- ONLY IF THE USER IS AN ADMIN -->
            <CreateUser/>
        </div>
    </div>
</template>

<script>
import ClockManager from './ClockManager.vue';
import WorkingTime from './WorkingTime.vue';
import Team from './Team.vue';
import CreateUser from './CreateUser.vue';
export default {
    name: 'Home',
    components: {
        ClockManager,
        WorkingTime,
        Team, 
        CreateUser

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