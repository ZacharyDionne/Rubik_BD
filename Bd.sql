-- ZACHARY DIONNE, JADE MORIN & ANTHONY PROULX
-- PROJET DE SESSION
-- 31 mars 2023


-- ||----------------------------------------- CRÉATION DES TABLES -----------------------------------------||

-- TABLE TYPE()
CREATE TABLE  IF NOT EXISTS Type(
    idType INT AUTO_INCREMENT PRIMARY KEY,
    nomType VARCHAR(100) NOT NULL
);

-- TABLE Motif()
CREATE TABLE  IF NOT EXISTS Motif(
    idMotif INT AUTO_INCREMENT PRIMARY KEY,
    idType_ INT NOT NULL,
    dateCreation DATE NOT NULL,
    source TEXT NOT NULL,
    nomMotif VARCHAR(255) NOT NULL,
    imgCreation BLOB NOT NULL,
    FOREIGN KEY (idType_) REFERENCES type(idType)
);

-- TABLE Score()
CREATE TABLE  IF NOT EXISTS Scores(
    idScore INT AUTO_INCREMENT PRIMARY KEY,
    idMotifScore INT NOT NULL,
    dateScore DATE NOT NULL,
    FOREIGN KEY (idMotifScore) REFERENCES Motif(idMotif)
);


-- TABLE Utilisateur()
CREATE TABLE IF NOT EXISTS Utilisateur(
    idUtilisateur INT AUTO_INCREMENT PRIMARY KEY,
    nomUtilisateur VARCHAR(100) NOT NULL,
    motDePasseUtilisateur MD5(VARCHAR(255)) NOT NULL
);

-- ||----------------------------------------- INSERTIONS -----------------------------------------||
-- TYPES
INSERT INTO type VALUES
                 (NULL, "Motif de base"),
                 (NULL, "Motif créer par l'utilisateur");

-- MOTIFS
INSERT INTO Motif VALUES (NULL, 1, "2020-02-20", "Toi", "Allo", "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Black_and_white_Norwegian_Forest_Cat.jpg/280px-Black_and_white_Norwegian_Forest_Cat.jpg"),
                   (NULL, 2, "2019-10-12", "Chaton", "Bye", "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Black_and_white_Norwegian_Forest_Cat.jpg/280px-Black_and_white_Norwegian_Forest_Cat.jpg");

INSERT INTO Motif VALUES (NULL, 2, "2021-02-20", "Jean", "Chien", "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Black_and_white_Norwegian_Forest_Cat.jpg/280px-Black_and_white_Norwegian_Forest_Cat.jpg"),
                   (NULL, 2, "2019-10-12", "Bob", "Chat", "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Black_and_white_Norwegian_Forest_Cat.jpg/280px-Black_and_white_Norwegian_Forest_Cat.jpg");

INSERT INTO Motif VALUES (NULL, 1, "2022-02-18", "Application", "Bannane", "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Black_and_white_Norwegian_Forest_Cat.jpg/280px-Black_and_white_Norwegian_Forest_Cat.jpg"),
                   (NULL, 2, "2023-01-12", "Application", "Pomme", "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Black_and_white_Norwegian_Forest_Cat.jpg/280px-Black_and_white_Norwegian_Forest_Cat.jpg");
  
-- SCORES
INSERT INTO Scores VALUES (NULL, 2, "2023-02-02"),
                         (NULL, 3, "2022-10-22"),
                         (NULL, 3, "2023-02-02"),
                         (NULL, 4, "2023-02-02");                     



-- ||----------------------------------------- PROCÉDURES STOCKÉES -----------------------------------------||
-- Visualiser les objets selon l'id du motif

DELIMITER //
CREATE PROCEDURE motifSelonId(_idMotif INT)
BEGIN

    IF NOT EXISTS (SELECT idMotif FROM motif WHERE idMotif = _idMotif) THEN
        signal SQLSTATE '45030' SET message_text = 'Aucun résultat trouvé';
    END IF;

    SELECT type, motif.idMotif AS ID, dateCreation AS Date_Creation, nomMotif AS Nom_Motif,
                 source AS Source, imgCreation AS ImageRubik
    FROM Motif
    WHERE Motif.idMotif = _idMotif;
END //



-- Classer les motifs selon le type ainsi que le nom (RECHERCHE PAR NOM)
DELIMITER//
CREATE PROCEDURE motisSelonType(_nomMotif VARCHAR(255))
BEGIN

        IF NOT EXISTS (SELECT nomMotif FROM motif WHERE nomMotif LIKE _nomMotif) THEN
           signal SQLSTATE '45030' SET message_text = 'Aucun résultat trouvé';
        END IF;

        SELECT nomMotif, type.nomType, dateCreation, imgCreation, source
        FROM Motif
        INNER JOIN type ON type.idType = Motif.idMotif;
        WHERE Motif.nomMotif LIKE _nomMotif;
 



-- ||----------------------------------------- DÉCLENCHEURS (TRIGGERS) -----------------------------------------||

-- -----------------------------AVANT L'INSERTION MOTIF ID UNIQUE---------------------------

DELIMITER //
CREATE TRIGGER before_inser_motif_id_unique BEFORE INSERT
ON Motif
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
            resignal set message_text = 'L/nid existe déjà';
        END;
    
      -- idMotif unique
        if (select idMotif from Motif where idMotif=new.idMotif) IS NOT NULL THEN
            SIGNAL id_unique;
        END if;

        SET new.idMotif = idMotif;

END //
DELIMITER ;


--  ------------------------------------------ LES VUES ----------------------------------------------------

-- Afficher la liste complète des motifs
CREATE OR REPLACE VIEW v_MotifComplet AS
SELECT * 
FROM Motif;

-- Afficher tous les Scores
CREATE OR REPLACE VIEW v_ScoreComplet AS
SELECT *
FROM Scores;

-- Afficher tous les Scores par type
/*CREATE OR REPLACE VIEW v_ScoreComplet AS
SELECT *
FROM Scores
INNER JOIN
GROUP BY idType;
*/

-- Afficher tous les types
CREATE OR REPLACE VIEW v_Type AS
SELECT *
FROM Type;

-- Afficher tous les motifs en date décroissant
CREATE OR REPLACE VIEW v_MotifDateOrderDesc AS
SELECT *
FROM Motif
ORDER BY `dateCreation` DESC;

-- Afficher tous les motifs en date croissant
CREATE OR REPLACE VIEW v_MotifDateOrderDesc AS
SELECT *
FROM Motif
ORDER BY `dateCreation` ASC;




DROP TABLE scores;
DROP TABLE Motif;
DROP TABLE `type`;