const pool = require("../config/db");
const jwt = require("jsonwebtoken");
const Prestataire = require("../models/prestataire");

exports.register = async (req, res) => {
    console.log("🔵 Requête reçue sur /prestataire/register");
    console.log("📦 Données reçues:", req.body);

    try {
        const { nomp, prenomp, numtel, emailp, date_naiss, categorie, description, tarif_horaire, mdp} = req.body;

        if (!emailp || !mdp) {
            console.log("❌ Erreur : Email ou mot de passe manquant");
            return res.status(400).json({ error: "Email et mot de passe sont obligatoires" });
        }

        const newPrestataire = await Prestataire.create({
            nomp, prenomp, numtel, emailp, date_naiss, categorie, description, tarif_horaire, mdp
        });

        const jwtSecret = "super_secret_key"; // 🔐 Pas besoin de `.env`
        const token = jwt.sign({ id: newPrestataire.id }, jwtSecret, { expiresIn: "24h" });

        return res.status(201).json({
            message: "Inscription réussie",
            prestataire: newPrestataire,
            token,
        });

    } catch (error) {
        console.error("❌ Erreur lors de l'inscription:", error.message);
        return res.status(500).json({ error: "Erreur interne du serveur" });
    }
};
