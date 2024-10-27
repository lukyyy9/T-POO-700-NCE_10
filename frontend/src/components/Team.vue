<template>
  <div id="team" class="bg-frame rounded-xl w-full p-5">
    <div class="flex gap-x-6">
      <h2>My team</h2>
      <SearchBar />
    </div>
    <ul class="space-y-2 mt-4">
      <li
        v-for="user in teamUsers"
        :key="user.id"
        class="bg-dark-gray p-4 rounded-lg shadow-md flex justify-between items-center"
      >
        {{ user.username }} - {{ user.role === 1 ? 'Employé' : 'Manager' }}
      </li>
    </ul>
  </div>
</template>

<script>
import axiosInstance from '../../axios.js'
import SearchBar from './SearchBar.vue'

export default {
  name: 'Team',
  components: {
    SearchBar
  },
  data() {
    return {
      teamUsers: []
    }
  },
  methods: {
    async getTeamUsers() {
      try {
        const response = await axiosInstance.get('/users/me')
        const managerId = response.data.id
        console.log('Manager ID:', managerId)

        const teamResponse = await axiosInstance.get(`/managers/${managerId}/team`)
        this.teamUsers = teamResponse.data.data
        console.log('Team members:', this.teamUsers)
      } catch (error) {
        console.error("Erreur lors de la récupération de l'équipe :", error)
      }
    }
  },
  mounted() {
    this.getTeamUsers()
  }
}
</script>

<style scoped></style>
