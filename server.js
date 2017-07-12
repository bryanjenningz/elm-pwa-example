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
app.listen(3000, () => console.log("Listening on port 3000"));
