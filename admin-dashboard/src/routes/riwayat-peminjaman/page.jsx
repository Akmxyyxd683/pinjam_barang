import { useEffect, useState } from "react";
import axios from "axios";

const RiwayatPeminjamanPage = () => {
    const [transactions, setTransactions] = useState([]);

    useEffect(() => {
        Promise.all([
            axios.get("http://localhost:3000/borrowing-transactions"),
            axios.get("http://localhost:3000/auth/users"),
            axios.get("http://localhost:3000/items"),
        ])
            .then(([txRes, usersRes, itemsRes]) => {
                const txData = (txRes.data.data || []).filter((tx) => tx.status !== "REQUESTED" && tx.status !== "REJECTED");
                const users = usersRes.data.data || [];
                const items = itemsRes.data.data || [];
                const formatted = txData.map((tx) => {
                    const user = users.find((u) => u.id === tx.user_id);
                    const item = items.find((it) => it.id === tx.item_id);
                    return {
                        ...tx,
                        userName: user ? user.name : `User ${tx.user_id}`,
                        itemName: item ? item.nama_barang || item.name : `Item ${tx.item_id}`,
                    };
                });
                setTransactions(formatted);
            })
            .catch(() => {
                setTransactions([]);
            });
    }, []);

    const formatDate = (dateString) => {
        if (!dateString) return "-";
        const date = new Date(dateString);
        if (isNaN(date)) return "-";
        return date.toLocaleDateString();
    };

    return (
        <div className="flex flex-col gap-y-4">
            <h1 className="title">Riwayat Peminjaman</h1>
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
                                <th className="px-4 py-2">Tanggal Kembali</th>
                            </tr>
                        </thead>
                        <tbody>
                            {transactions.map((tx, index) => (
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
                                    <td className="px-4 py-2">{formatDate(tx.returned_at)}</td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    {transactions.length === 0 && <p className="px-4 py-2 text-center text-slate-500">Tidak ada riwayat peminjaman</p>}
                </div>
            </div>
        </div>
    );
};

export default RiwayatPeminjamanPage;
