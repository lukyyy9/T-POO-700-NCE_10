<template>
    <div id="top-right-menu" class="flex flex-row">
        <button v-if="isHomePage" @click="goGraph" class="hidden sm:block rounded-lg border-2 border-secondary bg-transparent mt-2">Go to graphs</button>
        <button v-if="!isHomePage && !isLoginPage" @click="goBack" class="hidden sm:block rounded-lg border-2 border-secondary bg-transparent mt-2">Go back</button>
        <button @click="goGraph" class="block sm:hidden" style="color:black!important">
            <font-awesome-icon :icon="['fas', 'chart-simple']" size="xl" />
        </button>
    </div>
</template>

<script>
import { getUserId } from '@/utils/user';

export default {
    name: 'TopRightMenu',
    data() {
        return {
            userId: null,
        }
    },
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
        },
        goGraph() {
            const savedToken = localStorage.getItem('token');
            if(savedToken) {
                this.userId = getUserId(savedToken);
                console.log('userId', this.userId);
            } else {
                console.log('to token found');
            }
            if(this.userId) {
                this.$router.push(`/chartManager/${this.userId}`);
            } else {
                console.log('no userId');
            }
            
        }

    },
    mounted(){

    }
};
</script>

<style scoped>
</style>