import { useState } from "react";
import { TextField, IconButton, InputAdornment } from "@mui/material";
import VisibilityIcon from "@mui/icons-material/Visibility";
import VisibilityOffIcon from "@mui/icons-material/VisibilityOff";

interface Props {
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  label?: string;
  error?: boolean;
  helperText?: string;
  type?: "text" | "password" | "email";
}

export default function InputField({
  value,
  onChange,
  label,
  error,
  helperText,
  type = "text",
}: Props) {
  const [show, setShow] = useState(false);

  const isPassword = type === "password";

  return (
    <TextField
      fullWidth
      type={isPassword ? (show ? "text" : "password") : type}
      label={label}
      value={value}
      onChange={onChange}
      margin="normal"
      error={error}
      helperText={helperText}
      InputProps={{
        endAdornment: isPassword ? (
          <InputAdornment position="end">
            <IconButton onClick={() => setShow(!show)}>
              {show ? <VisibilityOffIcon /> : <VisibilityIcon />}
            </IconButton>
          </InputAdornment>
        ) : null,
      }}
    />
  );
}
