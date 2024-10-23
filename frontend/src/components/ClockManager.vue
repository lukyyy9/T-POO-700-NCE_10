<template>
    <div id="ClockManager" class="bg-frame rounded-xl p-5 w-[50%]">
            <div class="flex justify-between">
                <h2>My Clocks</h2>
                <button @click="clock" class="bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300">Clock in 📝</button>
            </div>
            <div>
                <div class="w-full flex justify-center pb-4">
                    <p>{{ formatDayMonth(startDateTime) }}</p>
                </div>
                <div class="flex justify-center p-2 bg-subFrame rounded-[10px] font-inter text-white font-semiBold">
                    <div v-if="clocksDay.length === 0" class="pt-2 pb-2">
                        <p>No clocks available for today !</p>
                    </div>
                    <div v-else class="flex-col justify-center items-center w-11/12">
                        <div v-for="(clock, i) in clocksDay" :key="i" class="flex p-1 justify-between">
                            <div v-if="i === 0" class="flex items-center">
                                <div class="w-16 pl-1">
                                    <font-awesome-icon :icon="['fas', 'person-walking']" size="lg"/>
                                </div>
                                <p>Start</p>
                            </div>
                            <div v-else-if="clocksDay.length % 2 === 0 && i === clocksDay.length-1" class="flex items-center">
                                <div class="w-16">
                                    <font-awesome-icon :icon="['fas', 'person-walking-arrow-right']" size="lg"/>
                                </div>
                                <p>End</p>
                            </div>
                            <div v-else-if="clock.status === true" class="flex items-center">
                                <div class="w-16 pl-[2px]">
                                    <font-awesome-icon :icon="['fas', 'suitcase']" size="s"/>
                                </div>
                                <p>Break End</p>
                            </div>
                            <div v-else class="flex items-center">
                                <div class="w-16">
                                    <font-awesome-icon :icon="['fas', 'mug-saucer']" size="s"/>
                                </div>
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
import { getUserId } from '@/utils/user.js';

export default {
    name: 'ClockManager',
    data() {
        return {
            clocksDay: [],
            startDateTime: null,
            clockIn: false,
            userId: null
             };
    },
    methods: {
        refresh() {
            const savedToken = localStorage.getItem('token');
            if(savedToken) {
                this.userId = getUserId(savedToken);
                console.log('userId', this.userId);
            } else {
                console.log('to token found');
            }
           
            axiosInstance.get(`clocks/${this.userId}`)
                .then(response => {  
                    const clocksData = response.data.data;
                    console.log('data', clocksData);
                    if(clocksData){
                        const lastClock = clocksData[clocksData.length - 1];
                    this.startDateTime = moment(lastClock.time).format('YYYY-MM-DD HH:mm:ss');
                    this.clockIn = lastClock.status;
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
            axiosInstance.post(`clocks/${this.userId}`)
                .then(response => {
                    const newClock = response.data.data;
                    this.startDateTime = moment(newClock.time).format('YYYY-MM-DD HH:mm:ss');
                    this.clockIn = newClock.status;
                    this.clocksDay.push(newClock);
                })
                .catch(error => {
                    console.error('There was an error new Clock:', error);
                });
        },
       
    },
    mounted() {
        this.refresh();
    }
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600&family=Inter:wght@400&display=swap');
</style>