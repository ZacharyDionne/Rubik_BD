-- ||------------------------------------------------ CRÉATION DES TABLES ------------------------------------------------||

-- TABLE Type()
CREATE TABLE Type(
    idType INT AUTO_INCREMENT PRIMARY KEY,
    nomType ENUM('Motif de base', 'Motif créer par un utilisateur') NOT NULL
);


-- TABLE Motif()
CREATE TABLE Motif(
    idMotif INT AUTO_INCREMENT PRIMARY,







    type 
    FOREIGN KEY (idMotifCreer) REFERENCES MotifsCreer(idCreer),
    FOREIGN KEY (idMotifBase) REFERENCES MotifsBase(idBase)
);

-- TABLE MotifsCreer()
CREATE TABLE MotifsCreer (
  idCreer INT AUTO_INCREMENT PRIMARY KEY,
  dateCreer DATE NOT NULL,
  createur VARCHAR(255) NOT NULL,
  imgCreer TEXT NOT NULL,
  type BOOL NOT NULL,
  nomMotifCreer VARCHAR(255) NOT NULL,
  FOREIGN KEY (type) REFERENCES idType()  
);

-- TABLE MotifsBase ---------------
CREATE TABLE MotifsBase(

);
- idBase
-positionBase
- imgBase
- nomBase
- type




