import { Router } from "express";
import { register, resetPassword, login, refresh, logout } from "../controllers/auth.controller.js";

const router = Router();

router.post("/register", register);
router.post("/login", login);
router.post("/refresh", refresh);
router.post("/resetPassword", resetPassword);
router.post("/logout", logout);

export default router;
