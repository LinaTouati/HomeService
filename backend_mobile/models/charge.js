const pool = require("../config/db");
const bcrypt = require("bcrypt"); 

// Modifié pour accepter un paramètre de catégorie (optionnel)
async function getAllPrestataires(categorie) {
  let result;
  if (categorie) {
    result = await pool.query(
      'SELECT * FROM prestataire WHERE categorie = $1',
      [categorie]
    );
  } else {
    result = await pool.query('SELECT * FROM prestataire');
  }
  return result.rows;
}

module.exports = {
  getAllPrestataires,
};