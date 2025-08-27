import { Area, AreaChart, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";

import { useTheme } from "@/hooks/use-theme";

import { overviewData, recentSalesData } from "@/constants";
const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

import { Footer } from "@/layouts/footer";

import { Package, PencilLine, Trash, TrendingUp, TrendingDown, Users, Hourglass, Clock } from "lucide-react";
import { useEffect, useState } from "react";

import axios from "axios";

const DashboardPage = () => {
    const { theme } = useTheme();
    const [items, setItems] = useState([]);
    const [stats, setStats] = useState({
        totalItems: 0,
        borrowedItems: 0,
        totalEmployees: 0,
    });
    const [prevStats, setPrevStats] = useState({
        totalItems: 0,
        borrowedItems: 0,
        totalEmployees: 0,
    });

    const [chartData, setChartData] = useState(MONTHS.map((name) => ({ name, total: 0 })));

    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const previous = JSON.parse(localStorage.getItem("dashboardStats")) || {
            totalItems: 0,
            borrowedItems: 0,
            totalEmployees: 0,
        };
        setPrevStats(previous);

        Promise.all([
            axios.get("http://localhost:3000/items"),
            axios.get("http://localhost:3000/auth/users"),
            axios.get("http://localhost:3000/borrowing-transactions"),
        ])
            .then(([itemsRes, usersRes, borrowedItemsRes]) => {
                const itemsData = itemsRes.data.data || [];
                const usersData = usersRes.data.data || [];
                const borrowedItemsData = borrowedItemsRes.data.data || [];
                setItems(itemsData);
                const newStats = {
                    totalItems: itemsData.length,
                    borrowedItems: borrowedItemsData.length,
                    totalEmployees: usersData.length,
                };
                const monthlyCounts = MONTHS.map((name) => ({ name, total: 0 }));
                borrowedItemsData.forEach((tx) => {
                    const date = new Date(tx.borrowed_at);
                    if (!isNaN(date)) {
                        const month = date.getMonth();
                        if (monthlyCounts[month]) {
                            monthlyCounts[month].total += 1;
                        }
                    }
                });
                setChartData(monthlyCounts);
                setStats(newStats);
                localStorage.setItem("dashboardStats", JSON.stringify(newStats));
            })
            .catch((err) => {
                console.error(err);
                setItems([]);
            })
            .finally(() => {
                setLoading(false);
            });
    }, []);

    const getPercentChange = (current, previous) => {
        if (!previous) return 0;
        return ((current - previous) / previous) * 100;
    };

    const totalItemsChange = getPercentChange(stats.totalItems, prevStats.totalItems);
    const totalEmployeesChange = getPercentChange(stats.totalEmployees, prevStats.totalEmployees);
    const borrowedItemsChange = getPercentChange(stats.borrowedItems, prevStats.borrowedItems);

    return (
        <div className="flex flex-col gap-y-4">
            <h1 className="title">Dashboard</h1>
            <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                <div className="card">
                    <div className="card-header">
                        <div className="w-fit rounded-lg bg-blue-500/20 p-2 text-blue-500 transition-colors dark:bg-blue-600/20 dark:text-blue-600">
                            <Package size={26} />
                        </div>
                        <p className="card-title">Total Barang</p>
                    </div>
                    <div className="card-body bg-slate-100 transition-colors dark:bg-slate-950">
                        <p className="text-3xl font-bold text-slate-900 transition-colors dark:text-slate-50">{stats.totalItems}</p>
                        <span
                            className={`flex w-fit items-center gap-x-2 rounded-full border px-2 py-1 font-medium ${
                                totalItemsChange >= 0 ? "border-green-500 text-green-500" : "border-red-500 text-red-500"
                            }`}
                        >
                            {totalItemsChange >= 0 ? <TrendingUp size={18} /> : <TrendingDown size={18} />}
                            {Math.abs(totalItemsChange).toFixed(0)}%
                        </span>
                    </div>
                </div>
                <div className="card">
                    <div className="card-header">
                        <div className="rounded-lg bg-blue-500/20 p-2 text-blue-500 transition-colors dark:bg-blue-600/20 dark:text-blue-600">
                            <Clock size={26} />
                        </div>
                        <p className="card-title">Sedang Dipinjam</p>
                    </div>
                    <div className="card-body bg-slate-100 transition-colors dark:bg-slate-950">
                        <p className="text-3xl font-bold text-slate-900 transition-colors dark:text-slate-50">{stats.borrowedItems}</p>
                        <span
                            className={`flex w-fit items-center gap-x-2 rounded-full border px-2 py-1 font-medium ${
                                borrowedItemsChange >= 0 ? "border-green-500 text-green-500" : "border-red-500 text-red-500"
                            }`}
                        >
                            {borrowedItemsChange >= 0 ? <TrendingUp size={18} /> : <TrendingDown size={18} />}
                            {Math.abs(borrowedItemsChange).toFixed(0)}%
                        </span>
                    </div>
                </div>
                <div className="card">
                    <div className="card-header">
                        <div className="rounded-lg bg-blue-500/20 p-2 text-blue-500 transition-colors dark:bg-blue-600/20 dark:text-blue-600">
                            <Users size={26} />
                        </div>
                        <p className="card-title">Total Karyawan</p>
                    </div>
                    <div className="card-body bg-slate-100 transition-colors dark:bg-slate-950">
                        <p className="text-3xl font-bold text-slate-900 transition-colors dark:text-slate-50">{stats.totalEmployees}</p>
                        <span
                            className={`flex w-fit items-center gap-x-2 rounded-full border px-2 py-1 font-medium ${
                                totalEmployeesChange >= 0 ? "border-green-500 text-green-500" : "border-red-500 text-red-500"
                            }`}
                        >
                            {totalEmployeesChange >= 0 ? <TrendingUp size={18} /> : <TrendingDown size={18} />}
                            {Math.abs(totalEmployeesChange).toFixed(0)}%
                        </span>
                    </div>
                </div>
                <div className="card">
                    <div className="card-header">
                        <div className="rounded-lg bg-blue-500/20 p-2 text-blue-500 transition-colors dark:bg-blue-600/20 dark:text-blue-600">
                            <Hourglass size={26} />
                        </div>
                        <p className="card-title">Pending Approval</p>
                    </div>
                    <div className="card-body bg-slate-100 transition-colors dark:bg-slate-950">
                        <p className="text-3xl font-bold text-slate-900 transition-colors dark:text-slate-50">12,340</p>
                        <span className="flex w-fit items-center gap-x-2 rounded-full border border-blue-500 px-2 py-1 font-medium text-blue-500 dark:border-blue-600 dark:text-blue-600">
                            <TrendingUp size={18} />
                            19%
                        </span>
                    </div>
                </div>
            </div>
            <div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-7">
                <div className="card col-span-1 md:col-span-2 lg:col-span-4">
                    <div className="card-header">
                        <p className="card-title">Data transaksi tiap bulannya</p>
                    </div>
                    <div className="card-body p-0">
                        <ResponsiveContainer
                            width="100%"
                            height={300}
                        >
                            <AreaChart
                                data={chartData}
                                margin={{
                                    top: 0,
                                    right: 0,
                                    left: 0,
                                    bottom: 0,
                                }}
                            >
                                <defs>
                                    <linearGradient
                                        id="colorTotal"
                                        x1="0"
                                        y1="0"
                                        x2="0"
                                        y2="1"
                                    >
                                        <stop
                                            offset="5%"
                                            stopColor="#2563eb"
                                            stopOpacity={0.8}
                                        />
                                        <stop
                                            offset="95%"
                                            stopColor="#2563eb"
                                            stopOpacity={0}
                                        />
                                    </linearGradient>
                                </defs>
                                <Tooltip
                                    cursor={false}
                                    formatter={(value) => value}
                                />

                                <XAxis
                                    dataKey="name"
                                    strokeWidth={0}
                                    stroke={theme === "light" ? "#475569" : "#94a3b8"}
                                    tickMargin={6}
                                />
                                <YAxis
                                    dataKey="total"
                                    strokeWidth={0}
                                    stroke={theme === "light" ? "#475569" : "#94a3b8"}
                                    tickFormatter={(value) => value}
                                    tickMargin={6}
                                />

                                <Area
                                    type="monotone"
                                    dataKey="total"
                                    stroke="#2563eb"
                                    fillOpacity={1}
                                    fill="url(#colorTotal)"
                                />
                            </AreaChart>
                        </ResponsiveContainer>
                    </div>
                </div>
                <div className="card col-span-1 md:col-span-2 lg:col-span-3">
                    <div className="card-header">
                        <p className="card-title">Request peminjaman terbaru</p>
                    </div>
                    <div className="card-body h-[300px] overflow-auto p-0">
                        {recentSalesData.map((sale) => (
                            <div
                                key={sale.id}
                                className="flex items-center justify-between gap-x-4 py-2 pr-2"
                            >
                                <div className="flex items-center gap-x-4">
                                    <img
                                        src={sale.image}
                                        alt={sale.name}
                                        className="size-10 flex-shrink-0 rounded-full object-cover"
                                    />
                                    <div className="flex flex-col gap-y-2">
                                        <p className="font-medium text-slate-900 dark:text-slate-50">{sale.name}</p>
                                        <p className="text-sm text-slate-600 dark:text-slate-400">{sale.email}</p>
                                    </div>
                                </div>
                                <p className="font-medium text-slate-900 dark:text-slate-50">${sale.total}</p>
                            </div>
                        ))}
                    </div>
                </div>
            </div>
            <div className="card">
                <div className="card-header">
                    <p className="card-title">Data Product</p>
                </div>
                <div className="card-body p-0">
                    <div className="relative h-[500px] w-full flex-shrink-0 overflow-auto rounded-none [scrollbar-width:_thin]">
                        {loading ? (
                            <div className="h-6 w-6 animate-spin rounded-full border-2 border-blue-500 border-t-transparent"></div>
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
                                    {items.map((item) => (
                                        <tr
                                            key={item.id}
                                            className="table-row"
                                        >
                                            <td className="table-cell py-2">{item.id}</td>
                                            <td className="table-cell py-2">
                                                <div className="flex w-max gap-x-4">
                                                    <img
                                                        src={item.img_url}
                                                        alt="Entah"
                                                        className="size-14 rounded-lg object-cover"
                                                    />
                                                    <div className="flex flex-col">
                                                        <p>{item.name}</p>
                                                        <p className="text-sm font-normal text-slate-600 dark:text-slate-400">sigma boy</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td className="table-cell py-2">{item.create_at}</td>
                                            <td className="table-cell py-2">{item.status}</td>
                                            <td className="table-cell py-2">
                                                <div className="flex items-center gap-x-4">
                                                    <button className="text-blue-500 dark:text-blue-600">
                                                        <PencilLine size={20} />
                                                    </button>
                                                    <button className="text-red-500">
                                                        <Trash size={20} />
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    ))}
                                </tbody>
                            </table>
                        )}
                    </div>
                </div>
            </div>
            <Footer />
        </div>
    );
};

export default DashboardPage;
