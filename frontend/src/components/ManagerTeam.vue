<template>
  <div id="app" class="p-4">
    <!-- Titre et bouton Add a user alignés -->
    <div class="flex justify-between items-center mb-4 flex-wrap">
      <!-- Utilisation de Cormorant Garamond pour le nom du manager -->
      <h1>{{ managerName }}'s Team</h1>
      <button
        @click="showAddUserForm = true"
        class="rounded-lg border-2 border-secondary bg-transparent px-4 py-2 text-white"
      >
        Add an existing user
      </button>
    </div>

    <!-- Formulaire d'ajout d'un utilisateur existant -->
    <div v-if="showAddUserForm" class="flex justify-center items-center min-h-screen">
      <form
        @submit.prevent="addUserToTeam"
        class="bg-dark-gray p-6 rounded-lg shadow-md w-full max-w-md text-white"
      >
        <h3 class="text-lg font-bold mb-4">Add an existing user</h3>

        <div class="mb-4">
          <label for="user" class="block text-white">Select an employee</label>
          <select
            v-model="selectedUserId"
            id="user"
            required
            class="w-full p-2 border border-gray-300 rounded bg-dark-gray text-white"
          >
            <option v-for="user in availableEmployees" :key="user.id" :value="user.id">
              {{ user.username }} - {{ user.email }}
            </option>
          </select>
        </div>

        <div class="flex justify-between">
          <!-- Bouton Add to team avec styles de ta config -->
          <button
            type="submit"
            class="bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300 rounded-lg"
          >
            Add to the team
          </button>
          <!-- Bouton Cancel avec styles de ta config -->
          <button
            type="button"
            @click="cancelAddUser"
            class="rounded-lg border-2 border-red bg-transparent px-4 py-2 text-red hover:bg-red hover:text-white"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>

    <!-- Liste des utilisateurs dans l'équipe du manager -->
    <ul class="space-y-2">
      <li
        v-for="user in teamUsers"
        :key="user.id"
        class="bg-dark-gray p-4 rounded-lg shadow-md flex justify-between items-center"
      >
        <span>{{ user.username }} - {{ user.role === 1 ? 'Employé' : 'Manager' }}</span>
      </li>
    </ul>
  </div>
</template>

<script>
import axiosInstance from '../../axios.js'

export default {
  props: ['id'], // L'id du manager
  data() {
    return {
      managerName: '', // Nom du manager
      showAddUserForm: false, // Afficher ou masquer le formulaire d'ajout
      users: [], // Liste des utilisateurs existants
      teamUsers: [], // Liste des employés sous la responsabilité du manager
      availableEmployees: [], // Liste des employés disponibles pour ajout
      selectedUserId: null // ID de l'utilisateur sélectionné à ajouter à l'équipe
    }
  },
  methods: {
    async getManager() {
      try {
        const response = await axiosInstance.get(`/users/${this.id}`)
        this.managerName = response.data.username
      } catch (error) {
        console.error('Error fetching manager details:', error)
      }
    },

    async getTeamUsers() {
      try {
        const response = await axiosInstance.get(`/managers/${this.id}/team`)
        this.teamUsers = response.data.data
      } catch (error) {
        console.error('Error fetching team users:', error)
      }
    },

    async getAvailableEmployees() {
      try {
        // Récupérer uniquement les employés (role = 1)
        const response = await axiosInstance.get('/users')
        this.availableEmployees = response.data.data.filter(
          (user) => user.role === 1 && !this.teamUsers.some((teamUser) => teamUser.id === user.id)
        )
      } catch (error) {
        console.error('Error fetching available employees:', error)
      }
    },

    async addUserToTeam() {
      try {
        // Ajouter l'utilisateur sélectionné à l'équipe du manager
        const response = await axiosInstance.post(`/managers/${this.id}/add-user`, {
          userId: this.selectedUserId
        })
        console.log('User added to team:', response.data)

        // Mettre à jour la liste des membres de l'équipe
        this.teamUsers.push(response.data.data)

        // Réinitialiser le formulaire et masquer le formulaire
        this.selectedUserId = null
        this.showAddUserForm = false
        this.getAvailableEmployees() // Réactualise la liste des employés disponibles
      } catch (error) {
        console.error('Error adding user to team:', error)
      }
    },
    cancelAddUser() {
      this.selectedUserId = null // Réinitialise la sélection de l'utilisateur
      this.showAddUserForm = false // Masquer le formulaire
    },
    updateManagerName(name) {
      if (name && name !== this.managerName) {
        this.managerName = name
        console.log('ManagerName updated:', this.managerName)
      }
    }
  },
  mounted() {
    const managerNameFromQuery = this.$route.query.name || 'Unknown'
    this.managerName = managerNameFromQuery
    //this.getManager() // Récupérer les infos du manager
    this.getTeamUsers() // Récupérer la liste des utilisateurs dans l'équipe du manager
    this.getAvailableEmployees() // Récupérer les employés disponibles
  }
}
</script>

<style scoped>
/* Ajoute du style ici si nécessaire */
</style>
