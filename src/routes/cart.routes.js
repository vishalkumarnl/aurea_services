import { Router } from "express";
import auth from "../middleware/auth.js";
import role from "../middleware/role.js";
import { addLocalToRemoteCart, getCarts } from "../controllers/cart.controller.js";

const router = Router();

router.post("/addLocalToRemoteCart", auth, addLocalToRemoteCart);
router.get("/getCarts", auth, getCarts);
router.get("/admin-only", auth, role("admin"), (req, res) => {
    res.json({ message: "Admin access granted" });
});

export default router;
