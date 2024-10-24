// search bar permet de chercher utilisateur  qui sont employé  et manager dans base de donnée 
// afficher les utilisateurs 
//creer un nouvel utilisateur dans la base de donnée avec un role employé ou manager 
// cliquer sur le nom d'un utilisateur pour afficher une nouvelle page et voir la liste des employés


<script>
import axiosInstance from '../../axios.js';

export default {
  data() {
    return {
      users: [],
      showCreateForm:false,
      newUser:{
        username:'',
        email:'',
        password:'',
        role: '1'
      }
    };
  },
  methods: {
    async getUsers() {
      try {
        const response = await axiosInstance.get('/users');
        console.log('API Response:', response.data.data);
        this.users = response.data.data.filter(user => user.role === 1 || user.role === 2);
        console.log('Filtered Users:', this.users); 
      } catch (error) {
        console.error('Error fetching users:', error);
      }
    },
    async createUsers(){
        try{
        const response = await axiosInstance.post('/users', {
            user : this.newUser
        });
        console.log('User created successfully:', response.data);
        this.users.push(response.data.data)
        this.newUser = {
            username: '',
            email: '',
            password:'',
            role: '1' 
          };
          this.showCreateForm = false;
        } catch(error) {
            console.error('Error creating user:', error);

        }
    }
  },
  mounted() {
    this.getUsers();
  }
};
</script>

<template>
   <div class="flex justify-between items-center">
    <h2>Users</h2>
    <button @click="showCreateForm = true" class="rounded-lg border-2 border-secondary bg-transparent">
        Create a user
      </button>
</div>
    <ul>
      <li v-for="user in users" :key="user.id">
        {{ user.username }} - {{ user.role === 1 ? 'Employee' : 'Manager' }}
      </li>
    </ul>
     <div v-if="showCreateForm">
        <h3>Create new user </h3>
        <form @submit.prevent="createUsers">
          <div>
            <label for="username">Username</label>
            <input v-model="newUser.username" id="username" type="text" required />
          </div>
          <div>
            <label for="email">Email</label>
            <input v-model="newUser.email" id="email" type="email" required />
          </div>
          <div>
            <label for ="password">Password</label>
            <input v-model="newUser.password" id="password" type="password" required />
          </div>
          <div>
            <label for="role">Role</label>
            <select v-model="newUser.role" id="role" required>
              <option value="1">Employee</option>
              <option value="2">Manager</option>
            </select>
          </div>
          <button icon="pi pi-check" type="submit" class="bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300 mt-0" >Submit</button>
          <button @click="showCreateForm = false" class="rounded-lg border-2 border-red bg-transparent">
            Cancel
        </button>
        </form>
      </div>
</template>

