const mongoose = require("mongoose");

const dbUri = process.env.NODE_ENV === "production"
  ? process.env.DB_URI
  : "mongodb://localhost/test";

mongoose.Promise = Promise;
mongoose.connect(dbUri);
mongoose.connection.on("connected", () => `Mongoose connected to ${dbUri}`);
mongoose.connection.on("error", e => `Mongoose connection error: ${e}`);
mongoose.connection.on("disconnected", () => "Mongoose disconnected");

const commentSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  text: { type: String, required: true, maxlength: 250 }
});

const momentSchema = new mongoose.Schema({
  userId: { type: String, required: true },
  pictures: [String],
  text: { type: String, required: true, maxlength: 1000 },
  likes: { type: Number, default: 0 },
  comments: [commentSchema]
});

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  hash: { type: String, required: true },
  name: { type: String, required: true, minlength: 2, maxlength: 30 },
  birthday: { type: String, required: true },
  isMan: { type: Boolean, required: true },
  picture: { type: String, required: true },
  moments: [momentSchema]
});

mongoose.model("User", userSchema);

require("./passport");
