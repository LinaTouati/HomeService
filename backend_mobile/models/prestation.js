const pool = require("../config/db");

async function createPrestation({ datepresta, heurepresta, etatpresta, idc, idprestat, adresse }) {
  const result = await pool.query(
    `INSERT INTO prestation (datepresta, heurepresta, etatpresta, idc, idprestat, adresse)
     VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
    [datepresta, heurepresta, etatpresta, idc, idprestat, adresse]
  );
  return result.rows[0];
}

module.exports = { createPrestation };   