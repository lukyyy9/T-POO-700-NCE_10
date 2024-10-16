<script>

import axiosInstance from '../../axios.js';

export default {
  props: ['user_id'],
  data() {
    return {
      workingTimes: [],
    };
  },
  methods: {
    async getWorkingTimes() {
      console.log('User ID:', this.user_id);
      if (!this.user_id) {
        console.error('No user_id provided');
        return;
      }
      try {
        const response = await axiosInstance.get(`workingTime/${this.user_id}`);
        console.log('Raw response:', response.data);
        this.workingTimes = response.data.data; // Assuming the working times are in a 'data' property
        console.log('Parsed working times:', this.workingTimes);
      } catch (error) {
        console.error('Error fetching working times:', error);
        if (error.response) {
          // The request was made and the server responded with a status code
          // that falls out of the range of 2xx
          console.error('Error data:', error.response.data);
          console.error('Error status:', error.response.status);
          console.error('Error headers:', error.response.headers);
        } else if (error.request) {
          // The request was made but no response was received
          console.error('Error request:', error.request);
        } else {
          // Something happened in setting up the request that triggered an Error
          console.error('Error message:', error.message);
        }
      }
    },
  },
  mounted() {
    this.getWorkingTimes();
  },
};

</script>

<template>
  <div>
    <h2>Working Times for User {{ user_id }}</h2>
    <table v-if="workingTimes.length > 0">
      <thead>
        <tr>
          <th>ID</th>
          <th>Start Time</th>
          <th>End Time</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="time in workingTimes" :key="time.id">
          <td>{{ time.id }}</td>
          <td>{{ time.start }}</td>
          <td>{{ time.end }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

