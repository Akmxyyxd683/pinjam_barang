import { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import { useAuth } from "@/contexts/auth-context";
import warungData from "@/assets/wd-logo.png";

const LoginPage = () => {
    const { login } = useAuth();
    const navigate = useNavigate();
    const [form, setForm] = useState({ email: "", password: "" });
    const [error, setError] = useState("");

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const res = await axios.post("http://localhost:3000/auth/login", form);
            login(res.data.data);
            navigate("/");
        } catch (err) {
            setError(err.response?.data?.message || "Login failed");
        }
    };

    return (
        <div className="flex min-h-screen items-center justify-center bg-slate-100 dark:bg-slate-950">
            <form
                onSubmit={handleSubmit}
                className="w-full max-w-sm rounded bg-white p-6 shadow dark:bg-slate-900"
            >
                <img
                    src={warungData}
                    alt="warungdata"
                    className="mb-5 flex h-12 w-24 items-center justify-center"
                />
                <p className="mb-2 text-lg font-medium text-slate-900 transition-colors dark:text-slate-50">Warung Data</p>
                {error && <p className="mb-2 text-sm text-red-500">{error}</p>}
                <input
                    type="text"
                    placeholder="Email"
                    value={form.email}
                    onChange={(e) => setForm({ ...form, email: e.target.value })}
                    className="mb-3 w-full rounded border p-2"
                    required
                />
                <input
                    type="password"
                    placeholder="Password"
                    value={form.password}
                    onChange={(e) => setForm({ ...form, password: e.target.value })}
                    className="mb-4 w-full rounded border p-2"
                    required
                />
                <button
                    type="submit"
                    className="w-full rounded bg-blue-600 py-2 text-white"
                >
                    Login
                </button>
            </form>
        </div>
    );
};

export default LoginPage;
