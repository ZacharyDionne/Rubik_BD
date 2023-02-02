-- ZACHARY DIONNE, JADE MORIN & ANTHONY PROULX
-- PROJET DE SESSION
-- 31 mars 2023


-- ||----------------------------------------- CRÉATION DES TABLES -----------------------------------------||

-- TABLE Type()
CREATE TABLE  IF NOT EXISTS Type(
    idType INT AUTO_INCREMENT PRIMARY KEY,
    nomType VARCHAR(255) NOT NULL
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
    idScore INT AUTO_INCREMENT PRIMARY KEY,
    idMotifScore INT NOT NULL,
    createur VARCHAR(255) NOT NULL,
    nomMotif VARCHAR(255) NOT NULL,
    dateScore DATE NOT NULL
);

-- ||----------------------------------------- INSERTIONS -----------------------------------------||
-- TYPES
INSERT INTO type VALUES
                 (NULL, "Motif de base"),
                 (NULL, "Motif créer par l'utilisateur");

-- MOTIFS
INSERT INTO 

-- SCORES

INSERT INTO Motif VALUES (NULL, )






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
    WHERE gps.idMotif = _idMotif;
END //







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

-- Afficher tous les motifs en date décroissant
CREATE OR REPACE VIEW v_MotifDateOrderDesc AS
SELECT *
FROM Motifs
ORDER BY date DESC;

-- Afficher tous les motifs en date croissant
CREATE OR REPACE VIEW v_MotifDateOrderDesc AS
SELECT *
FROM Motifs
ORDER BY date ASC;


