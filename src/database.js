import db from "./config/db.js";

export async function getNotes() {
  const [rows] = await db.query("SELECT * FROM notes")
  return rows
}

export async function getNote(id) {
  const [rows] = await db.query(`
  SELECT * 
  FROM notes
  WHERE id = ?
  `, [id])
  return rows[0]
}

export async function createNote(title, contents) {
  const [result] = await db.query(`
  INSERT INTO notes (title, contents)
  VALUES (?, ?)
  `, [title, contents])
  const id = result.insertId
  return getNote(id)
}

export async function getProduct(id) {
  const [rows] = await db.query(`
  SELECT * 
  FROM products
  WHERE product_id = ?
  `, [id])
  return rows[0]
}

export async function getProductVariants(id) {
  const [rows] = await db.query(`
  SELECT * 
  FROM product_variants
  WHERE product_id = ?
  `, [id])
  return rows
}

export async function getAllProductVariants() {
  const [rows] = await db.query(`
  SELECT * 
  FROM product_variants pv JOIN products p on pv.product_id = p.product_id`)
  return rows
}

export async function getSizes() {
  const [rows] = await db.query("SELECT * FROM sizes")
  return rows
}

export async function getColors() {
  const [rows] = await db.query("SELECT * FROM colors")
  return rows
}
export async function addNewUser(name, email, password, gender, mobile) {
  const [result] = await db.query(
    `INSERT INTO user (name, email, password, gender, mobile) VALUES (?, ?, ?, ?,?)`,
    [name, email, password, gender, mobile]
  );

  return result;
}
