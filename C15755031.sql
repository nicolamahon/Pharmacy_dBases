/*
Student Number: C15755031
Name: Nicola Mahon
Programme Code: DT228/2
Lab Group: Group C
*/

/* BEGIN DROPS: 
Drop tables if they exist */

/* These tables are dependent i.e. they contain a number of foreign keys. 
They have been listed here in order of dependency 
and must be dropped first. */
DROP TABLE Product_PackSize CASCADE CONSTRAINTS PURGE;
DROP TABLE Product_Prescription CASCADE CONSTRAINTS PURGE;
DROP TABLE NonDrugSale CASCADE CONSTRAINTS PURGE;
DROP TABLE Prescription CASCADE CONSTRAINTS PURGE;
DROP TABLE Product CASCADE CONSTRAINTS PURGE;
DROP TABLE Brand CASCADE CONSTRAINTS PURGE;
DROP TABLE Employee CASCADE CONSTRAINTS PURGE;

/* These tables are independent i.e. do not contain foreign keys 
so they can be dropped last */
DROP TABLE EmployeeRole CASCADE CONSTRAINTS PURGE;
DROP TABLE Doctor CASCADE CONSTRAINTS PURGE;
DROP TABLE Customer CASCADE CONSTRAINTS PURGE;
DROP TABLE PackSize CASCADE CONSTRAINTS PURGE;
DROP TABLE DrugType CASCADE CONSTRAINTS PURGE;
DROP TABLE Supplier CASCADE CONSTRAINTS PURGE;

/* BEGIN INSERTS: 
Tables are created in order of dependents, with those having no 
dependents created first i.e. no foreign keys */

CREATE TABLE Customer
(
	custID               VARCHAR2(5) NOT NULL ,
	custName             VARCHAR2(20) NOT NULL ,
	custAddress          VARCHAR2(50) NOT NULL ,
	custEmail            VARCHAR2(30) NULL ,
	custPhone            NUMBER(10) NOT NULL ,
	medicalCardNo        VARCHAR2(10) NULL , -- not all customers will have a medical card, nullable
--Create primary key constraint for the customer table
CONSTRAINT Customer_PK PRIMARY KEY (custID),
--Check that the pharmacy customer email contains an @ symbol at time of insertion
CONSTRAINT phcustEmail_chk CHECK (custEmail LIKE '%@%')
);

CREATE TABLE Doctor
(
	doctorID             VARCHAR2(5) NOT NULL ,
	doctorName           VARCHAR2(20) NOT NULL ,
	surgeryName          VARCHAR2(30) NULL , -- not all doctors have surgery names, nullable
	doctorAddress        VARCHAR2(50) NOT NULL ,
--Create primary key constraint for the doctor table
CONSTRAINT Doctor_PK PRIMARY KEY (doctorID)
);

CREATE TABLE DrugType
(
	drugTypeID           VARCHAR2(5) NOT NULL ,
	drugTypeName         VARCHAR2(40) NOT NULL ,
	drugTypeDose         VARCHAR2(10) NOT NULL ,
	prescriptionOnly     CHAR(1) NOT NULL , -- y/n value here 
	dispenseInstruct     VARCHAR2(300) NOT NULL ,
	custInstruct         VARCHAR2(300) NOT NULL ,
--Create primary key constraint for the DrugType table
CONSTRAINT DrugType_PK PRIMARY KEY (drugTypeID),
--Check that the only data entered into the prescriptionOnly column is a 'y' or 'n'
CONSTRAINT scriptOnly_chk CHECK (prescriptionOnly in ('y', 'n'))
);

CREATE TABLE EmployeeRole
(
	roleID               VARCHAR2(5) NOT NULL ,
	roleDescription      VARCHAR2(30) NOT NULL ,
--Create primary key constraint for the EmployeeRole table
CONSTRAINT EmployeeRole_PK PRIMARY KEY (roleID)
);

CREATE TABLE Supplier
(
	supplierID           VARCHAR2(5) NOT NULL ,
	supplierName         VARCHAR2(20) NOT NULL ,
	supplierAddress      VARCHAR2(50) NOT NULL ,
	supplierPhone        NUMBER(10) NOT NULL ,
--Create primary key constraint for the Supplier table
CONSTRAINT Supplier_PK PRIMARY KEY (supplierID)
);

CREATE TABLE PackSize
(
	sizeID               VARCHAR2(5) NOT NULL ,
	sizeDesc             VARCHAR2(10) NOT NULL ,
--Create primary key constraint for the PackSize table
CONSTRAINT PackSize_PK PRIMARY KEY (sizeID)
);

CREATE TABLE Employee
(
  -- all Employee details are manditory
	staffID              VARCHAR2(5) NOT NULL ,
	staffName            VARCHAR2(30) NOT NULL ,
	staffAddress         VARCHAR2(50) NOT NULL , -- manditory for payroll
	staffPhone           NUMBER(10) NOT NULL , -- manditory for rota scheduling and staff notifications
	staffEmail           VARCHAR2(30) NOT NULL , -- manditory for rota scheduling and staff notifications
	staffPPSno           VARCHAR2(8) NOT NULL , -- manditory for payroll
	roleID               VARCHAR2(5) NOT NULL ,
--Create primary key constraint for the Employee table
CONSTRAINT Employee_PK PRIMARY KEY (staffID),
-- Create foreign key constraint to link Employee (roleID) to EmployeeRole (roleID) table using the columns (in brackets)
CONSTRAINT EMP_EmpRole_FK FOREIGN KEY (roleID) REFERENCES EmployeeRole (roleID),
--Check that the pharmacy staff email contains an @ symbol at time of insertion
CONSTRAINT phstaffEmail_chk CHECK (staffEmail LIKE '%@%')
);

CREATE TABLE Brand
(
	brandID              NUMBER(5) NOT NULL ,
	brandName            VARCHAR2(30) NOT NULL ,
	drugTypeID           VARCHAR2(5) NULL ,	-- some brands of products are not drugs so will not have a drugTypeID
--Create primary key constraint for the Brand table
CONSTRAINT Brand_PK PRIMARY KEY (brandID),
-- Create foreign key constraint to link Brand (drugTypeID) to DrugType (drugTypeID) table using the columns (in brackets)
CONSTRAINT Brand_DrugType_FK FOREIGN KEY (drugTypeID) REFERENCES DrugType (drugTypeID)
);

CREATE TABLE Product
(
	stockCode            VARCHAR2(10) NOT NULL ,
	stockDesc            VARCHAR2(50) NOT NULL ,
	costPrice            NUMBER(4,2) NOT NULL ,
	retailPrice          NUMBER(4,2) NOT NULL ,
	supplierID           VARCHAR2(5) NOT NULL ,
	brandID              NUMBER(5) NOT NULL ,
	drug_NonDrug         CHAR(1) NOT NULL ,
	drugTypeID           VARCHAR2(5) NULL , -- some products will not be drugs so will not have a drugTypeID, nullable
--Create primary key constraint for the Product table
CONSTRAINT Product_PK PRIMARY KEY (stockCode),
-- Create foreign key constraint to link Product (supplierID) to Supplier (suppplierID) table using the columns (in brackets)
CONSTRAINT Prod_Supp_FK FOREIGN KEY (supplierID) REFERENCES Supplier (supplierID),
-- Create foreign key constraint to link Product (brandID) to Brand (brandID) table using the columns (in brackets)
CONSTRAINT Prod_Brand_FK FOREIGN KEY (brandID) REFERENCES Brand (brandID),
-- Create foreign key constraint to link Product (drugTypeID) to DrugType (drugTypeID) table using the columns (in brackets)
CONSTRAINT Prod_DrugType_FK FOREIGN KEY (drugTypeID) REFERENCES DrugType (drugTypeID),
--Check that the only data entered into the drug_nonDrug column is a 'y' or 'n'
CONSTRAINT productNONdrug_chk CHECK (drug_NonDrug in ('y', 'n'))
);

CREATE TABLE Prescription
-- A single prescription is initially partially entered, being complete only when the script is collected and paid for.
-- Therefore some fields relating to collection and payment type will be nullable at the initial entry.
(
	scriptID             VARCHAR2(5) NOT NULL ,
	custID               VARCHAR2(5) NOT NULL ,
	doctorID             VARCHAR2(5) NOT NULL ,
	doctorDosage         VARCHAR2(10) NOT NULL , -- if doctor does not specify a dose, the standard drug dosage must be included when entering the script on the system
	numberDays           NUMBER(2) NOT NULL ,
	substitute           CHAR(1) NOT NULL , -- this column is to record if the doctor has asked for a specific drug or if the Pharmacist can substitute for similar products he has in stock
	medicalCardNo        VARCHAR2(10) NULL , -- not all customers/scripts will be associated with a medical card
	loggingStaff         VARCHAR2(5) NOT NULL ,
	dispensingStaff      VARCHAR2(5) NULL , -- will be updated when script is collected 
	collectedDateTime    TIMESTAMP NULL ,	-- will be updated when script is collected
	paymentType          VARCHAR2(10) NULL , -- will be updated when script is collected
	drugTypeID           VARCHAR2(5) NOT NULL ,
--Create primary key constraint for the Prescription table
CONSTRAINT Prescription_PK PRIMARY KEY (scriptID),
--Create foreign key constraint to link Prescription (custID) to Customer (custID) table using the columns (in brackets)
CONSTRAINT Prescript_Cust_FK FOREIGN KEY (custID) REFERENCES Customer (custID),
--Create foreign key constraint to link Prescription (doctorID) to Doctor (doctorID) table using the columns (in brackets)
CONSTRAINT Prescript_Doc_FK FOREIGN KEY (doctorID) REFERENCES Doctor (doctorID),

--Two staff members are involved in the Prescription process: 1 staff to log the script, 1 staff to dispense and take payment
--Create foreign key constraint to link Prescription (loggingStaff) to Employee (staffID) table 
CONSTRAINT Prescript_EmpLog_FK FOREIGN KEY (loggingStaff) REFERENCES Employee (staffID),
--Create foreign key constraint to link Prescription (dispensingStaff) to Employee (staffID) table 
CONSTRAINT Prescript_EmpDisp_FK FOREIGN KEY (dispensingStaff) REFERENCES Employee (staffID),
--Create foreign key constraint to link Prescription (drugTypeID) to DrugType (drugTypeID) table 
CONSTRAINT Prescript_DrugType_FK FOREIGN KEY (drugTypeID) REFERENCES DrugType (drugTypeID),
--Check that the only data entered into the substitute column is a 'y' or 'n'
CONSTRAINT substitute_chk CHECK (substitute in ('y', 'n'))
);

CREATE TABLE NonDrugSale
(
	nonDrugSaleID        VARCHAR2(10) NOT NULL ,
	qtySold              NUMBER(3) NOT NULL ,
	saleDateTime         TIMESTAMP NOT NULL ,
	staffID              VARCHAR2(5) NOT NULL ,
	stockCode            VARCHAR2(10) NOT NULL ,
--Create primary key constraint for the NonDrugSale table
CONSTRAINT NonDrugSale_PK PRIMARY KEY (nonDrugSaleID),
--Create foreign key constraint to link NonDrugSale (staffID) to Employee (staffID) table 
CONSTRAINT NDSale_Emp_FK FOREIGN KEY (staffID) REFERENCES Employee (staffID),
--Create foreign key constraint to link NonDrugSale (stockCode) to Product (stockCode) table 
CONSTRAINT NDSale_Prod_FK FOREIGN KEY (stockCode) REFERENCES Product (stockCode)
);

CREATE TABLE Product_Prescription
(
	stockCode            VARCHAR2(10) NOT NULL ,
	scriptID             VARCHAR2(5) NOT NULL ,
--Create primary key constraint for the Product_Prescription table
CONSTRAINT ProdPrescript_PK PRIMARY KEY (stockCode,scriptID),
--Create foreign key constraint to link Product_Prescription (stockCode) to Product (stockCode) table 
CONSTRAINT ProdPrescript_Product_FK FOREIGN KEY (stockCode) REFERENCES Product (stockCode),
--Create foreign key constraint to link Product_Prescription (scriptID) to Prescription (scriptID) table 
CONSTRAINT ProdPrescript_Prescript_FK FOREIGN KEY (scriptID) REFERENCES Prescription (scriptID)
);

CREATE TABLE Product_PackSize
(
	stockCode            VARCHAR2(10) NOT NULL ,
	sizeID               VARCHAR2(5) NOT NULL ,
--Create primary key constraint for the Product_PackSize table
CONSTRAINT Product_PackSize_PK PRIMARY KEY (stockCode,sizeID),
--Create foreign key constraint to link Product_PackSize (stockCode) to Product (stockCode) table 
CONSTRAINT ProdPkSize_Prod_FK FOREIGN KEY (stockCode) REFERENCES Product (stockCode),
--Create foreign key constraint to link Product_PackSize (sizeID) to PackSize (sizeID) table 
CONSTRAINT ProdPkSize_PkSize_FK FOREIGN KEY (sizeID) REFERENCES PackSize (sizeID)
);

COMMIT;

/* Begin Inserting the Data into the Tables */
-- Inserts must be performed in order of dependency, so that FK values are available
-- to their dependent tables. 

INSERT INTO Customer (custID, custName, custAddress, custEmail, custPhone, medicalCardNo) VALUES('c5580','P. Ryan','12 Riverside Road','pryan@email.com',0872421480,'E548674443');
INSERT INTO Customer (custID, custName, custAddress, custPhone) VALUES('c8618','J. Kelly','235 Knights Vale',0868521479);
INSERT INTO Customer (custID, custName, custAddress, custEmail, custPhone) VALUES('c7814','M. Byrne','56 Haddens Way','mbyrne@email.com',0856986571);
INSERT INTO Customer (custID, custName, custAddress, custEmail, custPhone, medicalCardNo) VALUES('9671','D. Scanlon','13a Summerset Street','dscanlon@email.com',0835975691,'Q374151410');
INSERT INTO Customer (custID, custName, custAddress, custEmail, custPhone) VALUES('c8312','F. Hughes','184 Willow Walk','fhughes@email.com',0877577600);
INSERT INTO Customer (custID, custName, custAddress, custPhone, medicalCardNo) VALUES('c7193','E. Cummings','62c Dodder Park',0862372866,'R221679608');
INSERT INTO Customer (custID, custName, custAddress, custEmail, custPhone) VALUES('c2220','P. Stewart','116 Knights Vale','pstewart@email.com',0852374494);
INSERT INTO Customer (custID, custName, custAddress, custEmail, custPhone, medicalCardNo) VALUES('c1507','B. Blecher','42 Barton Road','bblecher@email.com',0839500721,'X154364831');
INSERT INTO Customer (custID, custName, custAddress, custEmail, custPhone, medicalCardNo) VALUES('c3214','S. Tucci','16 Glendown Drive','stucci@email.com',0872624096,'V964584767');
INSERT INTO Customer (custID, custName, custAddress, custEmail, custPhone, medicalCardNo) VALUES('c2540','A. Ferrara','99 River Course','aferrara@email.com',0862529502,'P356949597');


INSERT INTO Doctor (doctorID, doctorName, surgeryName, doctorAddress) VALUES('gp473','C. Brennan','Glenview Medical','67 Glenview Down');
INSERT INTO Doctor (doctorID, doctorName, doctorAddress) VALUES('gp548','T. Murphy','88 Sunny Grove');
INSERT INTO Doctor (doctorID, doctorName, doctorAddress) VALUES('gp517','J. Connors','92 Round Downs');
INSERT INTO Doctor (doctorID, doctorName, surgeryName, doctorAddress) VALUES('gp643','P. Sullivan','Halligan Health','31 Hazy Towers');
INSERT INTO Doctor (doctorID, doctorName, surgeryName, doctorAddress) VALUES('gp760','A. Ahmed','Templeogue Medical','41 Main Street');
INSERT INTO Doctor (doctorID, doctorName, doctorAddress) VALUES('gp787','H. Moran','32 Tawny Point');
INSERT INTO Doctor (doctorID, doctorName, doctorAddress) VALUES('gp945','P. Cullen','6 Easy Byway');
INSERT INTO Doctor (doctorID, doctorName, surgeryName, doctorAddress) VALUES('gp151','F. Fitzgerald','Suffolk Medical','6 Suffolk Street');
INSERT INTO Doctor (doctorID, doctorName, doctorAddress) VALUES('gp499','D. Johnson','3 Umber Forest');
INSERT INTO Doctor (doctorID, doctorName, surgeryName, doctorAddress) VALUES('gp368','B. Crusher','Crusher Medical Center','87 Misty Wynd');


INSERT INTO DrugType (drugTypeID, drugTypeName, drugTypeDose, prescriptionOnly, dispenseInstruct, custInstruct) VALUES('d426','Paracetamol','650mg','n','Not to be taken with other Paracetamol containing products. Avoid alcohol.','Take with water and food.Avoid alcohol. Take every 4-6 hours if needed, but do not take more than four doses in any 24-hour period. Do not take in conjunction with other Paracetamol Products.');
INSERT INTO DrugType (drugTypeID, drugTypeName, drugTypeDose, prescriptionOnly, dispenseInstruct, custInstruct) VALUES('d749','Cetirizine Hydrochloride','5mg','y','Caution in use: patients over 50, children under 12, history of stroke, history of IBS, currently taking NSAIDs.','One tablet two times a day (morning and evening). Avoid alcohol.');
INSERT INTO DrugType (drugTypeID, drugTypeName, drugTypeDose, prescriptionOnly, dispenseInstruct, custInstruct) VALUES('d264','Ibuprofen','200mg','n','No recommendation for patients <12 and >60. Not ot be taken with other NSAIDs.','Swallow 2 tablets with water. If necessary 1-2 tablets every 4 hours. Do not exceed 6 tablets in any 24 period.' );
INSERT INTO DrugType (drugTypeID, drugTypeName, drugTypeDose, prescriptionOnly, dispenseInstruct, custInstruct) VALUES('d119','Amoxicillin','250mg','y','No use beyond 14 days. No recommendation for children under 12. CONTAINS Penicillin. Contraindication: Wharfin.' ,'250 mg twice daily. Swallow the tablets whole with a glass of water at the start of a meal or slightly before. Space the doses evenly during the day, at least 4 hours apart. Do not take 2 doses in 1 hour.');


INSERT INTO EmployeeRole (roleID, roleDescription) VALUES ('role1', 'Manager');
INSERT INTO EmployeeRole (roleID, roleDescription) VALUES ('role2', 'Pharmacist');
INSERT INTO EmployeeRole (roleID, roleDescription) VALUES ('role3', 'Stock Clerk');
INSERT INTO EmployeeRole (roleID, roleDescription) VALUES ('role4', 'Counter Staff');


INSERT INTO Supplier (supplierID, supplierName, supplierAddress, supplierPhone) VALUES('sup01','Allphar','Blessington Retail Unit',012448972);
INSERT INTO Supplier (supplierID, supplierName, supplierAddress, supplierPhone) VALUES('sup02','Nutripharma','Ballyboden Industrial Area',016392486);
INSERT INTO Supplier (supplierID, supplierName, supplierAddress, supplierPhone) VALUES('sup03','Musgraves','Robinhood Retail Park',019224867);
INSERT INTO Supplier (supplierID, supplierName, supplierAddress, supplierPhone) VALUES('sup04','United Drug','Citywest Business Park',023564112);
INSERT INTO Supplier (supplierID, supplierName, supplierAddress, supplierPhone) VALUES('sup05','JSP Products','Riverwalk Enterprise Unit',052116394);


INSERT INTO PackSize (sizeID, sizeDesc) VALUES ('ps4','4pk');
INSERT INTO PackSize (sizeID, sizeDesc) VALUES ('ps6','6pk');
INSERT INTO PackSize (sizeID, sizeDesc) VALUES ('ps8','8pk');
INSERT INTO PackSize (sizeID, sizeDesc) VALUES ('ps10','10pk');
INSERT INTO PackSize (sizeID, sizeDesc) VALUES ('ps12','12pk');
INSERT INTO PackSize (sizeID, sizeDesc) VALUES ('ps24','24pk');
INSERT INTO PackSize (sizeID, sizeDesc) VALUES ('ps250','250ml');
INSERT INTO PackSize (sizeID, sizeDesc) VALUES ('ps500','500ml');


INSERT INTO Employee (staffID, roleID, staffName, staffAddress, staffPhone, staffEmail, staffPPSno) VALUES('emp01','role2','George Lucas','8 Wilmore Grove',0879553582,'glucas@email.com','6689723R');
INSERT INTO Employee (staffID, roleID, staffName, staffAddress, staffPhone, staffEmail, staffPPSno) VALUES('emp02','role1','Kevin Smith','22 Silk Road',0878930500,'kevsmith@email.com','5232362S');
INSERT INTO Employee (staffID, roleID, staffName, staffAddress, staffPhone, staffEmail, staffPPSno) VALUES('emp03','role3','James Harris','82c Palm Heights',0866729636,'jamesharris@email.com','9613812P');
INSERT INTO Employee (staffID, roleID, staffName, staffAddress, staffPhone, staffEmail, staffPPSno) VALUES('emp04','role4','Gemma Lewis','15 Lower Anchor Street',0853433766,'gemlewis@email.com','9459196T');
INSERT INTO Employee (staffID, roleID, staffName, staffAddress, staffPhone, staffEmail, staffPPSno) VALUES('emp05','role4','Elaine Buckley','1a Sycamore Drive',0838516368,'ebuck@email.com','7951038W');

-- DRUG BRANDS
INSERT INTO Brand (brandID, brandName, drugTypeID) VALUES(123,'Panadol','d426');
INSERT INTO Brand (brandID, brandName, drugTypeID) VALUES(997,'Lemsip','d426');
INSERT INTO Brand (brandID, brandName, drugTypeID) VALUES(554,'Calpol','d426');
INSERT INTO Brand (brandID, brandName, drugTypeID) VALUES(568,'Zirtek','d749');
INSERT INTO Brand (brandID, brandName, drugTypeID) VALUES(278,'Advil','d264'); 
INSERT INTO Brand (brandID, brandName, drugTypeID) VALUES(478,'Neurofen','d264');
INSERT INTO Brand (brandID, brandName, drugTypeID) VALUES(864,'Augmentin','d119');
INSERT INTO Brand (brandID, brandName, drugTypeID) VALUES(842,'Germentin','d119');
-- NON_DRUG BRANDS
INSERT INTO Brand (brandID, brandName) VALUES(679,'Kleenex');
INSERT INTO Brand (brandID, brandName) VALUES(224,'Pantene');
INSERT INTO Brand (brandID, brandName) VALUES(167,'L''Oreal');
INSERT INTO Brand (brandID, brandName) VALUES(122,'MaxFactor');
INSERT INTO Brand (brandID, brandName) VALUES(642,'Elastoplast');
INSERT INTO Brand (brandID, brandName) VALUES(636,'Compeed');


INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug) VALUES('stk013','Plasters',1.99,3.99,'sup05',636,'n');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug) VALUES('stk014','Plasters',3.65,3.3,'sup05',642,'n');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug) VALUES('stk001','Tissues',1.5,2.95,'sup03',679,'n');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug) VALUES('stk002','Mascara',4.1,9.25,'sup05',122,'n');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug) VALUES('stk003','Lipstick',5.9,12.99,'sup05',167,'n');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug) VALUES('stk004','Shampoo',4.4,9.69,'sup03',224,'n');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug, drugTypeID) VALUES('stk005','Hayfever Relief',3.5,7.7,'sup01',568,'y','d749');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug, drugTypeID) VALUES('stk006','Cough Syrup',1.95,4.29,'sup01',554,'y','d426');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug, drugTypeID) VALUES('stk007','Cold Flu Remedy',1.99,2.99,'sup01',997,'y','d426');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug, drugTypeID) VALUES('stk008','Ibuprofen',2.2,5.99,'sup02',478,'y','d264');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug, drugTypeID) VALUES('stk012','Ibuprofen',3.2,7.99,'sup01',278,'y','d264');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug, drugTypeID) VALUES('stk009','Pain Relief',1.79,2.95,'sup02',123,'y','d426');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug, drugTypeID) VALUES('stk010','Penicillin',5.42,15.45,'sup04',864,'y','d119');
INSERT INTO Product (stockCode, stockDesc, costPrice, retailPrice, supplierID, brandID, drug_NonDrug, drugTypeID) VALUES('stk011','Penicillin',3.98,10.45,'sup01',842,'y','d119');


INSERT INTO Prescription (scriptID, custID, doctorID, drugTypeID, doctorDosage, numberDays, substitute, medicalCardNo, loggingStaff, dispensingStaff, collectedDateTime, paymentType) VALUES (43731,'c1507','gp473','d749','5mg',3,'n','X154364831','emp01','emp01','2015-02-28 10:28:04','Cash');
INSERT INTO Prescription (scriptID, custID, doctorID, drugTypeID, doctorDosage, numberDays, substitute, loggingStaff) VALUES (31361,'c8618','gp548','d119','250mg',7,'n','emp02');
INSERT INTO Prescription (scriptID, custID, doctorID, drugTypeID, doctorDosage, numberDays, substitute, medicalCardNo, loggingStaff, dispensingStaff, collectedDateTime, paymentType) VALUES (11380,'c3214','gp517','d749','5mg',5,'n','V964584767','emp04','emp03','2015-11-23 10:08:30','DebitCard');
INSERT INTO Prescription (scriptID, custID, doctorID, drugTypeID, doctorDosage, numberDays, substitute, loggingStaff) VALUES (83810,'c7814','gp643','d119','125mg',14,'y','emp01');
INSERT INTO Prescription (scriptID, custID, doctorID, drugTypeID, doctorDosage, numberDays, substitute, loggingStaff) VALUES (32685,'c8312','gp760','d119','250mg',7,'y','emp05');
INSERT INTO Prescription (scriptID, custID, doctorID, drugTypeID, doctorDosage, numberDays, substitute, medicalCardNo, loggingStaff, dispensingStaff, collectedDateTime, paymentType) VALUES (86935,'c2540','gp787','d119','125mg',14,'n','P356949597','emp05','emp04','2015-10-16 11:42:06','DebitCard');
INSERT INTO Prescription (scriptID, custID, doctorID, drugTypeID, doctorDosage, numberDays, substitute, loggingStaff, dispensingStaff, collectedDateTime, paymentType) VALUES (63505,'c2220','gp499','d749','10mg',3,'n','emp04','emp05','2015-09-30 12:49:14','CreditCard');


INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds001','emp04','stk001',1,'2015-12-10 12:44:17');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds002','emp05','stk002',1,'2015-11-23 10:08:30');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds003','emp04','stk003',3,'2015-10-16 11:42:06');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds004','emp05','stk004',2,'2015-09-30 12:49:14');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds005','emp04','stk002',2,'2015-08-11 16:02:06');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds006','emp05','stk002',1,'2015-07-23 14:47:10');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds007','emp01','stk003',3,'2015-06-27 13:04:51');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds008','emp05','stk001',2,'2015-05-02 14:13:03');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds009','emp01','stk004',2,'2015-04-09 11:02:07');
INSERT INTO NonDrugSale (nonDrugSaleID, staffID, stockCode, qtySold, saleDateTime) VALUES ('nds010','emp01','stk002',4,'2015-03-25 16:36:20');

/* Many to Many Relationships */
-- stock items as they have appeared on various prescriptions
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk005', 43731);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk013', 43731);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk005', 11380);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk014', 11380);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk006', 86935);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk010', 86935);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk005', 63505);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk010', 31361);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk001', 31361);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk010', 83810);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk004', 83810);
INSERT INTO Product_Prescription (stockCode, scriptID) VALUES ('stk010', 32685);


-- various stock items in their different sizes
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk005', 'ps6');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk005', 'ps12');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk006', 'ps250');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk007', 'ps4');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk014', 'ps4');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk007', 'ps6');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk001', 'ps4');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk001', 'ps8');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk004', 'ps500');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk008', 'ps12');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk008', 'ps24');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk012', 'ps12');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk012', 'ps24');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk013', 'ps24');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk009', 'ps12');
INSERT INTO Product_PackSize (stockCode, sizeID) VALUES ('stk009', 'ps24');

COMMIT;

/* QUERIES */

/* INNER JOINS  */

--This select is to provide for the printing of sticky labels for the prescription bag
--Label should include the customers name, prescription number and last 4-digits of customer phone number.
SELECT custName "Patient Name", scriptID "Prescription No.", LPAD(SUBSTR(custPhone, 6, 9), 9, '*') "Last 4-digits of Phone No."
FROM Customer
JOIN Prescription
USING (custID)
WHERE custID = 'c2220'; --The Pharmacist need only know the custID to print their specific sticker. 


--This select is to provide for the printing of sticky labels for the prescription bottle/pack
--Label for the drug to include the Customers name, dosage, usage instructions and the 
--expiry date (based on the system date that the script is dispensed by the Pharmacist)
SELECT UPPER(custName) "Patient Name", doctorDosage||' - '||numberDays||' days.' "Dosage", 
custInstruct "Usage Instructions", 'Expires: '||ADD_MONTHS(SYSDATE, 6) "Expiration Date"
FROM Prescription 
JOIN Customer
USING (custID)
JOIN DrugType
USING (drugTypeID) 
WHERE custID = 'c1507'; --The Pharmacist need only know the custID to print their specific sticker. 

/* OUTER JOIN */

--Displays a list of NonDrugSales, identifying those staff members who have not made any sales
--Using NVL function to format any null values so that output is clearer. 
--Sadly NVL doesn't work with timestamp data types so I cannot replace those null values in the table
SELECT staffID "Staff No.", staffName "Name", saleDateTime "Sale TimeStamp", NVL(nonDrugSaleID,'No Sales in 2015')"Non Pharmacy Sale No."
FROM NonDrugSale
RIGHT OUTER JOIN Employee
USING (staffID);

--Displays list of customers with medical cards, identifying those who have / have not left in a prescription to the pharmacy in 2015
--Using NVL function to format any null values so that output is clearer. 
--Assume the script history for medical cards is cleared at Year End, therefore customers are still on system from previous years, but scripts not necessarily received for current year.
--(In reality, each customer would appear numberous times and have numberous 2015 Prescriptions listed. The data set here is small. 
SELECT medicalCardNo "Medical Card No.", custName "Name", custAddress "Address", NVL(scriptID,'No Script Received in 2015')"2015 Prescriptions"
from Customer
LEFT OUTER JOIN Prescription
USING (medicalCardNo)
WHERE medicalCardNo IS NOT NULL; -- ie they are medical card holders

/* AGGREGATE function and GROUPING */

--Average for each Staff in NonDrug sales for the period 1st Feb to 30th September 
SELECT staffID "Staff ID", staffName "Name", 
COUNT(nonDrugSaleID) "Num Sales In Period", 
TO_CHAR(AVG(qtySold * retailPrice),'fmU999.00')"Avg Sale Cost"
FROM NonDrugSale
JOIN Employee
USING (staffID)
JOIN Product
USING (stockCode)
GROUP BY staffID, staffName;

--Display the list of pack sizes and the number of products each sizes is available in.
--Useful for stock inventory
SELECT sizeDesc "Pack Size", COUNT(sizeID) "No. Prods Available in Size"
FROM Product_PackSize
JOIN PackSize
USING (sizeID)
GROUP BY sizeDesc
HAVING COUNT(sizeID) < 10;


/* ALTERATIONS: */

--1. UPDATE or DELETE selected data using a SUBQUERY.
--Here the retail price for all products that are marked as drugs is increased by 50%
UPDATE Product SET retailPrice = 1.5 * retailPrice
WHERE stockCode IN ( SELECT stockCode 
                     FROM Product
                     WHERE drug_NonDrug = 'y');
--FOR TESTING:
--Select stockDesc, retailPrice from Product;

--2. ADD a column to a table.
--Here the Employee table is updated add a new column - 'salary'. 
ALTER TABLE Employee ADD salary NUMBER (7, 2);
--FOR TESTING:
--SELECT * FROM Employee;

--3. MODIFY a column on a table.
--Here the Employee table is modified so that the staffEmail can be NULL for inserts going forward
ALTER TABLE Employee MODIFY staffEmail VARCHAR2 (30) NULL;


--4. DROP a column on a table.
--Here the recently created salary column in the Employee table is removed 
ALTER TABLE Employee DROP COLUMN salary;
--FOR TESTING:
--SELECT * FROM Employee;


--5. ADD a value constraint to a table using ALTER.
--Here the DrugType table, drugTypeDose is amended to include a check constraint that all doses are in milligrams
ALTER TABLE DrugType ADD CONSTRAINT drugDose_CHK CHECK (drugTypeDose LIKE '%mg%');
-- FOR TESTING:
-- INSERT INTO DrugType (drugTypeID, drugTypeName, drugTypeDose, prescriptionOnly, dispenseInstruct, custInstruct) VALUES('d111','test','650','n','Avoid alcohol.','Take with water and food.');


--6. Drop a constraint on a table using ALTER.
--Here the prescription table is updated to remove the check that substitute can only be a Y/N value
ALTER TABLE Prescription DROP CONSTRAINT substitute_chk;
--FOR TESTING:
--INSERT INTO Prescription (scriptID, custID, doctorID, drugTypeID, doctorDosage, numberDays, substitute, loggingStaff) VALUES (31362,'c8618','gp548','d119','250mg',7,'z','emp02');
--SELECT * FROM Prescription;