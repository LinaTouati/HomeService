class User {
    constructor(id, nom, prenom, email, numeroTelephone, role) {
        this.id = id;
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.numeroTelephone = numeroTelephone;
        this.role = role; // "client" ou "prestataire"
    }

    static fromDB(row) {
        return new User(
            row.idc ?? row.id, // 🔥 ID client ou prestataire
            row.nom ?? row.nomP, // 🔥 Adaptation du nom
            row.prenom ?? row.prenomP, // 🔥 Adaptation du prénom
            row.email ?? row.emailP, // 🔥 Adaptation de l'email
            row.numero_telephone ?? row.numtel, // 🔥 Téléphone en fonction du type
            row.role
        );
    }
}

module.exports = User;
