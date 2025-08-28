// hooks/use-auth.jsx
import { useContext } from "react";
import { AuthProviderContext } from "../contexts/auth-context";

export const useAuth = () => {
    const context = useContext(AuthProviderContext);

    if (context === undefined) {
        throw new Error("useAuth must be used within an AuthProvider");
    }

    return context;
};
