import { createRouter, createWebHistory } from 'vue-router'
import WorkingTime from '@/components/WorkingTime.vue'
import ClockManager from '@/components/ClockManager.vue'
import ChartManager from '@/components/ChartManager.vue'
import Login from '@/components/Login.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      //path: '/workingTime/:user_id',
     // name: 'Working Times',
      //component: WorkingTimes,
      //props: true
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
  ]
})

export default router
