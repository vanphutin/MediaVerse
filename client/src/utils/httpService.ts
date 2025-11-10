import axiosClient from "./axiosClient";
import { TOKEN_KEY } from "@/utils/constants";

class HttpService {
  constructor() {
    this.setupInterceptors();
  }

  setupInterceptors() {
    // ✅ REQUEST
    axiosClient.interceptors.request.use((config) => {
      const token = localStorage.getItem(TOKEN_KEY);
      if (token) config.headers.Authorization = `Bearer ${token}`;
      return config;
    });

    // ✅ RESPONSE
    axiosClient.interceptors.response.use(
      (response) => {
        // FE chỉ nhận response.data
        return response.data;
      },
      (error) => {
        const status = error.response?.status;

        if (status === 401) {
          localStorage.removeItem(TOKEN_KEY);
          window.location.href = "/login";
        }

        return Promise.reject(error.response?.data || error);
      }
    );
  }

  // ======================
  // ✅ GET
  // ======================
  get(url: string, params?: any) {
    return axiosClient.get(url, { params });
  }

  // ======================
  // ✅ POST
  // ======================
  post(url: string, data?: any) {
    return axiosClient.post(url, data);
  }

  // ======================
  // ✅ PUT
  // ======================
  put(url: string, data?: any) {
    return axiosClient.put(url, data);
  }

  // ======================
  // ✅ DELETE
  // ======================
  delete(url: string) {
    return axiosClient.delete(url);
  }
}

export const httpService = new HttpService();
