<template>
    <Pie
      id="my-pie-chart-id"
      :options="chartOptions"
      :data="chartData"
    />
</template>

<script>
import { Pie } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, ArcElement} from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, ArcElement)

export default {
    name: 'PieChart',
    components: { Pie },
    props: {
        chartData: {
            type: Object,
            required: true
        }
    },
    data() {
        return {
            chartOptions: {
                responsive: true,
                plugins: {
                    legend: {
                        position:'top'
                    },
                    title: {
                        display: true,
                        text: 'Pie Chart'
                    }
                }
            }
        }
    }
}
</script>