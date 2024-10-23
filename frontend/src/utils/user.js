// frontend/src/utils/user.js
import { jwtDecode } from "jwt-decode";

export function getUserId(token) {
    if (!token) return null;

    try {
        const decoded = jwtDecode(token);
        return decoded.sub.id || null;
    } catch (error) {
        return null;
    }
}

export function getUserRole(token) {
    if (!token) return null;

    try {
        const decoded = jwtDecode(token);
        return decoded.sub.role || null;
    } catch (error) {
        return null;
    }
}