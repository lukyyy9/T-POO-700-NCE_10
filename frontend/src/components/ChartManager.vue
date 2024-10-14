<template>
    <div id="ChartManager">
        <BarChart :chartData="chartData" />
    </div>
</template>

<script>
import axiosInstance from '../../axios.js';
import BarChart from './BarChart.vue';
import moment from 'moment';

export default {
    name: 'ChartManager',
    components: { BarChart },
    data() {
        return {
            user: {},
            chartData: {
                labels: [],
                datasets: [{
                    label: 'Working Time',
                    data: [],
                    backgroundColor: 'rgba(75, 192, 192, 0.6)'
                }]
            }
        };
    },
    methods: {
        getChartData() {
            const user_id = this.$route.params.user_id;
            axiosInstance.get(`/workingTime`)
            .then(response => {
                console.log('Raw chart data:', response.data);
                
                // Process the data
                const processedData = response.data.data.map(entry => {
                const start = moment(entry.start);
                const end = moment(entry.end);
                const duration = moment.duration(end.diff(start));
                const hours = duration.asHours();
                
                return {
                    label: start.format('YYYY-MM-DD'),
                    value: parseFloat(hours.toFixed(2))
                };
                });

                // Format the data for Chart.js
                this.chartData = {
                labels: processedData.map(item => item.label),
                datasets: [{
                    label: 'Heures de travail',
                    data: processedData.map(item => item.value),
                    backgroundColor: 'rgba(75, 192, 192, 0.6)'
                }]
                };

                console.log('Formatted chart data:', this.chartData);
            })
            .catch(error => {
                console.error('There was an error getting the chart data:', error);
            });
        },
    },
    async mounted() {
        await this.getChartData();
        document.getElementById('user_id').value = this.$route.params.user_id;
    }
};
</script>

<style scoped>
</style>