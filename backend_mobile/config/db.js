const { Pool } = require('pg');

const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'nv_appli',
    password: '123',
    port: 5432,
});

pool.on('connect', () => {
    console.log('✅ Connexion réussie à la base de données');
});

pool.on('error', (err) => {
    console.error('❌ Erreur de connexion', err);
});

module.exports = pool; // ✅ Ne pas fermer la connexion ici !
