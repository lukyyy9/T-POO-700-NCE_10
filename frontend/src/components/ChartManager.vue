<template>
  <div>
    <h2 class="text-center font-bold mb-8">Statistics for User {{ userId }}</h2>

    <Chart type="bar" :data="chartBarData" :options="chartOptions" style="width: 600px; height: 400px;" />
    <Chart type="bar" :data="chartWeeklyData" :options="chartWeeklyOptions" style="width: 600px; height: 400px;" />
    <Chart type="bar" :data="chartDailyData" :options="chartDailyOptions" style="width: 600px; height: 400px;" /> <!-- Daily Chart -->
    <Chart type="doughnut" :data="chartPieData" :options="chartPieOptions" style="width: 600px; height: 400px;" />
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import axiosInstance from '../../axios.js';

function getWorkingDaysInMonth(year, month) {
  let workingDays = 0;
  const date = new Date(year, month, 1);
  while (date.getMonth() === month) {
    const dayOfWeek = date.getDay();
    if (dayOfWeek !== 0 && dayOfWeek !== 6) {
      workingDays++;
    }
    date.setDate(date.getDate() + 1);
  }
  return workingDays;
}

function getWeekNumber(date) {
  const startDate = new Date(date.getFullYear(), 0, 1);
  const days = Math.floor((date - startDate) / (24 * 60 * 60 * 1000));
  return Math.ceil((days + startDate.getDay() + 1) / 7);
}

export default {
  setup() {
    const route = useRoute();
    const userId = route.params.user_id;

    const chartBarData = ref({
      labels: [],
      datasets: [
        {
          label: 'Total Working Hours',
          backgroundColor: '#42A5F5',
          data: []
        }
      ]
    });

    const chartWeeklyData = ref({
      labels: [],
      datasets: [
        {
          label: 'Total Working Hours by Week',
          backgroundColor: '#FF6384',
          data: []
        }
      ]
    });

    const chartDailyData = ref({
      labels: [], // Updated to store specific dates in the week
      datasets: [
        {
          label: 'Total Working Hours by Day',
          backgroundColor: '#FFCE56',
          data: []
        }
      ]
    });

    const chartPieData = ref({
      labels: [
        'Red',
        'Blue',
        'Green',
        'Orange',
        'Purple',
        'Cyan',
        'Magenta',
        'Yellow',
        'Lime',
        'Pink',
        'Teal',
        'Brown'
      ],
      datasets: [{
        label: 'Attendance rates',
        data: [],
        backgroundColor: [
          'rgb(255, 0, 0)',
          'rgb(54, 162, 235)',
          'rgb(0,255,0)',
          'rgb(255, 165, 0)',
          'rgb(128, 0, 128)',
          'rgb(0,255,255)',
          'rgb(255,0,255)',
          'rgb(255,255,0)',
          'rgb(0,255,0)',
          'rgb(255,192,203)',
          'rgb(0,128,128)',
          'rgb(165,42,42)'
        ],
        hoverOffset: 4
      }]
    });

    const chartOptions = ref({
      responsive: true,
      plugins: {
        legend: { position: 'top' },
        title: { display: true, text: 'Total Working Hours per Month' }
      }
    });

    const chartWeeklyOptions = ref({
      responsive: true,
      plugins: {
        legend: { position: 'top' },
        title: { display: true, text: 'Total Working Hours per Week' }
      }
    });

    const chartDailyOptions = ref({
      responsive: true,
      scales: {
        x: {
          title: {
            display: true,
            text: 'Days of the Week'
          }
        },
        y: {
          title: {
            display: true,
            text: 'Hours Worked'
          }
        }
      },
      plugins: {
        legend: { position: 'top' },
        title: { display: true, text: 'Total Working Hours by Day' }
      }
    });

    const chartPieOptions = ref({
      responsive: true,
      plugins: {
        legend: { position: 'top' },
        title: { display: true, text: 'Attendance rates per Month %' }
      }
    });

    const fetchWorkingTimes = async () => {
      try {
        const response = await axiosInstance.get(`workingTime/${userId}`);
        const workingTimes = response.data.data;

        const monthHours = {};
        const weekHours = {};
        const dailyHours = {}; // Change to an object to store hours keyed by date
        const attendanceRates = {};

        workingTimes.forEach((time) => {
          const startDate = new Date(time.start);
          const endDate = new Date(time.end);
          const hoursWorked = (endDate - startDate) / (1000 * 60 * 60);
          const monthYear = startDate.toLocaleString('default', { month: 'short', year: 'numeric' });
          const weekNumber = getWeekNumber(startDate);
          const dayOfWeek = startDate.getDay(); // Get the day of the week (0-6)

          if (!monthHours[monthYear]) {
            monthHours[monthYear] = 0;
            attendanceRates[monthYear] = { daysWorked: 0, workingDaysInMonth: getWorkingDaysInMonth(startDate.getFullYear(), startDate.getMonth()) };
          }

          monthHours[monthYear] += hoursWorked;
          attendanceRates[monthYear].daysWorked += 1;

          // Weekly calculations
          const weekKey = `${startDate.getFullYear()}-W${weekNumber}`;
          if (!weekHours[weekKey]) {
            weekHours[weekKey] = 0;
          }
          weekHours[weekKey] += hoursWorked;

          // Daily calculations for weekdays only (Monday to Friday)
          const dayDate = startDate.toISOString().split('T')[0]; // Get the date in YYYY-MM-DD format
          if (dayOfWeek >= 1 && dayOfWeek <= 5) { // 1 is Monday, 5 is Friday
            if (!dailyHours[dayDate]) {
              dailyHours[dayDate] = 0; // Initialize if not already set
            }
            dailyHours[dayDate] += hoursWorked; // Increment the hours for that date
          }
        });

        const attendanceRatesPercentage = Object.keys(attendanceRates).map(monthYear => {
          const { daysWorked, workingDaysInMonth } = attendanceRates[monthYear];
          return ((daysWorked / workingDaysInMonth) * 100).toFixed(2);
        });

        chartBarData.value.labels = Object.keys(monthHours);
        chartBarData.value.datasets[0].data = Object.values(monthHours);

        chartWeeklyData.value.labels = Object.keys(weekHours);
        chartWeeklyData.value.datasets[0].data = Object.values(weekHours);

        // Update daily chart with specific dates in the week
        chartDailyData.value.labels = Object.keys(dailyHours);
        chartDailyData.value.datasets[0].data = Object.values(dailyHours);

        chartPieData.value.labels = Object.keys(attendanceRates);
        chartPieData.value.datasets[0].data = attendanceRatesPercentage;

      } catch (error) {
        console.error('Error fetching working times:', error);
      }
    };

    onMounted(() => {
      fetchWorkingTimes();
    });

    return {
      chartBarData,
      chartWeeklyData,
      chartDailyData,
      chartOptions,
      chartWeeklyOptions,
      chartDailyOptions,
      chartPieData,
      chartPieOptions,
      userId
    };
  }
};
</script>
