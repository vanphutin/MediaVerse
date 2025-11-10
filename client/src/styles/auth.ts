import { User } from "./user";

export interface LoginPayload {
  email: string;
  password: string;
}

export interface LoginResponse {
  token: string;
  user: User;
}

export interface RegisterPayload {
  username: string;
  email: string;
  password: string;
}
