const express = require("express");
const { register } = require("../controllers/prestaController"); // ✅ Correspond au vrai fichier !
const {  getAllPrestataires } = require("../controllers/chargeCon");

const router = express.Router();

// 🔍 Test de route pour vérifier que `prestataireRoutes.js` fonctionne bien
router.get("/test", (req, res) => {
    res.status(200).json({ message: "✅ Route /prestataire/test fonctionne !" });
});

router.post("/register", register);

// Nouvelle route pour afficher tous les prestataires
router.get("/prestataires", getAllPrestataires);
module.exports = router;
