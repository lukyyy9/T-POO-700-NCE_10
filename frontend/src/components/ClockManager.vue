<template>
    <div id="ClockManager" class="bg-frame rounded-xl p-5 lg:w-[50%] w-[100%]">
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
                            <div v-else-if="clock.status === false" class="flex items-center">
                                <div class="w-16 pl-[2px]">
                                    <font-awesome-icon :icon="['fas', 'suitcase']"/>
                                </div>
                                <p>Break End</p>
                            </div>
                            <div v-else class="flex items-center">
                                <div class="w-16">
                                    <font-awesome-icon :icon="['fas', 'mug-saucer']"/>
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
import { toast } from "@steveyuowo/vue-hot-toast";

export default {
    name: 'ClockManager',
    data() {
        return {
            clocksDay: [],
            startDateTime: null,
            clockIn: false,
            userId: null,
            elapsed: 0,
            intervalId: null
            };
    },
    
    methods: {
        startTimer() {
                //clearInterval(this.intervalId);
                this.intervalId = setInterval(() => {
                this.elapsed += 1;
            }, 1000);
        },
        
        stopTimer() {
                clearInterval(this.intervalId);
                this.intervalId = null;
        },

        formatDuration(seconds) {
            const hours = Math.floor(seconds / 3600).toString().padStart(2, '0');
            const minutes = Math.floor((seconds % 3600) / 60).toString().padStart(2, '0');
            const secs = Math.floor(seconds % 60).toString().padStart(2, '0');
            if (hours >= 8) {
                return `${hours}:${minutes}:${secs} - Time to go home!`;
            } else if(hours === 0) {
                return `${hours}:${minutes}:${secs} - Go back to work!`;
            } else {
                return `${hours}:${minutes}:${secs} - Keep it up!`;
            }
        },

        refresh() {
            const savedToken = localStorage.getItem('token');
            if(savedToken) {
                this.userId = getUserId(savedToken);
            } else {
                console.log('to token found');
            }
           
            axiosInstance.get(`clocks/${this.userId}`)
                .then(response => {  
                    const clocksData = response.data.data;

                    if(clocksData){
                        this.clocksDay = clocksData.filter(clock => moment(clock.time).isSame(moment(), 'day'));

                        const lastClock = clocksData[clocksData.length - 1];
                        this.startDateTime = moment(lastClock.time).format('YYYY-MM-DD HH:mm:ss');
                        this.clockIn = lastClock.status;
                        
                        let inSession = false;
                        let sessionStart = null;
                        let totalDuration = 0; 
                        for (let i = 0; i < this.clocksDay.length; i++) {
                            const clock = this.clocksDay[i];
                            if (!clock.status) {
                                sessionStart = moment(clock.time);
                                inSession = true;
                            } else if (inSession && sessionStart){
                                totalDuration += moment(clock.time).diff(sessionStart);
                                inSession = false;
                                sessionStart = null;
                            }
                        }

                // Si une session est en cours, ajouter le temps depuis le dernier pointage
                if (inSession && sessionStart) {
                    totalDuration += moment().diff(sessionStart);
                    this.startTimer();
                } else {
                    this.stopTimer();
                }

                this.elapsed = Math.floor(totalDuration / 1000);

                } else {
                console.log('No clocks for today');
                }

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
            toast.promise(new Promise(async (resolve, reject) => {
                try {
                    const response = await axiosInstance.post(`clocks/${this.userId}`);
                    const newClock = response.data.data;
                    this.startDateTime = moment(newClock.time).format('YYYY-MM-DD HH:mm:ss');
                    this.clockIn = newClock.status;
                    this.clocksDay.push(newClock);
                    if(newClock.status) {
                        this.startTimer();
                    } else {
                        this.stopTimer();
                    }
                    resolve('Clock created successfully!');
                } catch (error) {
                    console.error('There was an error creating a new Clock:', error);
                    reject(new Error('Clock creation failed'));
                }
            }), {
                success: 'Clock created successfully!',
                error: 'Clock creation failed',
                loading: 'Creating clock...',
                position: 'top-center'
            });
        },
    },
    mounted() {
        this.refresh();
    },
    
};
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@600&family=Inter:wght@400&display=swap');
</style>