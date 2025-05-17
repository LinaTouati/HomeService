const express = require("express");
const cors = require("cors");
const authRoutes = require("./routes/authRoutes");
const prestataireRoutes = require("./routes/prestaroutes"); 
const userRoutes = require("./routes/usertoute"); // 🆕 Ajout de l'import des routes user
const prestationRoutes = require("./routes/prestationRoutes"); // Ajout de l'import des routes prestation

const dotenv = require("dotenv"); 

dotenv.config();

const PORT = 3000;
const HOST = "localhost";

const app = express();

// Configuration CORS
const corsOptions = {
  origin: "*",
  methods: ["GET", "POST", "PUT", "DELETE"],
  allowedHeaders: ["Content-Type", "Authorization"], // 🆕 Ajout du header Authorization
  credentials: true,
};

app.use(cors(corsOptions));
app.use(express.json());

// Chargement des routes
console.log("🔄 AuthRoutes chargé...");
app.use("/auth", authRoutes);
app.use('/client', authRoutes); 
console.log("🔄 PrestataireRoutes chargé...");
app.use("/prestataire", prestataireRoutes);

console.log("🔄 UserRoutes chargé..."); // 🆕 Notification du chargement
app.use("/user", userRoutes); // 🆕 Ajout du préfixe /user
console.log("🔄 PrestationRoutes chargé..."); // Notification du chargement
app.use("/prestation", prestationRoutes); // Ajout du préfixe /prestation

// Route de base
app.get("/", (req, res) => {
  res.status(200).json({ status: "OK", message: "API opérationnelle" });
});

// Gestion des erreurs
app.use((err, req, res, next) => {
  console.error("🔥 Erreur serveur:", err.stack);
  res.status(500).json({
    error: "Erreur interne du serveur",
    details: process.env.NODE_ENV === "development" ? err.message : undefined,
  });
});

// Lancement du serveur
app.listen(PORT, HOST, () => {
  console.log(`✅ Serveur opérationnel sur http://${HOST}:${PORT}`);
});