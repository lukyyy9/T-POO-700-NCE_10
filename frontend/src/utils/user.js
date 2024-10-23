// frontend/src/utils/user.js
import { jwtDecode } from "jwt-decode";

export function getUserId(token) {
    if (!token) return null;

    try {
        const decoded = jwtDecode(token);
        return decoded.sub || null;
    } catch (error) {
        return null;
    }
}