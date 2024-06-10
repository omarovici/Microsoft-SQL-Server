CREATE DATABASE Airline
use Airline

CREATE TABLE Airline
(
    ALID INT PRIMARY KEY NOT NULL , 
    ALNAME VARCHAR(20) ,
    AL_ADDRESS VARCHAR(50) ,
    CONTACTP VARCHAR(20) ,
)

CREATE TABLE Aircraft
(
    ACID INT PRIMARY KEY NOT NULL,
    CAPACITY INT ,
    MODEL VARCHAR(15) ,
    MAJ_PILOT VARCHAR(20) ,
    ASSISTANT VARCHAR(20) ,
    HOST1 VARCHAR(20) ,
    HOST2 VARCHAR(20) ,
    ALID INT ,
    FOREIGN KEY (ALID) REFERENCES Airline(ALID) ,
)

CREATE TABLE Airline_Phones
(
    ALID INT NOT NULL ,
    FOREIGN KEY (ALID) REFERENCES Airline (ALID) ,
    ALPHONES INT NOT NULL,
    PRIMARY KEY (ALID,ALPHONES) ,
)

CREATE TABLE Transaction1
(
    TID INT PRIMARY KEY NOT NULL,
    TDESCRIPTION VARCHAR(50) ,
    AMOUNT MONEY NOT NULL ,
    TDATE DATE ,
    ALID INT ,
    FOREIGN KEY (ALID) REFERENCES Airline (ALID) ,
)

CREATE TABLE Employee
(
    EID INT PRIMARY KEY NOT NULL ,
    ENAME VARCHAR(20) NOT NULL,
    EADDRESS VARCHAR(50) ,
    EGENDER CHAR ,
    EPOSITION VARCHAR(20) ,
    EDOB DATE,
    ALID INT ,
    FOREIGN KEY (ALID) REFERENCES Airline (ALID) ,
)

CREATE TABLE EMP_Qualifications
(
    EID INT NOT NULL,
    FOREIGN KEY (EID) REFERENCES Employee (EID) ,
    Qualifications VARCHAR(50) NOT NULL,
    PRIMARY KEY (EID,Qualifications) , 
)

CREATE TABLE Route
(
    RID INT PRIMARY KEY NOT NULL , 
    RDISTANCE INT ,
    RDESTINATION VARCHAR(20) NOT NULL,
    RORIGIN VARCHAR(20) , 
    RCLASS VARCHAR(20) ,
)

CREATE TABLE Aircraft_Route
(
    ACID INT NOT NULL,
    FOREIGN KEY (ACID) REFERENCES Aircraft (ACID) ,
    RID INT NOT NULL,
    FOREIGN KEY (RID) REFERENCES Route (RID) ,
    DEPARTURE DATETIME NOT NULL ,
    NOP INT ,
    PRICE MONEY ,
    ARRIVAL DATETIME NOT NULL,
    PRIMARY KEY (ACID,RID,DEPARTURE) ,
)