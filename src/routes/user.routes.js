import { Router } from "express";
import auth from "../middleware/auth.js";
import role from "../middleware/role.js";
import { getProfile } from "../controllers/user.controller.js";

const router = Router();

router.get("/profile", auth, getProfile);
router.get("/admin-only", auth, role("admin"), (req, res) => {
    res.json({ message: "Admin access granted" });
});

export default router;
