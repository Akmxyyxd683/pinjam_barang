import axios from "axios";
import { useEffect, useState } from "react";
import { PencilLine, Trash } from "lucide-react";

const DaftarBarangPage = () => {
    const [barang, setBarang] = useState([]);
    const [loading, setLoading] = useState(true);
    const [deletingId, setDeletingId] = useState(null);
    const [error, setError] = useState("");

    const fetchItems = async () => {
        setLoading(true);
        setError("");
        try {
            const res = await axios.get("http://localhost:3000/items");
            setBarang(res.data?.data || []);
        } catch (e) {
            setBarang([]);
            setError("Gagal memuat data barang");
        } finally {
            setLoading(false);
        }
    };

    useEffect(() => {
        fetchItems();
    }, []);

    const handleDelete = async (id) => {
        if (!id && id !== 0) return;
        const ok = window.confirm(`Yakin hapus item dengan ID ${id}?`);
        if (!ok) return;

        setDeletingId(id);
        setError("");

        const prev = barang;
        setBarang((curr) => curr.filter((b) => b.id !== id));

        try {
            await axios.delete(`http://localhost:3000/items/${id}`);
        } catch (e) {
            setBarang(prev);
            setError(e.response?.data?.message || "Gagal menghapus item");
        } finally {
            setDeletingId(null);
        }
    };

    const formatDate = (d) => {
        if (!d) return "-";
        const date = new Date(d);
        if (isNaN(date.getTime())) return d;

        return date.toLocaleDateString("id-ID", {
            year: "numeric",
            month: "long",
            day: "numeric",
        });
    };

    return (
        <div className="flex flex-col gap-y-4">
            <h1 className="title">Daftar Barang</h1>

            {error && <div className="rounded-md bg-red-50 px-3 py-2 text-sm text-red-600">{error}</div>}

            <div className="card">
                <div className="card-header">
                    <p className="card-title">Data Product</p>
                </div>
                <div className="card-body p-0">
                    <div className="relative h-[500px] w-full flex-shrink-0 overflow-auto rounded-none [scrollbar-width:_thin]">
                        {loading ? (
                            <div className="m-4 h-6 w-6 animate-spin rounded-full border-2 border-blue-500 border-t-transparent" />
                        ) : (
                            <table className="table">
                                <thead className="table-header">
                                    <tr className="table-row">
                                        <th className="table-head">ID</th>
                                        <th className="table-head">Barang</th>
                                        <th className="table-head">Dibuat pada tanggal</th>
                                        <th className="table-head">Status</th>
                                        <th className="table-head">Actions</th>
                                    </tr>
                                </thead>
                                <tbody className="table-body">
                                    {barang.map((item) => (
                                        <tr
                                            key={item.id}
                                            className="table-row"
                                        >
                                            <td className="table-cell py-2">{item.id}</td>
                                            <td className="table-cell py-2">
                                                <div className="flex w-max gap-x-4">
                                                    <img
                                                        src={item.img_url}
                                                        alt={item.name || "gambar barang"}
                                                        className="size-14 rounded-lg object-cover"
                                                    />
                                                    <div className="flex flex-col">
                                                        <p>{item.name}</p>
                                                        <p className="text-sm font-normal text-slate-600 dark:text-slate-400">
                                                            {item.category?.type}
                                                        </p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td className="table-cell py-2">{formatDate(item.create_at)}</td>
                                            <td className="table-cell py-2">{item.status}</td>
                                            <td className="table-cell py-2">
                                                <div className="flex items-center gap-x-4">
                                                    <button
                                                        type="button"
                                                        className="text-blue-500 dark:text-blue-600"
                                                        title="Edit"
                                                        aria-label={`Edit item ${item.id}`}
                                                        // onClick={() => navigate(`/items/${item.id}/edit`)}
                                                    >
                                                        <PencilLine size={20} />
                                                    </button>

                                                    <button
                                                        type="button"
                                                        className={`text-red-500 ${deletingId === item.id ? "opacity-50" : ""}`}
                                                        title="Hapus"
                                                        aria-label={`Hapus item ${item.id}`}
                                                        onClick={() => handleDelete(item.id)}
                                                        disabled={deletingId === item.id}
                                                    >
                                                        <Trash size={20} />
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    ))}

                                    {barang.length === 0 && (
                                        <tr>
                                            <td
                                                colSpan={5}
                                                className="py-6 text-center text-sm text-slate-500"
                                            >
                                                Tidak ada data.
                                            </td>
                                        </tr>
                                    )}
                                </tbody>
                            </table>
                        )}
                    </div>
                </div>
            </div>
        </div>
    );
};

export default DaftarBarangPage;
