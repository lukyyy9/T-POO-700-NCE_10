<template>
    <div id="ClockManager" class="flex-col m-3 w-1/2 h-5/6 bg-[#4E4E4E] rounded-[10px] p-5">
            <div class="flex justify-between">
                <h1 class="text-[25px] text-white">My Clocks</h1>
                <button @click="clock" class="mt-0 w-[112px] h-[33px] rounded-[8px] bg-[#DBADFF] border-[2px] border-[#E7C9FF] drop-shadow-xl hover:shadow-[0px_0px_9px_2px_#FFEFB7] transition-shadow duration-300" ><p class="font-inter font-normal text-[14px]">Clock in 📝</p></button>
            </div>
            <div class="flex-col mt-6 ml-2">
                <h2 class="text-[15px]  text-white border-b-[1px] border-white" >{{ formatDayMonth(startDateTime) }}</h2>
                <div class="flex justify-center p-2 bg-[#656565] rounded-[10px] font-inter text-white font-semiBold text-[9px] w-1/2">
                    <div v-if="clocksDay.length === 0" class="pt-2 pb-2 text-[12px]">
                        <p>No clocks available for today !</p>
                    </div>
                    <div v-else class="flex-col justify-center items-center w-11/12">
                        <div v-for="(clock, i) in clocksDay" :key="i" class="flex p-1 justify-between">
                            <div v-if="i === 0" class="flex items-center gap-3" >
                                <font-awesome-icon :icon="['fas', 'person-walking']" size="2xl"/>
                                <p>Start</p>
                            </div>
                            <div v-else-if="i === clocksDay.length-1" class="flex items-center gap-3">
                                <font-awesome-icon :icon="['fas', 'person-walking-arrow-right']" size="2xl"/>
                                <p>End</p>
                            </div>
                            <div v-else-if="clock.status" class="flex items-center gap-3">
                                <font-awesome-icon :icon="['fa', 'xmark']" size="2xl"/>
                                <p>Break End</p>
                            </div>
                            <div v-else class="flex items-center gap-3">
                                <font-awesome-icon :icon="['fas', 'mug-saucer']" size="lg"/>
                                <p>Break Start</p>
                            </div>
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