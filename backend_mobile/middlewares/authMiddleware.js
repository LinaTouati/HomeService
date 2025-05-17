const jwt = require("jsonwebtoken");

module.exports = (req, res, next) => {
  try {
    // Vérifier si le header Authorization est présent
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return res.status(401).json({ error: "Accès non autorisé. Token manquant." });
    }

    // Extraire le token
    const token = authHeader.split(" ")[1];

    // Vérifier le token JWT
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Injecter les données utilisateur dans `req`
    req.user = decoded;

    next(); // Passer à la prochaine étape
  } catch (error) {
    return res.status(401).json({ error: "Token invalide ou expiré." }); 
  }
};

