<template>
    <div id="ClockManager" class="flex flex-col bg-blue-200 border border-gray-800 m-4 rounded-xl p-4 items-center w-fit">
        <p class="font-bold">ClockManager</p>
        <button @click="refresh">Afficher le dernier pointage</button>
        <button @click="clock">Pointer</button>
        <p>Start Date Time : {{ startDateTime }}</p>
        <p v-if="clockIn === true" class="text-green-500">Présent</p>
        <p v-else class="text-red-500">Absent</p>     
    </div>
</template>

<script>
import axiosInstance from '../../axios.js';
import moment from 'moment';
export default {
    name: 'ClockManager',
    data() {
        return {
            clockManager: {},
            startDateTime: null,
            clockIn: false,
             };
    },
    methods: {
        refresh() {
            const user_id = this.$route.params.user_id;
            console.log('user id', this.$route.params);
            
            axiosInstance.get(`clocks/${user_id}`)
                .then(response => {   
                    const lastClock = response.data.data[response.data.data.length - 1];
                    this.startDateTime = moment(lastClock.time).format('YYYY-MM-DD HH:mm:ss');
                    this.clockIn = lastClock.status;
                    console.log('startDateTime:', this.startDateTime);
                    console.log('clockIn:', this.clockIn);
                })
                .catch(error => {
                    console.error('There was an error getting the user', error);
                });
        },
        clock() {
            const user_id = this.$route.params.user_id;
            axiosInstance.post(`clocks/${user_id}`)
                .then(response => {
                    this.startDateTime = moment(response.data.data.time).format('YYYY-MM-DD HH:mm:ss');
                    this.clockIn = response.data.data.status;
                    console.log('New Clock:', response.data.data);
                })
                .catch(error => {
                    console.error('There was an error new Clock:', error);
                });
        },
    },
    mounted() {
        // Code to run when component is mounted
    }
};
</script>

<style scoped>
</style>