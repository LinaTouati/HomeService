const pool = require("../config/db"); // Chemin relatif correct
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
exports.login = async (req, res) => {
  console.log("🔵 Connexion en cours...");
  try {
    const { email, mot_de_passe } = req.body;
    let utilisateur = null;
    let role = null;
    let idUtilisateur = null;

    // 🔎 Recherche dans `client` (en minuscules)
    console.log("🔍 Vérification dans `client`...");
    const clientQuery = await pool.query(
      "SELECT * FROM client WHERE LOWER(TRIM(email)) = LOWER(TRIM($1))", 
      [email.trim().toLowerCase()]
    );

    if (clientQuery.rows.length > 0) {
      utilisateur = clientQuery.rows[0];
      role = "client";
      idUtilisateur = utilisateur.idc;
      
      // Vérification mot de passe client
      const passwordMatch = await bcrypt.compare(mot_de_passe, utilisateur.mot_de_passe);
      
      if (!passwordMatch) {
        console.log("❌ Mot de passe client incorrect !");
        return res.status(401).json({ error: "Email ou mot de passe incorrect" });
      }
    } else {
      // 🔎 Recherche dans `prestataire` (noms de colonnes en minuscules)
      console.log("🔍 Vérification dans `prestataire`...");
      const prestataireQuery = await pool.query(
        "SELECT * FROM prestataire WHERE LOWER(TRIM(emailp)) = LOWER(TRIM($1))", 
        [email.trim().toLowerCase()]
      );

      if (prestataireQuery.rows.length > 0) {
        utilisateur = prestataireQuery.rows[0];
        role = "prestataire";
        idUtilisateur = utilisateur.id;
        
        // Vérification mot de passe prestataire
        const passwordMatch = await bcrypt.compare(mot_de_passe, utilisateur.mdp);
        
        if (!passwordMatch) {
          console.log("❌ Mot de passe prestataire incorrect !");
          return res.status(401).json({ error: "Email ou mot de passe incorrect" });
        }
      }
    }

    if (!utilisateur) {
      console.log("❌ Email non trouvé !");
      return res.status(401).json({ error: "Email ou mot de passe incorrect" });
    }

    // 🔐 Génération du token JWT
    const jwtSecret = process.env.JWT_SECRET || "super_secret_key";
    const token = jwt.sign({ id: idUtilisateur, role }, jwtSecret, { expiresIn: "24h" });

    return res.status(200).json({
      user: {
        id: idUtilisateur,
        nom: utilisateur.nom || utilisateur.nomp,  // nomp en minuscules
        prenom: utilisateur.prenom || utilisateur.prenomp, // prenomp en minuscules
        email: utilisateur.email || utilisateur.emailp, // emailp en minuscules
        numero_telephone: utilisateur.numero_telephone || utilisateur.numtel,
        role,
      },
      token,
    });
  } catch (error) {
    console.error("❌ Erreur serveur:", error.message);
    return res.status(500).json({ error: "Erreur interne du serveur" });
  }
};