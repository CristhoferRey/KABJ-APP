import axios from 'axios';

import { env } from '../config/env';
import { authService } from './auth';

export const api = axios.create({
  baseURL: env.apiBaseUrl,
});

api.interceptors.request.use((config) => {
  const token = authService.getToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      authService.clearToken();
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);
