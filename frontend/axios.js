import axios from 'axios';

const isAndroid = /Android/i.test(navigator.userAgent);
const baseURL = isAndroid && import.meta.env.VITE_AXIOSBASEURL_ANDROID 
    ? import.meta.env.VITE_AXIOSBASEURL_ANDROID 
    : import.meta.env.VITE_AXIOSBASEURL;

const axiosInstance = axios.create({
    baseURL: baseURL,
    headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${localStorage.getItem('token')}`
    }
});

export default axiosInstance;