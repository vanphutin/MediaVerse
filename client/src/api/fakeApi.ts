// https://fakestoreapi.com/auth/login
// https://fakestoreapi.com/api/v1/auth/login

import { LoginPayload, LoginResponse } from "@/styles/auth";
import axiosClient from "@/utils/axiosClient";

const AUTH_API = "auth";

export const login = async (payload: LoginPayload): Promise<LoginResponse> => {
  try {
    const response = await axiosClient.post(`${AUTH_API}/login`, payload);
    return response.data;
  } catch (error) {
    throw new Error("ERROR");
  }
};
