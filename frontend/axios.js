import axios from 'axios';

const axiosInstance = axios.create({
    baseURL: import.meta.env.VITE_AXIOSBASEURL,
    headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
    }
});

export default axiosInstance;