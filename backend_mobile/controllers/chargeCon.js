const pool = require("../config/db"); 
const jwt = require("jsonwebtoken");

const { getAllPrestataires } = require("../models/charge");

exports.getAllPrestataires = async (req, res) => {
    console.log("🔵 Requête reçue sur /prestataires");

    try {
        const { categorie } = req.query;
        let prestataires;

        console.log("Catégorie reçue :", categorie); // <-- Ajout du print

        if (categorie) {
            // Filtrage par catégorie
            prestataires = await getAllPrestataires(categorie);
        } else {
            // Tous les prestataires
            prestataires = await getAllPrestataires();
        }

        return res.status(200).json(prestataires);
    } catch (error) {
        console.error("❌ Erreur lors de la récupération des prestataires:", error.message);
        return res.status(500).json({ error: "Erreur interne du serveur" });
    }
};