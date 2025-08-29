import { useEffect, useState } from "react";
import axios from "axios";
import { PencilLine, Trash } from "lucide-react";
import { Footer } from "@/layouts/footer";

const ListKaryawanPage = () => {
    const [employees, setEmployees] = useState([]);

    useEffect(() => {
        axios
            .get("http://localhost:3000/auth/users")
            .then((res) => {
                setEmployees(res.data.data || []);
            })
            .catch(() => {
                setEmployees([]);
            });
    }, []);

    const handleEdit = (id) => {
        alert(`Edit karyawan ${id} belum tersedia`);
    };

    const handleDelete = (id) => {
        alert(`Hapus karyawan ${id} belum tersedia`);
    };

    return (
        <div className="flex flex-col gap-y-4">
            <h1 className="title">Daftar Karyawan</h1>
            <div className="card">
                <div className="card-body overflow-x-auto">
                    <table className="w-full table-auto">
                        <thead>
                            <tr className="text-left">
                                <th className="px-4 py-2">No</th>
                                <th className="px-4 py-2">Nama</th>
                                <th className="px-4 py-2">Profile</th>
                                <th className="px-4 py-2">Role</th>
                                <th className="px-4 py-2">No. Telp</th>
                                <th className="px-4 py-2">Alamat</th>
                                <th className="px-4 py-2">Email</th>
                                <th className="px-4 py-2">Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            {employees.map((emp, index) => (
                                <tr
                                    key={emp.id}
                                    className="border-t"
                                >
                                    <td className="px-4 py-2">{index + 1}</td>
                                    <td className="px-4 py-2">{emp.name}</td>
                                    <td className="px-4 py-2">
                                        {emp.profile_img ? (
                                            <img
                                                src={emp.profile_img}
                                                alt={emp.name}
                                                className="h-10 w-10 rounded-full object-cover"
                                            />
                                        ) : (
                                            <div className="h-10 w-10 rounded-full bg-slate-200" />
                                        )}
                                    </td>
                                    <td className="px-4 py-2">{emp.role || "-"}</td>
                                    <td className="px-4 py-2">{emp.no_telp || "-"}</td>
                                    <td className="px-4 py-2">{emp.alamat || "-"}</td>
                                    <td className="px-4 py-2">{emp.email}</td>
                                    <td className="px-4 py-2">
                                        <button
                                            onClick={() => handleEdit(emp.id)}
                                            className="mr-2 text-blue-500 hover:text-blue-700"
                                        >
                                            <PencilLine size={16} />
                                        </button>
                                        <button
                                            onClick={() => handleDelete(emp.id)}
                                            className="text-red-500 hover:text-red-700"
                                        >
                                            <Trash size={16} />
                                        </button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                    {employees.length === 0 && <p className="px-4 py-2 text-center text-slate-500">Tidak ada karyawan</p>}
                </div>
            </div>
            <Footer />
        </div>
    );
};

export default ListKaryawanPage;
