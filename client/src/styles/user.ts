export type UserRole = "NORMAL" | "VIP" | "ADMIN";
export type UserStatus = "ACTIVE" | "BANNED";

export interface User {
  user_id: number;
  username: string;
  email: string;
  avatar_url?: string | null;
  role: UserRole;
  status: UserStatus;
  bio?: string | null;
  location?: string | null;
  website?: string | null;
  created_at: string;
  updated_at: string;
  last_login?: string | null;
}
