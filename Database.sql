-- Database Creatation Mysql Query
CREATE DATABASE IF NOT EXISTS Healthcare;

-- Change Database as current database Mysql Query 
USE DATABASE Healthcare;

-- Create Policy Table 
CREATE TABLE IF NOT EXISTS Policy(PolicyId BIGINT NOT NULL,PolicyNumber INT PRIMARY KEY ,PolicYHolderName VARCHAR(20)NOT NULL,PolicyStartDate DATE NOT NULL,PolicyExpirationDate DATE NOT NULL,PolicyType VARCHAR(25)NOT NULL)engine=InnoDB;;

--Create CLAIMS Table
CREATE TABLE IF NOT EXISTS claims(PolicyId BIGINT  ,PolicyNumber INT ,ClaimID INT PRIMARY KEY,ClaimType VARCHAR(20),ClaimApplyDate DATE,ClaimServiceDate DATE,ClaimStatus VARCHAR(10),ClaimCompletionDate DATE,CONSTRAINT `fk_ciaim` FOREIGN KEY (PolicyNumber)REFERENCES policy(PolicyNumber)ON UPDATE CASCADE ON DELETE RESTRICT )engine=InnoDB;

--Create CLAIMS_Transaction Table
CREATE TABLE IF NOT EXISTS CLAIMS_Transaction(TransactionId INT NOT NULL,PolicyId BIGINT NOT NULL,PolicyNumber INT NOT NULL,PolicYHolderName VARCHAR(20)NOT NULL,PolicyStartDate DATE NOT NULL,PolicyExpirationDate DATE NOT NULL,PolicyType VARCHAR(25)NOT NULL,ClaimID INT NOT NULL,ClaimType VARCHAR(20)NOT NULL,ClaimApplyDate DATE NOT NULL,ClaimServiceDate DATE,ClaimStatus VARCHAR(10)NOT NULL,ClaimCompletionDate DATE);