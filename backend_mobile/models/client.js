const pool = require("../config/db");
require("dotenv").config();

class User {
    constructor(id, nom, prenom, email, numeroTelephone, role) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.numeroTelephone = numeroTelephone;
        this.role = role;
    }

    static async fromDB(row) {
        try {
            console.log("🔍 Création User depuis DB row:", row);
            
            return new User(
                row.idc ?? row.id, // ID client ou prestataire
                row.nom ?? row.nomp, // Adaptation du nom
                row.prenom ?? row.prenomp, // Adaptation du prénom
                row.email ?? row.emailp, // Adaptation de l'email
                row.numero_telephone ?? row.numtel, // Téléphone selon type
                row.role ?? (row.idc ? "client" : "prestataire") // Déduction du rôle
            );
        } catch (error) {
            console.error("❌ Erreur dans User.fromDB:", error);
            throw new Error("Échec de création de l'utilisateur depuis la DB");
        }
    }

    static async findByEmail(email) {
        try {
            console.log("🔍 Recherche user par email:", email);
            
            // 1. Chercher dans clients
            const clientRes = await pool.query(
                "SELECT *, 'client' as role FROM client WHERE email = $1", 
                [email.toLowerCase().trim()]
            );
            
            if (clientRes.rows.length > 0) {
                return this.fromDB(clientRes.rows[0]);
            }

            // 2. Si pas trouvé, chercher dans prestataires
            const prestaRes = await pool.query(
                "SELECT *, 'prestataire' as role FROM prestataire WHERE emailp = $1", 
                [email.toLowerCase().trim()]
            );

            if (prestaRes.rows.length > 0) {
                return this.fromDB(prestaRes.rows[0]);
            }

            return null;
        } catch (error) {
            console.error("❌ Erreur User.findByEmail:", error);
            throw error;
        }
    }
}

module.exports = User;