// search bar permet de chercher utilisateur qui sont employé et manager dans base de donnée //
afficher les utilisateurs //creer un nouvel utilisateur dans la base de donnée avec un role employé
ou manager // cliquer sur le nom d'un utilisateur pour afficher une nouvelle page et voir la liste
des employés

<script>
import axiosInstance from '../../axios.js'

export default {
  data() {
    return {
      users: [],
      showCreateForm: false,
      newUser: {
        username: '',
        email: '',
        password: '',
        role: '1'
      }
    }
  },
  methods: {
    async getUsers() {
      try {
        const response = await axiosInstance.get('/users')
        console.log('API Response:', response.data.data)
        this.users = response.data.data.filter((user) => user.role === 1 || user.role === 2)
        console.log('Filtered Users:', this.users)
      } catch (error) {
        console.error('Error fetching users:', error)
      }
    },
    goToManager(user) {
      if (user.role === 2) {
        console.log('Navigating to manager team:', user.username)
        this.$router.push({
          name: 'ManagerTeam',
          params: { id: user.id },
          query: { name: user.username }
        })
      }
    },
    async createUsers() {
      try {
        const response = await axiosInstance.post('/users', {
          user: this.newUser
        })
        console.log('User created successfully:', response.data)
        this.users.push(response.data.data)
        this.newUser = {
          username: '',
          email: '',
          password: '',
          role: '1'
        }
        this.showCreateForm = false
      } catch (error) {
        console.error('Error creating user:', error)
      }
    }
  },
  mounted() {
    this.getUsers()
  }
}
</script>

<template>
  <div class="p-4">
    <!-- Titre et bouton Create a user alignés -->
    <div class="flex flex-col sm:flex-row justify-between items-center mb-4">
      <!-- Utilisation de la police Cormorant Garamond pour le titre -->
      <h2 class="font-serif text-2xl mb-2 sm:mb-0">Users</h2>
      <button
        @click="showCreateForm = true"
        class="w-full sm:w-auto rounded-lg border-2 border-secondary bg-transparent px-4 py-2 text-white"
      >
        Create a user
      </button>
    </div>

    <!-- Liste des utilisateurs avec cursor-pointer pour les managers -->
    <ul class="space-y-2">
      <li
        v-for="user in users"
        :key="user.id"
        @click="goToManager(user)"
        class="cursor-pointer p-4 bg-dark-gray rounded-lg shadow-md flex justify-between items-center hover:bg-gray-600"
      >
        {{ user.username }} - {{ user.role === 1 ? 'Employee' : 'Manager' }}
      </li>
    </ul>

    <!-- Formulaire de création d'utilisateur -->
    <div
      v-if="showCreateForm"
      class="mt-6 bg-dark-gray p-6 rounded-lg shadow-md max-w-md mx-auto text-white"
    >
      <h3 class="font-serif text-xl mb-4">Create new user</h3>
      <form @submit.prevent="createUsers">
        <div class="mb-4">
          <label for="username" class="block mb-2">Username</label>
          <input
            v-model="newUser.username"
            id="username"
            type="text"
            required
            class="w-full p-2 border border-gray-300 rounded bg-dark-gray text-white"
          />
        </div>

        <div class="mb-4">
          <label for="email" class="block mb-2">Email</label>
          <input
            v-model="newUser.email"
            id="email"
            type="email"
            required
            class="w-full p-2 border border-gray-300 rounded bg-dark-gray text-white"
          />
        </div>

        <div class="mb-4">
          <label for="password" class="block mb-2">Password</label>
          <input
            v-model="newUser.password"
            id="password"
            type="password"
            required
            class="w-full p-2 border border-gray-300 rounded bg-dark-gray text-white"
          />
        </div>

        <div class="mb-4">
          <label for="role" class="block mb-2">Role</label>
          <select
            v-model="newUser.role"
            id="role"
            required
            class="w-full p-2 border border-gray-300 rounded bg-dark-gray text-white"
          >
            <option value="1">Employee</option>
            <option value="2">Manager</option>
          </select>
        </div>

        <div class="flex flex-col sm:flex-row justify-between gap-4">
          <!-- Bouton Submit avec styles définis -->
          <button
            type="submit"
            class="w-full sm:w-auto bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300 rounded-lg px-4 py-2"
          >
            Submit
          </button>
          <!-- Bouton Cancel avec styles définis -->
          <button
            @click="showCreateForm = false"
            class="w-full sm:w-auto rounded-lg border-2 border-red bg-transparent px-4 py-2 text-red hover:bg-red hover:text-white"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  </div>
</template>
