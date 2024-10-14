
<template>
    <div id="WorkingTime">
      <h2 v-if="!isEditing">Create Working Time</h2>
      <h2 v-if="isEditing">Edit Working Time</h2>
  
      <form @submit.prevent="isEditing ? updateWorkingTime() : createWorkingTime()">
        <label for="start_time">Start Time:</label>
        <input type="datetime-local" id="start_time" v-model="workingTime.start_time" required>
        
        <label for="end_time">End Time:</label>
        <input type="datetime-local" id="end_time" v-model="workingTime.end_time" required>
        <button type="submit">{{ isEditing ? 'Update' : 'Create' }}</button>
        <button v-if="isEditing" @click.prevent="deleteWorkingTime">Delete</button>
      </form>
    </div>
  </template>
  

<script>
import axiosInstance from '../../axios.js';
export default {
  name: 'WorkingTime',
  data() {
    return {
      workingTime: {
        start_time: '',
        end_time: ''
      },
      isEditing: true,
    };
  },
  methods: {
    formatDateTime(datetime) {
      return datetime.replace('T', ' ') + ':00';
    },
    createWorkingTime() {
      const { user_id } = this.$route.params;

      const formattedStartTime = this.formatDateTime(this.workingTime.start_time);
      const formattedEndTime = this.formatDateTime(this.workingTime.end_time);

      axiosInstance.post(`/workingTime/${user_id}`, {
        working_time: {
          start: formattedStartTime,
          end: formattedEndTime
        }
      })
        .then(response => {
          console.log('WorkingTime created:', response.data);
        })
        .catch(error => {
          console.error('Error creating WorkingTime:', error);
        });
    },





    
    updateWorkingTime() {
  const id= 22;  
  const formattedStartTime = this.formatDateTime(this.workingTime.start_time);
  const formattedEndTime = this.formatDateTime(this.workingTime.end_time);

  axiosInstance.put(`http://localhost:4000/api/workingTime/${id}`, {
    working_time: {
      start: formattedStartTime,
      end: formattedEndTime
    }
  })
  .then(response => {
    console.log('Update successful', response.data);
  })
  .catch(error => {
    console.log('Error updating', error);
  });
},
deleteWorkingTime() {
  const id = 22;  

  axiosInstance.delete(`http://localhost:4000/api/workingTime/${id}`)
    .then(response => {
      console.log('WorkingTime deleted successfully:', response.data);
    })
    .catch(error => {
      console.error('Error deleting WorkingTime:', error);
    });
}


},

mounted() {

}

}


</script>



<style scoped>
</style>