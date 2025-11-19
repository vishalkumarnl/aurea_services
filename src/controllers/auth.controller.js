import db from "../config/db.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { generateTokens } from "../utils/generateTokens.js";
import { jwtConfig } from "../config/jwt.js";

export const register = async (req, res) => {
  const { email, password, fullName: name, gender = "" ,mobile} = req.body;

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

  const [rows] = await db.query("SELECT * FROM users WHERE mobile = ?", [mobile]);
  const user = rows[0];

  if (!user) return res.status(404).json({ message: "User not found" });

  const match = await bcrypt.compare(password, user.password);
  if (!match) return res.status(401).json({ message: "Incorrect password" });

  console.log("REFRESH:", user);
  const tokens = generateTokens(user);
  console.log("REFRESH1:", user);

  await db.query(
    "INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES (?, ?, NOW() + INTERVAL 7 DAY)",
    [user.id, tokens.refreshToken]
  );

  res.json(tokens);
};

export const refresh = async (req, res) => {
  const { token } = req.body;

  if (!token) return res.status(401).json({ message: "No refresh token" });

  const [rows] = await db.query(
    "SELECT * FROM refresh_tokens WHERE token = ?",
    [token]
  );

  if (!rows.length)
    return res.status(403).json({ message: "Invalid refresh token" });

  jwt.verify(token, jwtConfig.refreshSecret, async (err, payload) => {
    if (err) return res.status(403).json({ message: "Expired refresh token" });

    const [users] = await db.query("SELECT * FROM users WHERE id = ?", [
      payload.id,
    ]);
    const user = users[0];

    const tokens = generateTokens(user);

    await db.query(
      "UPDATE refresh_tokens SET token = ?, expires_at = NOW() + INTERVAL 7 DAY WHERE id = ?",
      [tokens.refreshToken, rows[0].id]
    );

    res.json(tokens);
  });
};

export const logout = async (req, res) => {
  const { token } = req.body;

  await db.query("DELETE FROM refresh_tokens WHERE token = ?", [token]);

  res.json({ message: "Logged out" });
};
