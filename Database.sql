-- Database Creatation Mysql Query
CREATE DATABASE IF NOT EXISTS Healthcare;

-- Change Database as current database Mysql Query 
USE DATABASE Healthcare ;

-- Create Policy Table 
CREATE TABLE IF NOT EXISTS Policy(PolicyId BIGINT,PolicyNumber INT,PolicYHolderName VARCHAR(20)NOT NULL,PolicyStartDate DATE NOT NULL,PolicyExpirationDate DATE NOT NULL,PolicyType VARCHAR(25)NOT NULL,PRIMARY KEY(PolicyId,PolicyNumber))engine=InnoDB;

--Create CLAIMS Table -LETEST Without  FOREIGN KEY relation
CREATE TABLE IF NOT EXISTS claims(PolicyId BIGINT PRIMARY KEY,ClaimID INT  NOT NULL,ClaimApplyDate DATE  NOT NULL,ClaimServiceDate DATE,ClaimStatus VARCHAR(10)  NOT NULL,ClaimCompletionDate DATE)engine=InnoDB;

--Create CLAIMS_Transaction Table
CREATE TABLE IF NOT EXISTS CLAIMS_Transaction(TransactionId INT NOT NULL,PolicyId BIGINT NOT NULL,PolicyNumber INT NOT NULL,PolicYHolderName VARCHAR(20)NOT NULL,PolicyStartDate DATE NOT NULL,PolicyExpirationDate DATE NOT NULL,PolicyType VARCHAR(25)NOT NULL,ClaimID INT NOT NULL,ClaimType VARCHAR(20)NOT NULL,ClaimApplyDate DATE NOT NULL,ClaimServiceDate DATE,ClaimStatus VARCHAR(10)NOT NULL,ClaimCompletionDate DATE);

--Create CLAIMS Table-old 
CREATE TABLE IF NOT EXISTS claims(PolicyId BIGINT  ,PolicyNumber INT ,ClaimID INT PRIMARY KEY,ClaimType VARCHAR(20),ClaimApplyDate DATE,ClaimServiceDate DATE,ClaimStatus VARCHAR(10),ClaimCompletionDate DATE,CONSTRAINT `fk_ciaim` FOREIGN KEY (PolicyNumber)REFERENCES policy(PolicyNumber)ON UPDATE CASCADE ON DELETE RESTRICT )engine=InnoDB;

--DML Operations
----------------------------------------------------------------------
--POLICY Table INSERT query 
INSERT ignore INTO POLICY(
  PolicyId,PolicyNumber,
  PolicYHolderName,
  PolicyStartDate,
  PolicyExpirationDate,
  PolicyType
)
select
  PolicyId,
  PolicyNumber,
  PolicYHolderName,
  PolicyStartDate,
  PolicyExpirationDate,
  PolicyType 
from 
  claims_transaction;
-----------------------------------------------------------------------
--CLAIMS Table INSERT query 
INSERT INTO CLAIMS(
	PolicyId,ClaimID,
	ClaimApplyDate,
	ClaimServiceDate,
	ClaimStatus,
	ClaimCompletionDate
) 
WITH CTE AS (
select 
	PolicyId,
    ClaimID,
    ClaimApplyDate,
    ClaimServiceDate,
    ClaimStatus,
    ClaimCompletionDate,
    ROW_NUMBER() OVER(
    partition by 
		PolicyId,
        claimId
	ORDER BY 
    ClaimApplyDate desc,
    ClaimCompletionDate desc,
    ClaimStatus desc
    ) row_num 
    FROM
		claims_transaction
)
select 
	PolicyId,
    ClaimID,
    ClaimApplyDate,
    ClaimServiceDate,
    ClaimStatus,
    ClaimCompletionDate
from 
	CTE 
where 
	row_num =1;
