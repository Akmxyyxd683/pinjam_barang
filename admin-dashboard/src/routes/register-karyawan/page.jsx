import { useState } from "react";
import axios from "axios";
import { Footer } from "@/layouts/footer";

const RegisterKaryawanPage = () => {
    const [form, setForm] = useState({
        name: "",
        profile_img: "",
        role: "karyawan",
        no_telp: "",
        alamat: "",
        email: "",
        password: "",
    });
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");

    const handleChange = (e) => {
        setForm({ ...form, [e.target.name]: e.target.value });
    };

    const handleFileChange = (e) => {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                setForm((prev) => ({ ...prev, profile_img: reader.result }));
            };
            reader.readAsDataURL(file);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setError("");
        setSuccess("");
        try {
            const payload = {
                name: form.name,
                profile_img: form.profile_img,
                role: form.role,
                no_telp: form.no_telp,
                alamat: form.alamat,
                email: form.email,
                password: form.password,
            };
            await axios.post("http://localhost:3000/auth/register", payload);
            setSuccess("Karyawan berhasil didaftarkan");
            setForm({
                name: "",
                profile_img: "",
                role: "karyawan",
                no_telp: "",
                alamat: "",
                email: "",
                password: "",
            });
            e.target.reset();
        } catch (err) {
            setError(err.response?.data?.message || "Pendaftaran gagal");
        }
    };

    return (
        <div className="max-w-lg">
            <h1 className="title mb-4">Register Karyawan</h1>
            {error && <p className="mb-2 text-sm text-red-500">{error}</p>}
            {success && <p className="mb-2 text-sm text-green-500">{success}</p>}
            <form
                onSubmit={handleSubmit}
                className="card gap-y-3"
            >
                <input
                    type="text"
                    name="name"
                    placeholder="Nama"
                    value={form.name}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                />
                <input
                    type="file"
                    accept="image/*"
                    onChange={handleFileChange}
                    className="w-full rounded border p-2"
                    required
                />
                <select
                    name="role"
                    value={form.role}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                >
                    <option
                        value=""
                        disabled
                    >
                        Pilih Role
                    </option>
                    <option value="karyawan">Karyawan</option>
                    <option value="admin">Admin</option>
                </select>
                <input
                    type="text"
                    name="no_telp"
                    placeholder="No. Telp"
                    value={form.no_telp}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                />
                <input
                    type="text"
                    name="alamat"
                    placeholder="Alamat"
                    value={form.alamat}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                />
                <input
                    type="email"
                    name="email"
                    placeholder="Email"
                    value={form.email}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                />
                <input
                    type="password"
                    name="password"
                    placeholder="Password"
                    value={form.password}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                />
                <button
                    type="submit"
                    className="rounded bg-blue-600 py-2 text-white"
                >
                    Daftarkan
                </button>
            </form>
            <Footer />
        </div>
    );
};

export default RegisterKaryawanPage;
