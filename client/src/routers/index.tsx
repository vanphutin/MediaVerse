import AuthPage from "@/pages/AuthPage";
import HomePage from "@/pages/HomePage";
import { createBrowserRouter, Outlet } from "react-router-dom";

const AuthLayout = () => <Outlet />;

export default createBrowserRouter([
  {
    element: <AuthLayout />,
    children: [
      { path: "/", element: <HomePage /> },
      { path: "/auth", element: <AuthPage /> },
    ],
  },
]);
