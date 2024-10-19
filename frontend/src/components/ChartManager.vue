<template>
  <div id="ChartManager" class="">
    <div class="flex justify-between m-2">
      <h2 class="text-left text-[25px] font-bold text-white ">Statistics for User {{ userId }}</h2>
      <button class="mt-0 border-[#DBADFF] border-[2px] drop-shadow-xl hover:shadow-[0px_0px_9px_2px_#FFEFB7] transition-shadow duration-300 text-white">Go to Profil</button>
    </div>
    <div class="flex justify-center gap-36  p-5">
      <Chart class=" flex justify-center " type="bar" :data="chartDailyData" :options="chartDailyOptions" style="width: 500px; height: 200px;" /> <!-- Daily Chart -->
      <Chart class="flex justify-center " type="bar" :data="chartWeeklyData" :options="chartWeeklyOptions" style="width: 500px; height: 200px;" />
    </div>
    <div class="flex justify-center items-center gap-36">
      <Chart class="flex justify-center" type="bar" :data="chartBarData" :options="chartOptions" style="width: 500px; height: 200px;" />
      <div class="flex justify-center items-center gap-2">
      <Chart class="flex justify-center" type="doughnut" :data="chartPieData" :options="chartPieOptions" style="width: 300px; height: 300px;" />
      <p class="text-[rgba(255,255,255,0.8)] text-[20px] font-Inter font-extralight text-right">Attendance Rates<br/> By Month %</p>
    </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue';
import { useRoute } from 'vue-router';
import axiosInstance from '../../axios.js';
// import { Title } from 'chart.js';

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

function getChartOptions(title) {
  return {
  responsive: true,
      plugins: {
        legend: { display: false },
        title: { 
          display: true, 
          text: title, 
          color: 'white',
          font: {
            family: 'Inter',
            size: 20,
            weight: 'lighter',
          },
        },
      },
      scales: {
        x: {
          ticks: {
            color: 'white',
            font: {
              family: 'Inter',
              size: 9,
              weight: 'lighter',
            },
          },
          grid: {
            color: 'rgba(255, 255, 255, 0.1)'
          },
        },
        y: {
          ticks: {
            color: 'white',
            font: {
              family: 'Inter',
              size: 9,
              weight: 'lighter',
            },
          },
          grid: {
            color: 'rgba(255, 255, 255, 0.1)'
          },
        },
      },
};
}

function createDataset (label, backgroundColor, borderColor) {
  return {
    label: label,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: 2,
          hoverBackgroundColor: borderColor,
          hoverBorderColor: '#ffffff',
          data: []
  };

}

export default {
  setup() {
    const route = useRoute();
    const userId = route.params.user_id;

    //Chart TOTAL WORKING HOURS BY DAY
    const chartDailyData = ref({
      labels: [],
      datasets: [createDataset('Total Working Hours by Day', 'rgba(219, 173, 255, 0.2)', 'rgba(219, 173, 255, 1)')]
    });
    const chartDailyOptions = ref(getChartOptions('Total Working Hours by Day'));

    //Chart TOTAL WORKING HOURS BY WEEK
    const chartWeeklyData = ref({
      labels: [],
      datasets: [createDataset('Total Working Hours by Week', 'rgba(255, 156, 216, 0.3)', 'rgba(255, 156, 216, 1)')]
    });
    const chartWeeklyOptions = ref(getChartOptions('Total Working Hours by Week'));

//Chart TOTAL WORKING HOURS BY MONTH
    const chartBarData = ref({
      labels: [],
      datasets: [createDataset('Total Working Hours by Month', 'rgba(255, 221, 103, 0.2)', 'rgba(255, 221, 103, 1)')]
    });
    const chartOptions = ref(getChartOptions('Total Working Hours by Month'));
    
    // Chart DOUGHNUT ATTENDANCE RATES BY MONTH
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
        // backgroundColor: [
        //   'rgb(255, 0, 0)',
        //   'rgb(54, 162, 235)',
        //   'rgb(0,255,0)',
        //   'rgb(255, 165, 0)',
        //   'rgb(128, 0, 128)',
        //   'rgb(0,255,255)',
        //   'rgb(255,0,255)',
        //   'rgb(255,255,0)',
        //   'rgb(0,255,0)',
        //   'rgb(255,192,203)',
        //   'rgb(0,128,128)',
        //   'rgb(165,42,42)'
        // ],
        backgroundColor: [
          'rgba(255, 220, 103, 0.4)',
          'rgba(255, 156, 216, 0.4)',
          'rgba(219, 173, 255, 0.4)',
          'rgba(102, 204, 255, 0.4)',
          'rgba(255, 153, 102, 0.4)',
          'rgba(153, 255, 153, 0.4)',
          'rgba(0, 144, 255, 0.4)',
          'rgba(255, 102, 204, 0.4)',
          'rgba(204, 102, 255, 0.4)',
          'rgba(102, 255, 204, 0.4)',
          'rgba(255, 102, 102, 0.4)',
          'rgba(102, 255, 153, 0.4)'
        ],
        borderColor: [
          'rgba(255, 220, 103, 1)',
          'rgba(255, 156, 216, 1)',
          'rgba(219, 173, 255, 1)',
          'rgba(102, 204, 255, 1)',
          'rgba(255, 153, 102, 1)',
          'rgba(153, 255, 153, 1)',
          'rgba(0, 144, 255, 1)',
          'rgba(255, 102, 204, 1)',
          'rgba(204, 102, 255, 1)',
          'rgba(102, 255, 204, 1)',
          'rgba(255, 102, 102, 1)',
          'rgba(102, 255, 153, 1)'
        ],
        borderWidth: 2, 
        spacing: 15,
        hoverOffset: 35,
        hoverBackgroundColor: [
          'rgba(255, 220, 103, 1)',
          'rgba(255, 156, 216, 1)',
          'rgba(219, 173, 255, 1)',
          'rgba(102, 204, 255, 1)',
          'rgba(255, 153, 102, 1)',
          'rgba(153, 255, 153, 1)',
          'rgba(0, 144, 255, 1)',
          'rgba(255, 102, 204, 1)',
          'rgba(204, 102, 255, 1)',
          'rgba(102, 255, 204, 1)',
          'rgba(255, 102, 102, 1)',
          'rgba(102, 255, 153, 1)'
        ],
      }]
    });
        const chartPieOptions = ref({
      responsive: true,
      plugins: {
        legend: { 
          position: 'right',
          labels: {
            color: 'white',
            font: {
              family: 'Inter',
              size: 12,
              weight: 'lighter',
            }
          }
        },
        title: { 
          display: false,
          position: 'right', 
          text: 'Attendance Rates By Month %',
          color: 'white',
          font: {
            family: 'Inter',
            size: 20,
            weight: 'lighter',
        }
      }
  }});

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

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,500;1,600&family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&display=swap');
</style>