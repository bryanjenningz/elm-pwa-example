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

const languageSchema = new mongoose.Schema({
  shortName: { type: String, minlength: 2, maxlength: 2, required: true },
  name: { type: String, minlength: 2, maxlength: 20, required: true },
  level: { type: Number, min: 0, max: 5, required: true },
});

const defaultLearning = { shortName: "ES", name: "Spanish", level: 2 };
const defaultNative = { shortName: "EN", name: "English", level: 5 };

const userSchema = new mongoose.Schema({
  hash: { type: String, required: true },
  name: { type: String, required: true, minlength: 2, maxlength: 30 },
  email: { type: String, required: true, unique: true },
  birthday: { type: String, required: true },
  isMan: { type: Boolean, required: true },
  picture: { type: String, required: true },

  lastLogin: { type: Date, default: Date.now },
  location: { type: String, maxlength: 50, default: "" },
  localTime: { type: String, maxlength: 50, default: "" },
  learning: { type: languageSchema, default: defaultLearning },
  native: { type: languageSchema, default: defaultNative },
  corrections: { type: Number, default: 0 },
  savedWords: { type: Number, default: 0 },
  audioLookups: { type: Number, default: 0 },
  translationLookups: { type: Number, default: 0 },
  bookmarks: { type: Number, default: 0 },
  intro: { type: String, maxlength: 1000, default: "" },
  interests: { type: [String], default: [] },
  moments: { type: [momentSchema], default: [] }
});

mongoose.model("User", userSchema);

require("./passport");
