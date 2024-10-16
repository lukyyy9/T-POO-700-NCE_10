<script>
import axiosInstance from '../../axios.js';


export default {
  props: ['user_id'],
  data() {
    return {
      workingTimes: [],
      currentWorkingTime: {
        start: '',
        end: ''
      },
      isCreating: false,
      isEditing: false
    };
  },
  methods: {
    async getWorkingTimes() {
      if (!this.user_id) {
        console.error('No user_id provided');
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
}

,
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
    this.getWorkingTimes();
  }
};
</script>

<template>
  <div>
    <h2 class="text-center font-bold mb-8">Working Times for User {{ user_id }}</h2>




    <DataTable :value="workingTimes" showGridlines responsiveLayout="scroll">
      
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
            severity="danger"
          />
        </template>
      </Column>
    </DataTable>

 
 <Button v-if="!isEditing" icon="pi pi-plus" class="p-mt-2" @click="toggleCreateForm" />


<div v-if="isCreating || isEditing">
  <h3>{{ isEditing ? 'Edit' : 'Create' }} Working Time</h3>
  <form @submit.prevent="isEditing ? updateWorkingTime() : createWorkingTime()">
    <input v-model="currentWorkingTime.start" type="datetime-local" required placeholder="Start Time" />
    <input v-model="currentWorkingTime.end" type="datetime-local" required placeholder="End Time" />
    <Button label="Submit" icon="pi pi-check" type="submit" class="p-mt-2" />
    <Button label="Cancel" icon="pi pi-times" class="p-button-secondary p-ml-2" @click="cancelForm" />
  </form>
</div>
</div>
</template>

