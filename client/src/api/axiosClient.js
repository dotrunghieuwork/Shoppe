import axios from 'axios';

// Tạo axios instance với cấu hình chung cho cả nhóm
const axiosClient = axios.create({
  baseURL: 'http://localhost:5000', // Đường dẫn đến Flask BE
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor cho request
axiosClient.interceptors.request.use(
  (config) => {
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Interceptor cho response
axiosClient.interceptors.response.use(
  (response) => {
    return response.data;
  },
  (error) => {
    console.error('API Error:', error);
    return Promise.reject(error);
  }
);

export default axiosClient;