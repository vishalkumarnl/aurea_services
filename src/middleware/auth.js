import jwt from "jsonwebtoken";
import { jwtConfig } from "../config/jwt.js";

export default function auth(req, res, next) {
  const token = req?.cookies?.access_token;

  if (!token) {
    return res.status(403).json({ message: "Invalid token" });
  }

  jwt.verify(token, jwtConfig.accessSecret, (err, user) => {
    if (err) return res.status(401).json({ message: "Not authenticated" });
    req.user = user;
    console.log("USER:", req);
    next();
  });
}
