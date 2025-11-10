import { IconButton } from "@mui/material";
import { LightMode, DarkMode } from "@mui/icons-material";
import AuthBox from "./components/Auth/AuthBox";
import LoginForm from "./components/Auth/LoginForm";
import AuthPage from "./pages/AuthPage";

export default function App() {
  return (
    <div>
      <AuthPage />
    </div>
  );
}
