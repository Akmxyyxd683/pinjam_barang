import { createContext, useEffect, useState } from "react";

import PropTypes from "prop-types";

const initialState = {
    user: null,
    setUser: () => null,
};

export const AuthProviderContext = createContext(initialState);

export function AuthProvider({ children, storageKey = "admin", ...props }) {
    const [user, setUserState] = useState(null);

    useEffect(() => {
        try {
            const stored = window.localStorage.getItem(storageKey);
            setUserState(stored ? JSON.parse(stored) : null);
        } catch {
            setUserState(null);
        }
    }, [storageKey]);

    const setUser = (userData) => {
        try {
            if (userData) {
                window.localStorage.setItem(storageKey, JSON.stringify(userData));
            } else {
                window.localStorage.removeItem(storageKey);
            }
        } catch {
            // ignore storage errors
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
