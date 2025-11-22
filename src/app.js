import express from "express";
import authRoutes from "./routes/auth.routes.js";
import userRoutes from "./routes/user.routes.js";
import cors from "cors";
import cookieParser from "cookie-parser";

import {
  getNotes,
  getNote,
  createNote,
  getProduct,
  getProductVariants,
  getColors,
  getSizes,
  getAllProductVariants,
  addNewUser,
} from "./database.js";

const app = express();

// parse JSON body
app.use(express.json());

// optional: parse urlencoded bodies too
app.use(express.urlencoded({ extended: true }));

app.use(cookieParser());

app.use(
  cors({
    origin: "http://localhost:3000", // your React app
    credentials: true,
  })
);

app.get("/notes", async (req, res) => {
  const notes = await getNotes();
  res.send(notes);
});

app.get("/notes/:id", async (req, res) => {
  const id = req.params.id;
  const note = await getNote(id);
  res.send(note);
});

app.post("/notes", async (req, res) => {
  const { title, contents } = req.body;
  const note = await createNote(title, contents);
  res.status(201).send(note);
});

app.get("/product/:id", async (req, res) => {
  const id = req.params.id;
  const note = await getProduct(id);
  res.send(note);
});

app.get("/productvariants/:id", async (req, res) => {
  const id = req.params.id;
  const note = await getProductVariants(id);
  res.send(note);
});

app.get("/allProductvariants", async (req, res) => {
  const note = await getAllProductVariants();
  res.send(note);
});

app.post("/requestOtp", async (req, res) => {
  // console.error(err.stack)
  res.status(200).send("Successful Signup");
});
app.post("/verifyOtp", async (req, res) => {
  // console.error(err.stack)
  console.log("req body:", req.body);
  if (req.body.otp !== "123456") {
    return res.status(500).send("Invalid OTP");
  }
  res.status(200).json({
    success: true,
    message: "OTP verified successfully",
  });
});

app.post("/registerUser", async (req, res) => {
  console.log("req body:", req.body);
  const user = await addNewUser(
    req.body.fullName,
    req.body.email,
    req.body.password,
    req.body.gender,
    req.body.mobile
  );
  console.log(user?.affectedRows);
  //const { name, email, password, gender } = req.body
  // Here you would normally add user to the database
  // For demonstration, we just log the details
  //console.log(`Registering user: ${name}, ${email}, ${password}, ${gender}`)
  res.status(200).json({
    success: true,
    message: "User added successfully",
  });
});

app.get("/sizes", async (req, res) => {
  const sizes = await getSizes();
  res.send(sizes);
});

app.get("/colors", async (req, res) => {
  const colors = await getColors();
  res.send(colors);
});

app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send("Something broke 💩");
});

app.get("/api/reverse", async (req, res) => {
  const { lat, lon } = req.query;

  const url = `https://nominatim.openstreetmap.org/reverse?lat=${lat}&lon=${lon}&format=json&addressdetails=1&accept-language=en`;
  const result = await fetch(url,  {
      headers: {
        "User-Agent": "YourAppName/1.0",
        "Accept-Language": "en",
    }
  });
console.log('Server is running on por',result)
  const data = await result.json();
  res.json(data);
});

// app.listen(8080, () => {
//   console.log('Server is running on port 8080')
// })

app.use("/auth", authRoutes);
app.use("/user", userRoutes);

export default app;
