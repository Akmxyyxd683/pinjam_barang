import { Navigate } from "react-router-dom";
import { useAuth } from "@/hooks/use-auth";
import PropTypes from "prop-types";

const ProtectedRoute = ({ children }) => {
    const { user } = useAuth();
    if (!user) {
        return (
            <Navigate
                to="/login"
                replace
            />
        );
    }
    return children;
};

export default ProtectedRoute;

ProtectedRoute.propTypes = {
    children: PropTypes.node,
};
