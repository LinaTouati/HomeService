const pool = require("../config/db");
const bcrypt = require("bcrypt"); 
class Prestataire {
    static async create({ nomp, prenomp, numtel, emailp, date_naiss, categorie, description, tarif_horaire, mdp }) {
        try {
            console.log("🔍 Vérification de l'email existant...");
            const existingUser = await pool.query("SELECT * FROM prestataire WHERE emailp = $1", [emailp]);

            if (existingUser.rows.length > 0) {
                console.log("❌ Email déjà utilisé:", emailp);
                throw new Error("Cet email est déjà utilisé.");
            }

            console.log("🔐 Hachage du mot de passe...");
            const hashedPassword = await bcrypt.hash(mdp, 10);

            console.log("📝 Insertion du prestataire en base...");
            const newUser = await pool.query(
                `INSERT INTO prestataire (nomp, prenomp, numtel, emailp, date_naiss, categorie, description, tarif_horaire, mdp)
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *`,
                [nomp, prenomp, numtel, emailp, date_naiss, categorie, description, tarif_horaire, hashedPassword]
            );
            

            console.log("✅ Prestataire inséré avec succès:", newUser.rows[0]);
            return newUser.rows[0];
        } catch (error) {
            console.error("❌ Erreur dans Prestataire.create:", error.message);
            throw error;
        }
    }
}

module.exports = Prestataire;
