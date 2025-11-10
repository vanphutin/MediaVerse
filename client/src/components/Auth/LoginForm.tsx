import { Box, Typography, TextField, Button } from "@mui/material";
import { useState } from "react";

interface Props {
  form: {
    email: string;
    password: string;
  };
  setForm: React.Dispatch<React.SetStateAction<any>>;
  onSubmit: () => void;
}

export default function LoginForm({ form, setForm, onSubmit }: Props) {
  const [errors, setErrors] = useState({
    email: "",
    password: "",
  });

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

  return (
    <Box>
      <Typography variant="h4" fontWeight={600} mb={1}>
        Welcome Back
      </Typography>

      <Typography mb={4}>
        Enter your email and password to access your account
      </Typography>

      {/* ✅ EMAIL */}
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

      {/* ✅ PASSWORD */}
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

      {/* ✅ SUBMIT BUTTON */}
      <Button
        variant="contained"
        fullWidth
        sx={{ mt: 3, py: 1.4 }}
        onClick={handleSubmit}
      >
        Sign In
      </Button>

      <Button variant="outlined" fullWidth sx={{ mt: 2, py: 1.4 }}>
        Sign in with Google
      </Button>
    </Box>
  );
}
