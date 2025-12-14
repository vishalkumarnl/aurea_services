import db from "../config/db.js";

export const addLocalToRemoteCart = async (req, res) => {
  const user = req.user;
  const { items = [], wishlist = [] } = req.body;

  if (!user) return res.status(404).json({ message: "User not found" });

  const [rows] = await db.query("SELECT * FROM carts WHERE user_id = ?", [
    user.user_id,
  ]);
  const cart = rows[0];
  console.log("Items to add to cart:", cart);
  const cartId = cart ? cart.cart_id : null;
  if (!cartId) {
    // create cart
    const [result] = await db.query("INSERT INTO carts (user_id) VALUES (?)", [
      user.user_id,
    ]);
    cartId = result.insertId;
  }

  // Merge Cart
  for (const item of items) {
    await db.query(
      `INSERT INTO cart_items (cart_id, variant_id, quantity)
       VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity)`,
      [cartId, item.variant_id, item.quantity]
    );
  }

  return res.status(200).json({ message: "Cart updated" });
};

export const getCarts = async (req, res) => {
  const user = req.user;
  if (!user) return res.status(404).json({ message: "User not found" });

  const [rows] = await db.query("SELECT * FROM carts WHERE user_id = ?", [
    user.user_id,
  ]);

  const cart = rows[0];
  console.log("Items to add to cart:", cart);
  const cartId = cart ? cart.cart_id : null;
  if (!cartId) {
    return res.status(200).json({ items: [] });
  }

  const [items] = await db.query(
    "SELECT * FROM cart_items ci JOIN product_variants pv on ci.variant_id = pv.variant_id JOIN products p on pv.product_id = p.product_id WHERE cart_id = ?",
    [cartId]
  );

  res.status(200).json({
    items,
  });
};
