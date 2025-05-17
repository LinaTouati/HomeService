const express = require("express");
const router = express.Router();
const prestationController = require("../controllers/prestationController");

// Route POST pour demander une prestation
router.post("/demander", (req, res, next) => {
  console.log("📥 Requête reçue sur /prestation/demander");
  prestationController.demanderPrestation(req, res).catch(next);
});

// Route GET pour l'historique d'un client
router.get('/historique/:idc', (req, res, next) => {
  console.log("📥 Requête reçue sur /prestation/historique/" + req.params.idc);
  prestationController.getHistoriqueClient(req, res).catch(next);
});

// Route PUT pour annuler une demande
router.put('/annuler/:idc/:idDemande', (req, res, next) => {
  console.log(`📥 Requête reçue sur /prestation/annuler/${req.params.idc}/${req.params.idDemande}`);
  prestationController.annulerDemande(req, res).catch(next);
});

module.exports = router;