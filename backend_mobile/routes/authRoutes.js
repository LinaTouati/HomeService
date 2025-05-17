const express = require("express");
const { register, getClientById } = require("../controllers/clientController"); // 🔥 Import de la fonction

const router = express.Router();

// 🔍 Test de route pour vérifier que `clientRoutes.js` fonctionne bien
router.get("/test", (req, res) => {
    res.status(200).json({ message: "✅ Route /client/test fonctionne !" });
});

// 🔄 Route d'inscription (POST)
router.post("/register", register);

// 🔄 Route pour récupérer un client par son ID (GET)
router.get("/:idc", getClientById); // 🔥 Ajout de la route GET /client/:id

module.exports = router; 
