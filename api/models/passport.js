const passport = require("passport");
const LocalStrategy = require("passport-local").Strategy;
const bcrypt = require("bcrypt");
const mongoose = require("mongoose");
const User = mongoose.model("User");

passport.use(new LocalStrategy({
  usernameField: "email"
}, async (email, password, done) => {
  try {
    const user = await User.findOne({ email });
    if (await bcrypt.compare(password, user.hash)) {
      return done(null, user);
    } else {
      return done(null, null, { message: "Incorrect password" });
    }
  } catch (err) {
    return done(err);
  }
}));
