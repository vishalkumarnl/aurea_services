import jwt from "jsonwebtoken";
import { jwtConfig } from "../config/jwt.js";

export const generateTokens = (user) => {
    const accessToken = jwt.sign(
        { user_id: user.user_id, role: user.role, email: user.email ,mobile:user.mobile,name:user.name, gender:user.gender},
        jwtConfig.accessSecret,
        { expiresIn: jwtConfig.accessExpire }
    );

    const refreshToken = jwt.sign(
        { user_id: user.user_id, role: user.role, email: user.email ,mobile:user.mobile,name:user.name, gender:user.gender },
        jwtConfig.refreshSecret,
        { expiresIn: jwtConfig.refreshExpire }
    );

    return { accessToken, refreshToken };
};
