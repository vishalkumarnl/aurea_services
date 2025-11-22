import db from "../config/db.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { generateTokens } from "../utils/generateTokens.js";
import { jwtConfig } from "../config/jwt.js";

export const register = async (req, res) => {
  const { email, password, fullName: name, gender = "", mobile } = req.body;

  const hashed = await bcrypt.hash(password, 10);

  await db.query(
    "INSERT INTO users (email, password, name, gender, mobile) VALUES (?, ?, ?,?,?)",
    [email, hashed, name, gender, mobile]
  );

  res.status(200).json({
    success: true,
    message: "User registered successfully",
  });
};

export const login = async (req, res) => {
  const { email, mobile, password } = req.body;

  const [rows] = await db.query("SELECT * FROM users WHERE mobile = ?", [
    mobile,
  ]);
  const user = rows[0];

  if (!user) return res.status(404).json({ message: "User not found" });

  const match = await bcrypt.compare(password, user.password);
  if (!match) return res.status(401).json({ message: "Incorrect password" });

  const { accessToken, refreshToken } = generateTokens(user);
  console.log("REFRESH:", user);

  res.cookie("access_token", accessToken, {
    httpOnly: true, // cookie not accessible via JS
    secure: false, // must be false for HTTP (localhost)
    sameSite: "lax", // allows cross-port requests in dev
    path: "/", // ensures cookie is sent for all routes
    maxAge: 15 * 60 * 1000, // 15 minutes
  });

  res.cookie("refresh_token", refreshToken, {
    httpOnly: true,
    secure: false, // because localhost is NOT https
    sameSite: "lax", // required for cross-port local dev
    path: "/",
    maxAge: 7 * 24 * 60 * 60 * 1000, // 7 days
  });

  return res.json({ user });
};

export const refresh = async (req, res) => {
  const token = req.cookies.refresh_token;

  if (!token) return res.status(401).json({ message: "No refresh token" });

  jwt.verify(token, jwtConfig.refreshSecret, async (err, payload) => {
    if (err) return res.status(403).json({ message: "Expired refresh token" });

    const { accessToken } = generateTokens(payload);

    // 3. Set new access token cookie
    res.cookie("access_token", accessToken, {
      httpOnly: true,
      secure: false, // because localhost is NOT https
      sameSite: "lax", // required for cross-port local dev
      path: "/",
      maxAge: 15 * 60 * 1000, // 15 minutes
    });

    return res.json({ ok: true });
  });
};

export const logout = async (req, res) => {
  res.clearCookie("access_token", {
    httpOnly: true,
    secure: false,
    sameSite: "lax",
    path: "/",
  });

  res.clearCookie("refresh_token", {
    httpOnly: true,
    secure: false,
    sameSite: "lax",
    path: "/",
  });

  res.json({ message: "Logged out" });
};
