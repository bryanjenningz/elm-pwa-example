require("dotenv").load();
const express = require("express");
const bodyParser = require("body-parser");

require("./api/models/index");
const app = express();
app.use(require("morgan")("dev"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static("dist"));
app.use("/api", require("./api/routes/index"));

// Keeping this here for testing
// const { mockUser, mockMoments } = require("./mockData");
// app.get("/user", (req, res) => res.status(200).json(mockUser));
// app.get("/moments", (req, res) => res.status(200).json(mockMoments));
// app.get("/search", (req, res) =>
//   res.status(200).json(Array.from({ length: 10 }, () => mockUser))
// );
// app.post("/login", (req, res) => res.status(200).json(mockUser));
// app.post("/signup", (req, res) => res.status(200).json(mockUser));

app.listen(3000, () => console.log("Listening on port 3000"));
