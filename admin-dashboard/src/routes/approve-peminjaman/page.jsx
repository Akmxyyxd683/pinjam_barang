import { useEffect, useState } from "react";
import axios from "axios";

const ApprovePeminjamanPage = () => {
    const [requests, setRequests] = useState([]);

    useEffect(() => {
        Promise.all([
            axios.get("http://localhost:3000/borrowing-transactions"),
            axios.get("http://localhost:3000/auth/users"),
            axios.get("http://localhost:3000/items"),
        ])
            .then(([txRes, usersRes, itemsRes]) => {
                const txData = txRes.data.data || [];
                const users = usersRes.data.data || [];
                const items = itemsRes.data.data || [];
                const formatted = txData
                    .filter((tx) => tx.status === "REQUESTED")
                    .map((tx) => {
                        const user = users.find((u) => u.id === tx.user_id);
                        const item = items.find((it) => it.id === tx.item_id);
                        return {
                            ...tx,
                            userName: user ? user.name : `User ${tx.user_id}`,
                            itemName: item ? item.nama_barang || item.name : `Item ${tx.item_id}`,
                        };
                    });
                setRequests(formatted);
            })
            .catch(() => {
                setRequests([]);
            });
    }, []);

    const handleApprove = async (id) => {
        try {
            await axios.patch(`http://localhost:3000/borrowing-transactions/${id}`, {
                status: "APPROVED",
            });
            setRequests((prev) => prev.filter((tx) => tx.id !== id));
        } catch (error) {
            console.error("Failed to approve", error);
        }
    };

    const handleReject = async (id) => {
        try {
            await axios.patch(`http://localhost:3000/borrowing-transactions/${id}`, {
                status: "REJECTED",
            });
            setRequests((prev) => prev.filter((tx) => tx.id !== id));
        } catch (error) {
            console.error("Failed to reject", error);
        }
    };

    const formatDate = (dateString) => {
        if (!dateString) return "-";
        const date = new Date(dateString);
        if (isNaN(date)) return "-";
        return date.toLocaleDateString();
    };

    return (
        <div className="flex flex-col gap-y-4">
            <h1 className="title">Approve Peminjaman</h1>
            <div className="card">
                <div className="card-body overflow-x-auto">
                    <table className="w-full table-auto">
                        <thead>
                            <tr className="text-left">
                                <th className="px-4 py-2">No</th>
                                <th className="px-4 py-2">Peminjam</th>
                                <th className="px-4 py-2">Barang</th>
                                <th className="px-4 py-2">Keterangan</th>
                                <th className="px-4 py-2">Lokasi</th>
                                <th className="px-4 py-2">Tanggal Pinjam</th>
                                <th className="px-4 py-2">Jatuh Tempo</th>
                                <th className="px-4 py-2">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {requests.map((tx, index) => (
                                <tr
                                    key={tx.id}
                                    className="border-t"
                                >
                                    <td className="px-4 py-2">{index + 1}</td>
                                    <td className="px-4 py-2">{tx.userName}</td>
                                    <td className="px-4 py-2">{tx.itemName}</td>
                                    <td className="px-4 py-2">{tx.description || "-"}</td>
                                    <td className="px-4 py-2">{tx.location || "-"}</td>
                                    <td className="px-4 py-2">{formatDate(tx.borrowed_at)}</td>
                                    <td className="px-4 py-2">{formatDate(tx.due_date)}</td>
                                    <td className="px-4 py-2">
                                        <button
                                            onClick={() => handleApprove(tx.id)}
                                            className="mb-4 w-full rounded bg-green-600 px-3 py-1 text-sm text-white hover:bg-green-700"
                                        >
                                            Approve
                                        </button>
                                        <button
                                            onClick={() => handleReject(tx.id)}
                                            className="w-full rounded bg-red-600 px-3 py-1 text-sm text-white hover:bg-red-700"
                                        >
                                            Reject
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    {requests.length === 0 && <p className="px-4 py-2 text-center text-slate-500">Tidak ada permintaan peminjaman</p>}
                </div>
            </div>
        </div>
    );
};

export default ApprovePeminjamanPage;
