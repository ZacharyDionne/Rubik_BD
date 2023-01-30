-- ZACHARY DIONNE, JADE MORIN & ANTHONY PROULX
-- PROJET DE SESSION
-- 31 mars 2023


-- ||----------------------------------------- CRÉATION DES TABLES -----------------------------------------||

-- TABLE Type()
CREATE TABLE  IF NOT EXISTS Type(
    idType INT AUTO_INCREMENT PRIMARY KEY,
    nomType ENUM('Motif de base', 'Motif créer par un utilisateur') NOT NULL
);

-- TABLE Motif()
CREATE TABLE  IF NOT EXISTS Motif(
    idMotif INT AUTO_INCREMENT PRIMARY KEY,
    type INT NOT NULL,
    dateCreation DATE NOT NULL,
    source VARCHAR(255) NOT NULL,
    nomMotif VARCHAR(255) NOT NULL,
    imgCreation TEXT NOT NULL,
    FOREIGN KEY (type) REFERENCES type(idType)
);

-- TABLE Score()
CREATE TABLE  IF NOT EXISTS Scores(
    idScore INT AUTO_INCREMENT PRIMARY KEY,BIGINT
    idMotifScore INT NOT NULL,
    createur VARCHAR(255) NOT NULL,
    nomMotif VARCHAR(255) NOT NULL
    dateScore DATE NOT NULL,
    FOREIGN KEY (idMotifScore) REFERENCES Motif(idMotif),
    FOREIGN KEY (nomMotif) REFERENCES Motif(nomMotif),
    FOREIGN KEY (createur) REFERENCES Motif(createur)
);



-- ||----------------------------------------- PROCÉDURES STOCKÉES -----------------------------------------||
-- AJOUT D'UN MOTIF PAR UN UTILISATEUR








-- ||----------------------------------------- DÉCLENCHEURS (TRIGGERS) -----------------------------------------||

-- -----------------------------AVANT L'INSERTION MOTIF ---------------------------

DELIMITER //
CREATE TRIGGER before_inser_motif BEFORE INSERT
ON Motifs
FOR EACH ROW
BEGIN

-- Déclaration des conditions
    DECLARE id_unique CONDITION FOR SQLSTATE '45020'
    

--  ---------------------------------------------------------------------------------------------------
    -- ID client UNIQUE
    DECLARE EXIT HANDLER FOR SQLSTATE '45020'
        BEGIN
            RESIGNAL SET MESSAGE_TEXT = 'ID existe déjà';
        begin
            resignal set message_text = 'L/nid existe d j .';
        END;
    
      -- idMotif unique
        if (select idMotif from Motifs where idMotif=new.idMotif) IS NOT NULL THEN
            SIGNAL id_unique;
        END if;

        SET new.idMotif = idMotif;

end //
delimiter ;



--  ------------------------------------------ LES VUES ----------------------------------------------------

-- Afficher la liste complète des motifs
CREATE OR REPLACE VIEW v_MotifComplet AS
SELECT * 
FROM Motifs;

-- Afficher tous les Scores
CREATE OR REPLACE VIEW v_ScoreComplet AS
SELECT *
FROM Scores;

-- Afficher tous les types
CREATE OR REPLACE VIEW v_Type AS
SELECT *
FROM Types;

-- Motifs qui ont un score seulement
  CREATE OR REPLACE VIEW v_ScoreMotifs AS
    SELECT nom_utilisateur, nom, prenom
    FROM utilisateurs;
 --   INNER JOIN score ON trajet.id_Trajet = localisation.id_trajet


CREATE OR REPLACE VIEW v_Materiel AS
    SELECT *
    FROM materiel;

CREATE OR REPLACE VIEW v_Prets AS
    SELECT *
    FROM prets;

CREATE OR REPLACE VIEW v_DetailsPret AS
    SELECT *
    FROM details_pret;

INSERT INTO utilisateurs (nom_utilisateur, nom, prenom, mot_de_passe) VALUES
('JohnDoe123','Doe', 'John','JohnDoe123');

INSERT INTO clients(id, nom, email, no_telephone, poste, no_bureau, type) VALUES
(null ,'BBB', 'BBB@BBB.BBB', '819-239-293', 32, 32, 'Professeur');



