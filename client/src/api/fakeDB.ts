export interface User {
  user_id: number;
  username: string;
  email: string;
  password: string;
  avatar_url: string;
  role: "NORMAL" | "VIP" | "ADMIN";
  status: "ACTIVE" | "BANNED";
  created_at: string;
  last_login: string | null;
  bio?: string;
  location?: string;
  website?: string;
}

export const FakeUsers: User[] = [
  {
    user_id: 1,
    username: "demo",
    email: "demo@gmail.com",
    password: "123456",
    avatar_url:
      "https://kimi-web-img.moonshot.cn/img/wallpapers.com/c23297985670466ca60cd05bd9122fbfff6797b1.jpg",
    role: "NORMAL",
    status: "ACTIVE",
    created_at: new Date().toISOString(),
    last_login: null,
    bio: "",
    location: "",
    website: "",
  },
];
