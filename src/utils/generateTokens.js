import jwt from "jsonwebtoken";
import { jwtConfig } from "../config/jwt.js";
import { m } from "framer-motion";

export const generateTokens = (user) => {
    const accessToken = jwt.sign(
        { id: user.id, role: user.role, email: user.email ,mobile:user.mobile},
        jwtConfig.accessSecret,
        { expiresIn: jwtConfig.accessExpire }
    );

    const refreshToken = jwt.sign(
        { id: user.id, email: user.email ,mobile:user.mobile },
        jwtConfig.refreshSecret,
        { expiresIn: jwtConfig.refreshExpire }
    );

    return { accessToken, refreshToken };
};
