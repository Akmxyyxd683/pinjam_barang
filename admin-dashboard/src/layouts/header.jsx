import { useTheme } from "@/hooks/use-theme";

import { Bell, ChevronsLeft, Moon, Search, Sun, LogOut } from "lucide-react";

import profileImg from "@/assets/profile-image.jpg";

import PropTypes from "prop-types";
import axios from "axios";
import { useEffect, useRef, useState } from "react";
import { useAuth } from "@/hooks/use-auth";

export const Header = ({ collapsed, setCollapsed }) => {
    const { theme, setTheme } = useTheme();
    const { user } = useAuth();

    const [open, setOpen] = useState(false);
    const menuRef = useRef(null);

    // Tutup menu kalau klik di luar
    useEffect(() => {
        function handleClickOutside(event) {
            if (menuRef.current && !menuRef.current.contains(event.target)) {
                setOpen(false);
            }
        }
        document.addEventListener("mousedown", handleClickOutside);
        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, []);

    const handleLogout = () => {
        const confirmLogout = window.confirm("Apakah anda ingin logout?");
        if (confirmLogout) {
            // Hapus token atau data login yang kamu simpan
            localStorage.removeItem("token");
            sessionStorage.removeItem("token");

            // (Opsional) reset user state kalau pakai context/auth provider
            // setUser(null);

            alert("Logout berhasil!");
            window.location.href = "/login";
        }
    };

    const profileSrc = user?.profile_img || profileImg;

    return (
        <header className="relative z-10 flex h-[60px] items-center justify-between bg-white px-4 shadow-md transition-colors dark:bg-slate-900">
            <div className="flex items-center gap-x-3">
                <button
                    className="btn-ghost size-10"
                    onClick={() => setCollapsed(!collapsed)}
                >
                    <ChevronsLeft className={collapsed && "rotate-180"} />
                </button>
                <div className="input">
                    <Search
                        size={20}
                        className="text-slate-300"
                    />
                    <input
                        type="text"
                        name="search"
                        id="search"
                        placeholder="Search..."
                        className="w-full bg-transparent text-slate-900 outline-0 placeholder:text-slate-300 dark:text-slate-50"
                    />
                </div>
            </div>
            <div className="flex items-center gap-x-3">
                <button
                    className="btn-ghost size-10"
                    onClick={() => setTheme(theme === "light" ? "dark" : "light")}
                >
                    <Sun
                        size={20}
                        className="dark:hidden"
                    />
                    <Moon
                        size={20}
                        className="hidden dark:block"
                    />
                </button>
                <button className="btn-ghost size-10">
                    <Bell size={20} />
                </button>
                <div
                    className="relative"
                    ref={menuRef}
                >
                    <button
                        className="size-10 overflow-hidden rounded-full"
                        onClick={() => setOpen(!open)}
                    >
                        <img
                            src={profileSrc}
                            alt="profile image"
                            className="size-full object-cover"
                        />
                    </button>
                    {open && (
                        <div className="absolute right-0 mt-2 w-40 rounded-lg bg-white shadow-lg ring-1 ring-black/5">
                            <button
                                onClick={handleLogout} // ganti dengan fungsi logout-mu
                                className="w-full px-4 py-2 text-left text-sm hover:bg-gray-100"
                            >
                                <LogOut size={18} />
                                <span>Logout</span>
                            </button>
                        </div>
                    )}
                </div>
            </div>
        </header>
    );
};

Header.propTypes = {
    collapsed: PropTypes.bool,
    setCollapsed: PropTypes.func,
};
