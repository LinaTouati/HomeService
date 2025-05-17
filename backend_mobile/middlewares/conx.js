const express = require("express");
const { login } = require("../controllers/authController");

const router = express.Router();

// 🔄 Route de connexion
router.post("/login", login);

module.exports = router;
