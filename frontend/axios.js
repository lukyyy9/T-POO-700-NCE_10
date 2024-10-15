import axios from 'axios';

const axiosInstance = axios.create({
    baseURL: 'http://54.162.10.55:4000/api/',
    headers: {
        'Content-Type': 'application/json'
    }
});

export default axiosInstance;