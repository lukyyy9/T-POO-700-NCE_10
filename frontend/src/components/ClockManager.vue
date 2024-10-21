<template>
    <div id="ClockManager" class="bg-frame rounded-xl p-5 w-[50%]">
            <div class="flex justify-between">
                <h2>My Clocks</h2>
                <button @click="clock" class="bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300">Clock in 📝</button>
            </div>
            <div>
                <h2 class="text-[15px]  text-white border-b-2 border-white" >{{ formatDayMonth(startDateTime) }}</h2>
                <div class="flex justify-center p-2 bg-subFrame rounded-[10px] font-inter text-white font-semiBold text-[9px] w-1/2">
                    <div v-if="clocksDay.length === 0" class="pt-2 pb-2 text-[12px]">
                        <p>No clocks available for today !</p>
                    </div>
                    <div v-else class="flex-col justify-center items-center w-11/12">
                        <div v-for="(clock, i) in clocksDay" :key="i" class="flex p-1 justify-between">
                            <p v-if="i === 0" > Start</p>
                            <p v-else-if="i === clocksDay.length-1" >End</p>
                            <p v-else-if="clock.status">Break End</p>
                            <p v-else>Break Start</p>
                            <p>{{ formatHours(clock.time) }}</p>
                        </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axiosInstance from '../../axios.js';
import moment from 'moment';

export default {
    name: 'ClockManager',
    data() {
        return {
            clocksDay: [],
            startDateTime: null,
            clockIn: false,
             };
    },
    methods: {
        refresh() {
            const user_id = this.$route.params.user_id;
            
            axiosInstance.get(`clocks/${user_id}`)
                .then(response => {  
                    const clocksData = response.data.data;
                    console.log('data', response.data.data)
                    if(response.data.data){
                        const lastClock = clocksData[response.data.data.length - 1];
                    this.startDateTime = moment(lastClock.time).format('YYYY-MM-DD HH:mm:ss');
                    this.clockIn = lastClock.status;
                    console.log('startDateTime:', this.startDateTime);
                    console.log('clockIn:', this.clockIn);

                    const currentDay = moment().format('DD MMMM YY');
                        clocksData.forEach(ele => {
                            const dayClock = moment(ele.time).format('DD MMMM YY');
                            if (currentDay === dayClock) {
                                this.clocksDay.push(ele);
                            }
                        });

                    } else {
                      console.log('not clocks');
                    };
                    
                })
                .catch(error => {
                    console.error('There was an error getting the user', error);
                });
        },
        formatDayMonth(date) {
            return moment(date).format('dddd, DD MMMM');
        },
        formatHours(date) {
            return moment(date).format('HH:mm');
        },
        clock() {
            const user_id = this.$route.params.user_id;
            axiosInstance.post(`clocks/${user_id}`)
                .then(response => {
                    const newClock = response.data.data;
                    this.startDateTime = moment(newClock.time).format('YYYY-MM-DD HH:mm:ss');
                    this.clockIn = newClock.status;
                    console.log('New Clock:', newClock);

                    this.clocksDay.push(newClock);

                })
                .catch(error => {
                    console.error('There was an error new Clock:', error);
                });
        },
       
    },
    mounted() {
        this.refresh();
        this.clocksDay;
    }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600&family=Inter:wght@400&display=swap');
</style>