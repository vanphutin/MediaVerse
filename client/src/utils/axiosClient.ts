import axios from "axios";
import { API_BASE_URL, TOKEN_KEY, AXIOS_TIMEOUT } from "@/utils/constants";

const axiosClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: AXIOS_TIMEOUT,
  headers: { "Content-Type": "application/json" },
});

export default axiosClient;
