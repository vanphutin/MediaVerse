import { Box, Typography } from "@mui/material";
import React from "react";
import { useTranslation } from "react-i18next";
import AuthForm from "./AuthForm";
interface Props {
  form: {
    email: string;
    password: string;
  };
  error: string;
  setError: React.Dispatch<React.SetStateAction<any>>;
  setForm: React.Dispatch<React.SetStateAction<any>>;
  onSubmit: () => void;
  loading: boolean;
  mode: "login" | "register";
}

const Auth = ({
  form,
  setForm,
  onSubmit,
  error,
  setError,
  mode,
  loading,
}: Props) => {
  const { t } = useTranslation("auth");
  return (
    <Box>
      <Typography variant="h4" fontWeight={600} mb={1}>
        {mode === "login" ? t("login.welcome") : t("register.welcome")}
      </Typography>

      <Typography mb={3}>
        {mode === "login" ? t("login.describe") : t("register.title")}
      </Typography>

      {/* FORM */}
      <AuthForm
        form={form}
        onSubmit={onSubmit}
        setForm={setForm}
        error={error}
        setError={setError}
        mode={mode}
        loading={loading}
      />
    </Box>
  );
};

export default Auth;
