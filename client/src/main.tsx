import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App";
import { CssBaseline } from "@mui/material";
// import "@/i18n/index";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <CssBaseline />
    <App />
  </StrictMode>
);
