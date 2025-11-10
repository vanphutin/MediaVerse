// ========================
// ✅ APP CONFIG
// ========================
export const APP_NAME = "StreamHub FE";
export const TOKEN_KEY = "access_token";

// ========================
// ✅ API CONFIG
// ========================
export const API_BASE_URL =
  import.meta.env.VITE_API_URL || "http://localhost:4000/api";

export const AXIOS_TIMEOUT = 10000; // 10s
export const MAX_UPLOAD_SIZE = 10 * 1024 * 1024; // 10MB

// ========================
// ✅ USER ROLES (đồng bộ backend)
// ========================
export enum ROLE {
  NORMAL = "NORMAL",
  VIP = "VIP",
  ADMIN = "ADMIN",
}

// ========================
// ✅ USER STATUS
// ========================
export enum STATUS {
  ACTIVE = "ACTIVE",
  BANNED = "BANNED",
}

// ========================
// ✅ ROUTES
// ========================
export const ROUTES = {
  HOME: "/",
  LOGIN: "/login",
  REGISTER: "/register",
  PROFILE: "/profile",
  ADMIN: "/admin",
  PLAYER: "/player/:id",
};

// ========================
// ✅ Fake Delay (nếu dùng FAKE API)
// ========================
export const FAKE_DELAY = {
  SHORT: 300,
  MEDIUM: 700,
  LONG: 1200,
};

// ========================
// ✅ Default Avatar
// ========================
export const DEFAULT_AVATAR =
  "https://kimi-web-img.moonshot.cn/img/wallpapers.com/c23297985670466ca60cd05bd9122fbfff6797b1.jpg";
