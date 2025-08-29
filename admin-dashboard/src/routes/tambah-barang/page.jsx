import axios from "axios";
import { useEffect, useState } from "react";
import { Footer } from "@/layouts/footer";

const TambahBarangPage = () => {
    const [form, setForm] = useState({
        id: null,
        category_id: null,
        name: "",
        img_url: "",
        create_at: new Date(),
        status: "",
    });

    const toYMD = (value) => {
        if (!value) return "";
        const d = value instanceof Date ? value : new Date(value);
        if (isNaN(d.getTime())) return "";
        return d.toISOString().slice(0, 10);
    };
    const [error, setError] = useState("");
    const [success, setSuccess] = useState("");

    const handleChange = async (e) => {
        const { name, value } = e.target;

        setForm((prev) => ({
            ...prev,
            [name]:
                name === "id" || name === "category_id"
                    ? value === ""
                        ? null
                        : Number(value)
                    : name === "create_at"
                      ? value
                          ? new Date(value)
                          : null
                      : value,
        }));
    };

    const handleFileChange = async (e) => {
        const file = e.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                setForm((prev) => ({ ...prev, img_url: reader.result }));
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
                id: form.id,
                category_id: form.category_id,
                name: form.name,
                img_url: form.img_url,
                create_at: form.create_at,
                status: form.status,
            };
            await axios.post("http://localhost:3000/items/add", payload);
            setSuccess("barang berhasil didaftarkan");
            setForm({
                id: null,
                category_id: null,
                name: "",
                img_url: "",
                create_at: new Date(),
                status: "",
            });
            e.target.reset();
        } catch (err) {
            setError(err.response?.data?.message || "Menambahkan data gagal");
        }
    };

    return (
        <div className="max-w-lg">
            <h1 className="title mb-4">Tambah Data Barang</h1>
            {error && <p className="mb-2 text-sm text-red-500">{error}</p>}
            {success && <p className="mb-2 text-sm text-green-500">{success}</p>}
            <form
                onSubmit={handleSubmit}
                className="card gap-y-3"
            >
                <input
                    type="number"
                    name="id"
                    placeholder="id"
                    value={form.id}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                />
                <input
                    type="number"
                    name="category_id"
                    placeholder="Category-id"
                    value={form.category_id}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                />
                <input
                    type="text"
                    name="name"
                    placeholder="Nama barang"
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
                <input
                    type="date"
                    value={toYMD(form.create_at)}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                />
                <select
                    name="status"
                    value={form.status}
                    onChange={handleChange}
                    className="w-full rounded border p-2"
                    required
                >
                    <option
                        value=""
                        disabled
                    >
                        Pilih Status
                    </option>
                    <option value="available">available</option>
                    <option value="Not available">Not available</option>
                </select>
                <button
                    type="submit"
                    className="rounded bg-blue-600 py-2 text-white"
                >
                    Tambahkan
                </button>
            </form>
            <Footer />
        </div>
    );
};

export default TambahBarangPage;
