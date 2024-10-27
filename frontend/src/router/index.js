// frontend/src/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import { isTokenValid } from '@/utils/auth'
import WorkingTime from '@/components/WorkingTime.vue'
import ClockManager from '@/components/ClockManager.vue'
import ChartManager from '@/components/ChartManager.vue'
import Login from '@/components/Login.vue'
import Home from '@/components/Home.vue'
import EditProfile from '@/components/EditProfile.vue'
import ManagerTeam from '@/components/ManagerTeam.vue'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/workingTime/:user_id',
    name: 'Working time creation',
    component: WorkingTime,
    props: true
  },
  {
    path: '/workingTime/:id',
    name: 'Working time edition',
    component: WorkingTime
  },
  {
    path: '/clocks/:user_id',
    name: 'ClockManager',
    component: ClockManager
  },
  {
    path: '/chartManager/:user_id',
    name: 'ChartManager',
    component: ChartManager
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/editProfile',
    name: 'EditProfile',
    component: EditProfile
  },
  {
    path: '/manager/:id',
    name: 'ManagerTeam',
    component: ManagerTeam,
    props: true
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  const token = localStorage.getItem('token')
  const isAuthenticated = isTokenValid(token)

  if (to.path === '/login' && isAuthenticated) {
    next('/')
  } else if (to.path !== '/login' && !isAuthenticated) {
    next('/login')
  } else {
    next()
  }
})

export default router
