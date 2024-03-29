-- ZACHARY DIONNE, JADE MORIN & ANTHONY PROULX
-- PROJET DE SESSION
-- 31 mars 2023


-- ||----------------------------------------- CRÉATION DES TABLES -----------------------------------------||

-- TABLE TYPE()
CREATE TABLE  IF NOT EXISTS Type(
    idType INT AUTO_INCREMENT PRIMARY KEY,
    nomType VARCHAR(100) NOT NULL
);


-- TABLE Utilisateur()
CREATE TABLE IF NOT EXISTS Utilisateur(
    idUser INT AUTO_INCREMENT PRIMARY KEY,
    nomUtilisateur VARCHAR(100) NOT NULL UNIQUE,
    motDePasseUtilisateur VARCHAR(255) NOT NULL
);

-- TABLE Motif()
CREATE TABLE  IF NOT EXISTS Motif(
    idMotif INT AUTO_INCREMENT PRIMARY KEY,
    idType_ INT NOT NULL,
    idUser_ INT NOT NULL,
    dateCreation VARCHAR(10) NOT NULL,
    source TEXT NOT NULL,
    nomMotif VARCHAR(255) NOT NULL,
    imgCreation BLOB NOT NULL,
    dataJson TEXT NOT NULL,
    FOREIGN KEY (idType_) REFERENCES type(idType),
    FOREIGN KEY (idUser_) REFERENCES utilisateur(idUser)
);

-- TABLE Score()
CREATE TABLE  IF NOT EXISTS Scores(
    idScore INT AUTO_INCREMENT PRIMARY KEY,
    idMotifScore INT NOT NULL,
    dateScore DATE NOT NULL,
    FOREIGN KEY (idMotifScore) REFERENCES Motif(idMotif)
);


-- ||----------------------------------------- INSERTIONS -----------------------------------------||
-- TYPES
INSERT INTO type VALUES
                 (NULL, "Motif de base"),
                 (NULL, "Motif créer par l'utilisateur");

-- UTILISATEURS
 INSERT INTO utilisateur VALUES(NULL, "admin", "admin"),
                                (NULL, "titi", "titi"),
                                (NULL, "a", "a"),
                                (NULL, "louis", "123");               

-- MOTIFS
INSERT INTO Motif VALUES (NULL, 1, 2, "2020-02-20", "Internet", "Le Superflip", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/LeSuperFlip.png", "U R2 F B R B2 R U2 L B2 R U' D' R2 F R' L B2 U2 F2"),
                         (NULL, 1, 1,  "2022-02-18", "Internet", "Êtes-vous défoncé?", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/EtesVousDefonce.png", "L R' U2 D2 L’R U2 D2 R2 L2"),
                         (NULL, 2, 2, "2023-01-12", "Internet", "( ! ) (~^O^~)", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/(%20!%20)%20(~%5EO%5E~).png" , "U' F2 R' L’U' B R2 D B U' R2 L B2 D’B2 U F2 B2 U' L2 B2 L2"),
                         (NULL, 2, 1, "2021-02-20", "Internet", "Fleur", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/Fleur.png", "R2 D2 R2 U2 R2 F2 U2 D2 F2 U2"),
                         (NULL, 2, 1, "2019-10-12", "Internet", "Le bol de fruit", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/BolDeFruit.png", "B2 L2 F2 R2 F2 R2 D U B2 U2 B' F' L' R' D' U"),
                         (NULL, 1, 1,  "2022-02-18", "Internet", "Cube dans un cube dans un cube", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/CubeDansUnCubeDansUnCube.png", "U' L’U' F' R2 B' R F U B2 U B' L U' F U R F'"),
                         (NULL, 2, 2, "2023-01-12", "Internet", "Kilt (jupe écossaise)", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/Kilt.png" , "U' R2 L2 F2 B2 U' R L F B' U F2 D2 R2 L2 F2 U2 F2 U' F2"),
                         (NULL, 1, 1,  "2022-02-18", "Internet", "Nappe", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/Nappe.png", "R L U2 F' U2 D2 R2 L2 F' D2 F2 D R2 L2 F2 B2 D B2 L2"),
                         (NULL, 2, 2, "2023-01-12", "Internet", "Mathématiques rapide 1+1", "http://cours.cegep3r.info/H2023/420606RI/GR04/ImageCube/MathematiqueRapide.png" , "R L F2 U2 R' L’F2 U2 R2 F2 U R2 L2 F2 B2 D'");
  
INSERT INTO motif VALUE (NULL, 2,2, "2023-01-31", "Internet", "Salut tout autour!", "https://ruwix.com/pics/rubiks-cube/patterns/hi-all-around.svg", "U2 R2 F2 U2 D2 F2 L2 U2")
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
DROP Table utilisateur;