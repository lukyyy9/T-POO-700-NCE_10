<script>
import axiosInstance from '../../axios.js';
import { getUserId } from '../utils/user.js'; 

export default {
  data() {
    return {
      workingTimes: [],
      currentWorkingTime: {
        start: '',
        end: ''
      },
      isCreating: false,
      isEditing: false,
      user_id: null 
    };
  },
  methods: {
    async getWorkingTimes() {
      if (!this.user_id) {
        console.error('No user_id found');
        return;
      }
      try {
        const response = await axiosInstance.get(`workingTime/${this.user_id}`);
        this.workingTimes = response.data.data;
      } catch (error) {
        console.error('Error fetching working times:', error);
      }
    },
      
    toggleCreateForm() {
      this.isCreating = !this.isCreating;
      this.isEditing = false; 
      this.resetForm();
    },

    cancelForm() {
      this.resetForm();
      this.isCreating = false;
      this.isEditing = false;
    },

    async createWorkingTime() {
      try {
        const workingTimeData = {
          working_time: this.currentWorkingTime
        };
        const response = await axiosInstance.post(`workingTime/${this.user_id}`, workingTimeData);
        this.workingTimes.push(response.data);
        this.resetForm();
        console.log('Working time created successfully');
      } catch (error) {
        console.error('Error creating working time:', error);
      }
    },

    async updateWorkingTime() {
      try {
        const workingTimeData = {
          working_time: this.currentWorkingTime 
        };
        const response = await axiosInstance.put(`workingTime/${this.currentWorkingTime.id}`, workingTimeData);

        const index = this.workingTimes.findIndex(wt => wt.id === this.currentWorkingTime.id);
        if (index !== -1) {
          this.workingTimes[index] = response.data;
        }

        this.resetForm();
        console.log('Working time updated successfully');
      } catch (error) {
        console.error('Error updating working time:', error);
      }
    },

    async deleteWorkingTime(id) {
      try {
        await axiosInstance.delete(`workingTime/${id}`);
        this.workingTimes = this.workingTimes.filter(wt => wt.id !== id);
        console.log('Working time deleted successfully');
      } catch (error) {
        console.error('Error deleting working time:', error);
      }
    },

    editWorkingTime(time) {
      this.currentWorkingTime = { ...time };
      this.isEditing = true;
    },

    cancelEdit() {
      this.resetForm();
    },

    resetForm() {
      this.currentWorkingTime = {
        start: '',
        end: ''
      };
      this.isEditing = false;
    }
  },
  mounted() {
    const token = localStorage.getItem('token');
    this.user_id = getUserId(token);
    this.getWorkingTimes();
  }
};
</script>

<style>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,500;0,600;0,700;1,300;1,400;1,500;1,600;1,700&display=swap');
</style>

<template>
  <div class="bg-frame rounded-xl lg:w-[50%] w-[100%] p-5">
    <div class="flex justify-between">
      <h2>Working Times {{ user_id }}</h2>
      <button v-if="!isEditing" @click="toggleCreateForm" class="rounded-lg border-2 border-secondary bg-transparent">
      Add a working time
      </button>
    </div>
    
    <div>
      <DataTable :value="workingTimes" responsiveLayout="scroll">
        <Column field="id" header="ID"></Column>
        <Column field="start" header="Start Time"></Column>
        <Column field="end" header="End Time"></Column>
        <Column header="Actions">
          <template #body="slotProps">
            <Button
              icon="pi pi-pencil"
              class="p-mr-2"
              text
              @click="editWorkingTime(slotProps.data)"
              severity="info"
            />
            <Button
              icon="pi pi-trash"
              text
              @click="deleteWorkingTime(slotProps.data.id)"
              severity="danger" />
          </template>
        </Column>
      </DataTable>

      <div v-if="isCreating || isEditing" style="margin-top: 20px;">
        <h3 style="color: white;">{{ isEditing ? 'Edit' : 'Create' }} Working Time</h3>
        <form @submit.prevent="isEditing ? updateWorkingTime() : createWorkingTime()">
          <div style="margin-bottom: 15px;">
            <input v-model="currentWorkingTime.start" type="datetime-local" required placeholder="Start Time" style="width: 100%; padding: 8px;" />
          </div>

          <div style="margin-bottom: 15px;">
            <input v-model="currentWorkingTime.end" type="datetime-local" required placeholder="End Time" style="width: 100%; padding: 8px;" />
          </div>

          <div style="display: flex; gap: 10px; margin-top: 10px;">
            <button icon="pi pi-check" type="submit" class="bg-secondary text-black border-2 border-secondaryAccent hover:shadow-[0px_0px_9px_2px_#E7C9FF] transition-shadow duration-300 mt-0" >Submit</button>
            <button icon="pi pi-times" class="rounded-lg border-2 border-red bg-transparent" @click="cancelForm">Cancel</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
