const express = require("express");
const { mockUser, mockMoments } = require("./mockData");
const app = express();

app.use(express.static("dist"));

app.get("/user", (req, res) => res.status(200).json(mockUser));
app.get("/moments", (req, res) => res.status(200).json(mockMoments));
app.get("/search", (req, res) =>
  res.status(200).json(Array.from({ length: 10 }, () => mockUser))
);

app.post("/login", (req, res) => res.status(200).json(mockUser));
app.post("/signup", (req, res) => res.status(200).json(mockUser));

app.listen(3000, () => console.log("Listening on port 3000"));
