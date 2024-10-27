<template>
  <div id="home">
    <!-- Section pour les utilisateurs simples et les managers -->
    <div v-if="userRole === 1 || userRole === 2" class="flex flex-col gap-y-3">
      <div class="flex flex-wrap gap-y-3 lg:gap-x-3 lg:flex-nowrap">
        <ClockManager />
        <WorkingTime />
      </div>
      <Team v-if="userRole === 2" />
    </div>

    <!-- Section pour l'administrateur uniquement -->
    <div v-if="userRole === 3">
      <CreateUser />
    </div>
  </div>
</template>

<script>
import ClockManager from './ClockManager.vue'
import WorkingTime from './WorkingTime.vue'
import Team from './Team.vue'
import CreateUser from './CreateUser.vue'
import ManagerTeam from './ManagerTeam.vue'
import axiosInstance from '../../axios.js'

export default {
  name: 'Home',
  components: {
    CreateUser,
    ClockManager,
    WorkingTime,
    Team,
    ManagerTeam
  },
  data() {
    return {
      userRole: null,
      user: null
    }
  },
  methods: {
    async getUserRole() {
      try {
        const token = localStorage.getItem('token')
        if (!token) {
          console.error('Aucun token trouvé')
          return
        }

        const response = await axiosInstance.get('/users/me', {
          headers: {
            Authorization: `Bearer ${token}`
          }
        })

        console.log('API Response:', response.data)

        const user = response.data

        if (user) {
          this.user = user
          this.userRole = user.role
        } else {
          console.error('Utilisateur non trouvé')
        }
      } catch (error) {
        console.error("Erreur lors de la récupération de l'utilisateur :", error)
      }
    }
  },
  mounted() {
    this.getUserRole()
  }
}
</script>

<style scoped></style>
