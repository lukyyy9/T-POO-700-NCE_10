<template>
    <div id="top-right-menu" class="flex flex-row">
        <button v-if="isHomePage" @click="goGraph" class="hidden sm:block rounded-lg border-2 border-secondary bg-transparent mt-2">Go to graphs</button>
        <button v-if="!isHomePage && !isLoginPage" @click="goBack" class="hidden sm:block rounded-lg border-2 border-secondary bg-transparent mt-2">Go back</button>
        <button v-if="userRole !== 3" @click="goGraph" class="block sm:hidden" :style="{ color: isGraphPage ? '#111' : '#817447'  }">
            <font-awesome-icon :icon="['fas', 'chart-simple']" size="xl" />
        </button>
    </div>
</template>

<script>
import { getUserId } from '@/utils/user';
import { getUserRole } from '@/utils/user';

export default {
    name: 'TopRightMenu',
    data() {
        return {
            userId: null,
            userRole: null
        }
    },
    computed: {
        isHomePage() {
            return this.$route.path === '/';
        },
        isLoginPage() {
            return this.$route.path === '/login';
        },
        isGraphPage() {
            return this.$route.path.startsWith('/chartManager/');
        }
    },
    methods: {
        goBack() {
            this.$router.go(-1);
        },
        getRole() {
            const savedToken = localStorage.getItem('token');
            if(savedToken) {
                this.userRole = getUserRole(savedToken);
                console.log('userRole', this.userRole);
            } else {
                console.log('no token found');
            }
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
    onMounted() {
    },
};
</script>

<style scoped>
</style>