const router = require("express").Router();
const ctrlAuth = require("../controllers/auth");

router.post("/login", ctrlAuth.login);
router.post("/signup", ctrlAuth.signup);

module.exports = router;
