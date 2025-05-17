const express = require("express");
const { login } = require("../controllers/authController"); // ✅ Correspond au bon fichier

const router = express.Router();

// 🔍 Test de route pour vérifier que `userRoutes.js` fonctionne bien
router.get("/test", (req, res) => {
    res.status(200).json({ message: "✅ Route /user/test fonctionne !" });
});

// 🔄 Route de connexion (POST)
router.post("/login", login);

module.exports = router;
