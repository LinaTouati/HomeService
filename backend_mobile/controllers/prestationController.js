const { createPrestation } = require("../models/prestation");
const pool = require('../config/db');
exports.demanderPrestation = async (req, res) => {
  try {
    console.log("🟢 Body reçu :", req.body);

    const { datepresta, heurepresta, idc, idprestat, adresse, etatpresta } = req.body;

    // Vérification des champs
    if (!datepresta || !heurepresta || !idc || !idprestat || !adresse) {
      console.warn("⚠️ Champs manquants :", { datepresta, heurepresta, idc, idprestat, adresse });
      return res.status(400).json({ error: "Champs manquants" });
    }

    const prestation = await createPrestation({
      datepresta, 
      heurepresta,
      etatpresta : etatpresta || "en attente", // Prend la valeur reçue ou "en attente"
      idc,
      idprestat,
      adresse,
    });

    console.log("✅ Prestation créée :", prestation);
    res.status(201).json(prestation);
  } catch (error) {
    console.error("❌ Erreur demande prestation:", error);
    res.status(500).json({ error: "Erreur serveur", details: error.message });
  }
};

exports.getHistoriqueClient = async (req, res) => {
  const { idc } = req.params;
  try {
    const result = await pool.query(
     `SELECT p.idpresta AS id, pr.categorie AS service,TO_CHAR(p.datepresta, 'YYYY-MM-DD') AS datepresta, p.heurepresta, p.etatpresta, 
          pr.nomp AS prestataire
      FROM prestation p
      LEFT JOIN prestataire pr ON p.idprestat = pr.id
      WHERE p.idc = $1
      ORDER BY p.datepresta DESC`,
     [idc]
    );
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur', details: error.message });
  }
};

exports.annulerDemande = async (req, res) => {
  const { idc, idDemande } = req.params;
  try {
    // Vérifie que la demande appartient bien à ce client
    const result = await pool.query(
      `UPDATE prestation SET etatpresta = 'Annulée'
       WHERE idpresta = $1 AND idc = $2 RETURNING *`,
      [idDemande, idc]
    );
    if (result.rowCount === 0) {
      return res.status(404).json({ error: "Demande non trouvée ou non autorisée" });
    }
    res.json({ success: true, demande: result.rows[0] });
  } catch (error) {
    res.status(500).json({ error: 'Erreur serveur', details: error.message });
  }
};