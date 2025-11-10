import { login } from "@/api/fakeApi";
import AuthBox from "@/components/Auth/AuthBox";
import LoginForm from "@/components/Auth/LoginForm";
import { LoginPayload } from "@/styles/auth";
import React, { useState } from "react";

const AuthPage = () => {
  const [form, setForm] = useState<LoginPayload>({
    email: "",
    password: "",
  });
  const [error, setError] = useState<String>("");
  const handleLogin = async () => {
    if (!form.email || !form.password) {
      alert("Missing email or password");
      return;
    }
    try {
      const res = await login(form);
      console.log("res", res);
    } catch (error: any) {
      setError(error);
    }
  };
  return (
    <div>
      <AuthBox>
        <LoginForm form={form} onSubmit={handleLogin} setForm={setForm} />
      </AuthBox>
    </div>
  );
};

export default AuthPage;
