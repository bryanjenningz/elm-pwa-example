const passport = require("passport");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const mongoose = require("mongoose");
const User = mongoose.model("User");

const isAllAscii = string => !!string.match(/^[\x00-\x7F]+$/);

const isValidEmail = email =>
  typeof email === "string" &&
  email.length <= 256 && 
  isAllAscii(email) &&
  !!email.match(/^[^\s@]+@[^\s@]+\.[^\s@]+$/);

const isValidPassword = password =>
  typeof password === "string" &&
  password.length >= 6 &&
  password.length <= 256 &&
  isAllAscii(password);

const isValidName = name =>
  typeof name === "string" &&
  name.length >= 2 &&
  name.length <= 30 &&
  isAllAscii(name);

const isValidDate = date =>
  typeof date === "string" &&
  !!date.match(/^(?:(?:(?:0?[13578]|1[02])(\/|-|\.)31)\1|(?:(?:0?[1,3-9]|1[0-2])(\/|-|\.)(?:29|30)\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:0?2(\/|-|\.)29\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:(?:0?[1-9])|(?:1[0-2]))(\/|-|\.)(?:0?[1-9]|1\d|2[0-8])\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$/);

const createToken = userId =>
  jwt.sign(userId, process.env.JWT_SECRET, { expiresIn: "7d" });

const login = (req, res) => {
  if (!isValidEmail(req.body.email)) {
    return res.status(400).json({ message: "Invalid email" });
  }
  if (!isValidPassword(req.body.password)) {
    return res.status(400).json({ message: "Invalid password" });
  }

  passport.authenticate("local", (err, user, info) => {
    if (err) {
      return res.status(404).json({ message: err });
    }
    if (!user) {
      return res.status(404).json({ message: "No user" });
    }

    return res.status(200).json({ token: createToken(user._id) });
  })(req, res);
};

const signup = async (req, res) => {
  if (!isValidEmail(req.body.email)) {
    return res.status(400).json({ message: "Invalid email" });
  }
  if (!isValidPassword(req.body.password)) {
    return res.status(400).json({ message: "Invalid password" });
  }
  if (!isValidName(req.body.name)) {
    return res.status(400).json({ message: "Invalid name" });
  }
  if (!isValidDate(req.body.birthday)) {
    return res.status(400).json({ message: "Invalid birthday" });
  }
  if (typeof req.body.isMan !== "boolean") {
    return res.status(400).json({ message: "Invalid isMan" });
  }
  if (typeof req.body.picture !== "string" || req.body.picture.length === 0) {
    return res.status(400).json({ message: "Invalid picture" });
  }

  const user = new User();
  user.email = req.body.email;
  user.name = req.body.name;
  user.birthday = req.body.birthday;
  user.isMan = req.body.isMan;
  user.picture = req.body.picture;
  user.hash = await bcrypt.hash(req.body.password, 10);

  try {
    await user.save();
    return res.status(200).json({ user, token: createToken(user._id) });
  } catch (err) {
    console.log(err);
    return res.status(409).json({
      message: "Email already in use, choose a different email"
    });
  }
};

module.exports = { login, signup };
