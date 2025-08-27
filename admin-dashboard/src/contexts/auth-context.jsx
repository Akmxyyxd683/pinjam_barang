import { createContext, useState } from "react";

import PropTypes from "prop-types";

const initialState = {
    user: null,
    setUser: () => null,
};

export const AuthProviderContext = createContext(initialState);

export function AuthProvider({ children, storageKey = "user", ...props }) {
    const [user, setUserState] = useState(() => {
        try {
            const stored = localStorage.getItem(storageKey);
            return stored ? JSON.parse(stored) : null;
        } catch {
            return null;
        }
    });

    const setUser = (userData) => {
        if (userData) {
            localStorage.setItem(storageKey, JSON.stringify(userData));
        } else {
            localStorage.removeItem(storageKey);
        }
        setUserState(userData);
    };

    const value = {
        user,
        setUser,
    };

    return (
        <AuthProviderContext.Provider
            value={value}
            {...props}
        >
            {children}
        </AuthProviderContext.Provider>
    );
}

AuthProvider.propTypes = {
    children: PropTypes.node,
    storageKey: PropTypes.string,
};
