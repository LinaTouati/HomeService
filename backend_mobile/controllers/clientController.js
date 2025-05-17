const pool = require("../config/db"); // ✅ Connexion PostgreSQL
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

exports.register = async (req, res) => {
    console.log("🔵 Requête reçue sur /auth/register");
    console.log("📦 Données reçues:", req.body);

    try {
        const { nom, prenom, numero_telephone, email, date_naissance, adresse, mot_de_passe } = req.body;

        // ✅ Vérification des champs requis
        if (!nom || !prenom || !numero_telephone || !email || !mot_de_passe) {
            console.log("❌ Erreur : Champs obligatoires manquants");
            return res.status(400).json({ error: "Tous les champs sont obligatoires" });
        }

        // 🔍 Vérification de l'email en base
        console.log("🔍 Vérification de l'email existant...");
        const existingUser = await pool.query("SELECT * FROM client WHERE email = $1", [email]);

        if (existingUser.rows.length > 0) {
            console.log("⚠️ Erreur : Cet email est déjà utilisé !");
            return res.status(409).json({ error: "Email déjà enregistré" });
        }

        // 🔐 Hachage du mot de passe
        console.log("🔐 Hachage du mot de passe...");
        const hashedPassword = await bcrypt.hash(mot_de_passe, 10);

        // 📝 Insertion du client en base
        console.log("📝 Insertion du client en base...");
        const newUser = await pool.query(
            `INSERT INTO client (nom, prenom, numero_telephone, email, date_naissance, adresse, mot_de_passe)
             VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
            [nom, prenom, numero_telephone, email, date_naissance, adresse, hashedPassword]
        );

        console.log("✅ Client inséré avec succès:", newUser.rows[0]);

        // 🔐 Génération du token JWT sécurisé
        const jwtSecret = process.env.JWT_SECRET || "super_secret_key"; 
        const token = jwt.sign({ idc: newUser.rows[0].idc }, jwtSecret, { expiresIn: "24h" });

        return res.status(201).json({ 
            message: "Inscription réussie",
            user: newUser.rows[0],
            token,
        });

    } catch (error) {
        console.error("❌ Erreur lors de l'inscription:", error.message);
        return res.status(500).json({ error: "Erreur interne du serveur" });
    }
};

// 🔄 Récupérer un client par ID
exports.getClientById = async (req, res) => {
    try {
        const clientId = req.params.idc;
        console.log(`🔍 Recherche du client ID: ${clientId}`);

        const client = await pool.query("SELECT * FROM client WHERE idc = $1", [clientId]);

        if (client.rows.length === 0) {
            console.log("❌ Client introuvable !");
            return res.status(404).json({ error: "Client introuvable" });
        }

        const { idc, nom } = client.rows[0]; // <-- On extrait ce qu'attend le front
        // Tu peux ajouter d'autres champs si besoin

        // On retourne un objet avec les bonnes clés
        return res.status(200).json({ idc, nom });

    } catch (error) {
        console.error("❌ Erreur serveur:", error.message);
        return res.status(500).json({ error: "Erreur interne du serveur" });
    }
};