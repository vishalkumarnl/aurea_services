export const jwtConfig = {
    accessSecret: process.env.ACCESS_TOKEN_SECRET,
    refreshSecret: process.env.REFRESH_TOKEN_SECRET,
    accessExpire: "15m",
    refreshExpire: "7d"
};