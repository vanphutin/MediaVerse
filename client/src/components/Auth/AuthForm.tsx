import {
  Box,
  Typography,
  TextField,
  Button,
  Link,
  CircularProgress,
} from "@mui/material";
import { useEffect, useState } from "react";
import { useTranslation } from "react-i18next";
import { Link as RouterLink } from "react-router-dom";

interface Props {
  form: { email: string; password: string; confirmPassword?: string };
  setForm: React.Dispatch<React.SetStateAction<any>>;
  onSubmit: () => void;
  error: string;
  mode: "login" | "register";
  loading: boolean;
  setError: React.Dispatch<React.SetStateAction<any>>;
}

export default function AuthForm({
  form,
  setForm,
  onSubmit,
  error,
  setError,
  mode,
  loading,
}: Props) {
  const { t } = useTranslation("auth");

  const [errors, setErrors] = useState({ email: "", password: "" });

  const validate = () => {
    let valid = true;
    const newErrors = { email: "", password: "" };

    if (!form.email.trim()) {
      newErrors.email = "Email is required";
      valid = false;
    } else if (!/\S+@\S+\.\S+/.test(form.email)) {
      newErrors.email = "Invalid email format";
      valid = false;
    }

    if (!form.password.trim()) {
      newErrors.password = "Password is required";
      valid = false;
    } else if (form.password.length < 6) {
      newErrors.password = "Password must be at least 6 characters";
      valid = false;
    }

    setErrors(newErrors);
    return valid;
  };

  const handleSubmit = () => {
    if (!validate()) return;
    onSubmit();
  };

  useEffect(() => {
    setError("");

    setErrors({ email: "", password: "" });

    if (mode === "login") {
      setForm((prev: any) => ({ ...prev, confirmPassword: "" }));
    }
  }, [mode]);

  return (
    <Box>
      {error && (
        <Typography
          style={{
            color: "red",
          }}
          mb="1"
        >
          {error.trim()}
        </Typography>
      )}

      {mode === "login" && (
        <>
          <Button
            variant="outlined"
            disabled={loading}
            fullWidth
            sx={{ py: 1.4 }}
          >
            {t("login.google")}
          </Button>

          <Box
            sx={{
              display: "flex",
              alignItems: "center",
              my: 3,
              color: "#888",
              fontSize: 14,
              textTransform: "uppercase",
              letterSpacing: "0.04em",
              "&::before, &::after": {
                content: '""',
                flex: 1,
                borderBottom: "1px solid #444",
              },
              "&::before": { mr: 2 },
              "&::after": { ml: 2 },
            }}
          >
            or login with email
          </Box>
        </>
      )}

      <TextField
        fullWidth
        label="Email"
        margin="normal"
        value={form.email}
        onChange={(e) =>
          setForm((prev: any) => ({ ...prev, email: e.target.value }))
        }
        error={Boolean(errors.email)}
        helperText={errors.email}
      />

      <TextField
        fullWidth
        label="Password"
        type="password"
        margin="normal"
        value={form.password}
        onChange={(e) =>
          setForm((prev: any) => ({ ...prev, password: e.target.value }))
        }
        error={Boolean(errors.password)}
        helperText={errors.password}
      />
      {mode === "register" && (
        <TextField
          fullWidth
          label="Confirm Password"
          type="password"
          margin="normal"
          value={form.confirmPassword}
          onChange={(e) =>
            setForm((prev: any) => ({
              ...prev,
              confirmPassword: e.target.value,
            }))
          }
        />
      )}

      {mode === "login" && (
        <Link
          sx={{
            display: "flex",
            justifyContent: "end",
            color: "#4eaaff",
            fontSize: 14,
            mt: 1,
            cursor: "pointer",
            textDecoration: "none",
            "&:hover": {
              textDecoration: "underline",
            },
          }}
        >
          {t("login.forgotPass")}
        </Link>
      )}

      <Button
        variant="contained"
        fullWidth
        disabled={loading}
        sx={{ my: 2, py: 1.4, fontSize: 15 }}
        onClick={handleSubmit}
      >
        {loading ? (
          <CircularProgress size={20} />
        ) : mode === "login" ? (
          t("login.button")
        ) : (
          t("register.button")
        )}
      </Button>

      <Box
        sx={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          color: "#ccc",
          fontSize: 14,
        }}
      >
        <Typography sx={{ mr: 1 }}>
          {mode === "login" ? t("login.noAccount") : t("register.haveAccount")}
        </Typography>

        <Link
          component={RouterLink}
          to={mode === "login" ? "/auth?type=register" : "/auth?type=login"}
          sx={{
            color: "#4eaaff",
            fontSize: 15,
            cursor: "pointer",
            textDecoration: "none",
            "&:hover": { textDecoration: "underline" },
          }}
        >
          {mode === "login" ? t("login.goRegister") : t("register.goLogin")}
        </Link>
      </Box>
    </Box>
  );
}
