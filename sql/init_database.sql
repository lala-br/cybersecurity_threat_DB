/*
    This script creates a database named 'CyberThreats' for investigating cyber attacks, 
    tracking threat groups, campaigns, attacks, and related publications. 
    WARNING: If a database named 'CyberThreats' already exists, this script will 
    delete it along with all its data. Use with caution to avoid accidental data loss.
*/

-- Switch context to the system 'master' database
-- Required to safely create or drop other databases
USE master;
GO

-- Check if the 'CyberThreats' database exists
-- If it exists, switch to SINGLE_USER mode and drop it
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'CyberThreats')
BEGIN
    ALTER DATABASE CyberThreats
        SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE CyberThreats;
END;
GO

-- Create the database
CREATE DATABASE CyberThreats;
GO

-- Switch context to the new database
USE CyberThreats;
GO

-- Tables
CREATE TABLE Sponsor (
    S_name VARCHAR(50) PRIMARY KEY,
    Country VARCHAR(50) NOT NULL
);

CREATE TABLE ThreatGroup (
    TG_name VARCHAR(50) PRIMARY KEY,
    S_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (S_name) REFERENCES Sponsor(S_name)
);

CREATE TABLE Alias (
    Alias VARCHAR(50),
    TG_name VARCHAR(50),
    PRIMARY KEY (Alias, TG_name),
    FOREIGN KEY (TG_name) REFERENCES ThreatGroup(TG_name)
);

CREATE TABLE Campaign (
    C_name VARCHAR(50) PRIMARY KEY,
    TG_name VARCHAR(50) NOT NULL,
    StartDate DATE,
    EndDate DATE,
    FOREIGN KEY (TG_name) REFERENCES ThreatGroup(TG_name)
);

CREATE TABLE Attack (
    AttackID INT IDENTITY(1,1),
    A_name VARCHAR(50) NOT NULL,
    Financial_Damage DECIMAL(12,2),
    C_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (AttackID, C_name),
    FOREIGN KEY (C_name) REFERENCES Campaign(C_name)
);

CREATE TABLE AttackTool (
    AT_name VARCHAR(50) PRIMARY KEY,
    Type VARCHAR(50) NOT NULL
);

CREATE TABLE Uses (
    AttackID INT,
    C_name VARCHAR(50),
    AT_name VARCHAR(50),
    PRIMARY KEY (AttackID, C_name, AT_name),
    FOREIGN KEY (AttackID, C_name) REFERENCES Attack(AttackID, C_name),
    FOREIGN KEY (AT_name) REFERENCES AttackTool(AT_name)
);

CREATE TABLE Target (
    TargetID INT IDENTITY(1,1) PRIMARY KEY,
    T_name VARCHAR(50) NOT NULL,
    Sector VARCHAR(50),
    Location VARCHAR(50)
);

CREATE TABLE AimsAt (
    TargetID INT,
    AttackID INT,
    C_name VARCHAR(50),
    PRIMARY KEY (TargetID, AttackID, C_name),
    FOREIGN KEY (TargetID) REFERENCES Target(TargetID),
    FOREIGN KEY (AttackID, C_name) REFERENCES Attack(AttackID, C_name)
);

CREATE TABLE ResearchCompany (
    RC_name VARCHAR(50) PRIMARY KEY
);

CREATE TABLE Publication (
    PublicationID INT IDENTITY(1,1),
    RC_name VARCHAR(50),
    C_name VARCHAR(50),
    Title VARCHAR(100),
    Damage VARCHAR(50),
    Publication_Type VARCHAR(50),
    Modification VARCHAR(50),
    PRIMARY KEY (PublicationID, RC_name),
    FOREIGN KEY (RC_name) REFERENCES ResearchCompany(RC_name),
    FOREIGN KEY (C_name) REFERENCES Campaign(C_name)
);

CREATE TABLE About (
    C_name VARCHAR(50),
    PublicationID INT,
    RC_name VARCHAR(50),
    Date DATE,
    PRIMARY KEY (C_name, PublicationID),
    FOREIGN KEY (C_name) REFERENCES Campaign(C_name),
    FOREIGN KEY (PublicationID, RC_name) REFERENCES Publication(PublicationID, RC_name)
);

-- TG_duplicate table
-- Purpose: Tracks threat groups that are believed to represent the same entity.
-- TG_name1 and TG_name2 are two threat groups that may be duplicates of each other.
-- Optional 'Note' column can store explanations or sources reporting the duplication.
CREATE TABLE TG_duplicate (
    TG_name1 VARCHAR(50) NOT NULL,
    TG_name2 VARCHAR(50) NOT NULL,
    Note VARCHAR(200) NULL,
    CONSTRAINT PK_TG_duplicate PRIMARY KEY (TG_name1, TG_name2),
    CONSTRAINT FK_TG1 FOREIGN KEY (TG_name1) REFERENCES ThreatGroup(TG_name),
    CONSTRAINT FK_TG2 FOREIGN KEY (TG_name2) REFERENCES ThreatGroup(TG_name)
);