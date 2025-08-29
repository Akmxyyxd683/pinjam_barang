import { createBrowserRouter, RouterProvider } from "react-router-dom";

import { ThemeProvider } from "@/contexts/theme-context";

import { AuthProvider } from "@/contexts/auth-context";

import Layout from "@/routes/layout";
import DashboardPage from "@/routes/dashboard/page";
import LoginPage from "./routes/login/page";
import ProtectedRoute from "./routes/protected-routes";
import ListKaryawanPage from "./routes/list-karyawan/page";
import RegisterKaryawanPage from "./routes/register-karyawan/page";
import DaftarBarangPage from "./routes/daftar-barang/page";
import TambahBarangPage from "./routes/tambah-barang/page";
import RiwayatPeminjamanPage from "./routes/riwayat-peminjaman/page";

function App() {
    const router = createBrowserRouter([
        {
            path: "/login",
            element: <LoginPage />,
        },
        {
            path: "/",
            element: (
                <ProtectedRoute>
                    <Layout />
                </ProtectedRoute>
            ),
            children: [
                {
                    index: true,
                    element: <DashboardPage />,
                },
                {
                    path: "customers",
                    element: <h1 className="title">Customers</h1>,
                },
                {
                    path: "new-customer",
                    element: <h1 className="title">New Customer</h1>,
                },
                {
                    path: "riwayat-peminjaman",
                    element: <RiwayatPeminjamanPage />,
                },
                {
                    path: "products",
                    element: <DaftarBarangPage />,
                },
                {
                    path: "tambah-barang",
                    element: <TambahBarangPage />,
                },
                {
                    path: "inventory",
                    element: <h1 className="title">Inventory</h1>,
                },
                {
                    path: "list-karyawan",
                    element: <ListKaryawanPage />,
                },
                {
                    path: "register-karyawan",
                    element: <RegisterKaryawanPage />,
                },
                {
                    path: "settings",
                    element: <h1 className="title">Settings</h1>,
                },
            ],
        },
    ]);

    return (
        <AuthProvider storageKey="admin">
            <ThemeProvider storageKey="theme">
                <RouterProvider router={router} />
            </ThemeProvider>
        </AuthProvider>
    );
}

export default App;
