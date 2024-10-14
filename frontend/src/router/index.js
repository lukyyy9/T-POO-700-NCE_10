import { createRouter, createWebHistory } from 'vue-router'
import WorkingTimes from '@/components/WorkingTimes.vue'
import WorkingTime from '@/components/WorkingTime.vue'
import ClockManager from '@/components/ClockManager.vue'
import ChartManager from '@/components/ChartManager.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/workingTimes/:user_id',
      name: 'Working Times',
      component: WorkingTimes,
      exact: true
    },
    {
      path: '/workingTime/:user_id',
      name: 'Working time creation',
      component: WorkingTime,
      exact: true
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
    }
  ]
})

export default router
