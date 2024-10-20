import { createApp } from 'vue';
import App from './App.vue';
import router from './router';

import './assets/main.css';
import PrimeVue from 'primevue/config';
import Aura from '@primevue/themes/aura';
import 'primeicons/primeicons.css';
import Chart from 'primevue/chart';
//import Select from 'primevue/select';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import Button from 'primevue/button';
import Noir from './presets/Noir';
import { library } from '@fortawesome/fontawesome-svg-core';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { faHouse, faPersonWalking, faPersonWalkingArrowRight, faMugSaucer, faMugHot, faXmark,faBell } from '@fortawesome/free-solid-svg-icons';

library.add(faHouse, faPersonWalking, faPersonWalkingArrowRight, faMugSaucer, faMugHot, faXmark, faBell);

const app = createApp(App);


app.use(PrimeVue, {
    theme: {
        preset: Noir,
        options: {
            prefix: 'p',
            darkModeSelector: 'system',
            cssLayer: false
        }
    }
 });


app.component('font-awesome-icon', FontAwesomeIcon);
app.component('Button', Button);
app.component('DataTable', DataTable);
app.component('Column', Column);
app.component('Chart', Chart);
//app.component('Select', Select);


app.use(router);


app.mount('#app');
