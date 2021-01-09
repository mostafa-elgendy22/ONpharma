DROP DATABASE IF EXISTS Pharmacy_App_DB;
CREATE DATABASE Pharmacy_App_DB;

use Pharmacy_App_DB;

/*-------------------------------------------------------Creating Tables---------------------------------------------------------------------*/
/*This TABLE IS responsible for holding the common information among the system users*/
CREATE TABLE Account
(
    PRIMARY KEY(acc_ID),
    -- IDENTITY(starting Value, increment By)-> used for auto incrementing tuples
    acc_ID int auto_increment,
    acc_email varchar(255) NOT NULL UNIQUE,
    acc_password varchar(255) NOT NULL,

    Fname varchar(255) NOT NULL,
    Mname varchar(255) NOT NULL,
    Lname varchar(255) NOT NULL,
     
    -- 0 for men and 1 for women 
    gender bit NOT NULL,
    Bdate date NOT NULL,

    phoneNum bigint NOT NULL UNIQUE,

    -- user type 
    User_type varchar(255) NOT NULL 
);
/*---------------------Users-------------------------*/

CREATE TABLE Doctor
(
    PRIMARY KEY(doctor_acc_ID),

    doctor_acc_ID int UNIQUE,
    -- not sure about the proper data type for the degree
    doctor_degree varchar(255) NOT NULL,
    doctor_specialization varchar(255) NOT NULL,
    doctor_address varchar(255) NOT NULL,

    FOREIGN KEY (doctor_acc_ID) REFERENCES Account(acc_ID) ON DELETE CASCADE
);

CREATE TABLE Pharmacist
(
    PRIMARY KEY(Pharmacist_acc_ID),

    Pharmacist_acc_ID int UNIQUE,

    Pharmacist_salary int,
    Pharmacist_pharmacy_ID int ,

    FOREIGN KEY (Pharmacist_acc_ID) REFERENCES Account(acc_ID) ON DELETE CASCADE

);

/*----------------------------------------------------------------*/
/*------------------Related to the pharmacy----------------------*/

CREATE TABLE Pharmacy
(
    PRIMARY KEY(pharmacy_ID),

    pharmacy_ID int auto_increment,
    pharmacy_manager_ID int,

    pharmacy_name varchar(255) NOT NULL,
    pharmacy_address varchar(255) NOT NULL UNIQUE,

    FOREIGN KEY (pharmacy_manager_ID) REFERENCES Pharmacist(Pharmacist_acc_ID) ON DELETE SET NULL
);
ALTER TABLE pharmacist ADD FOREIGN KEY (Pharmacist_pharmacy_ID) REFERENCES Pharmacy(pharmacy_ID) ON DELETE SET NULL;

CREATE TABLE Pharmaceutical_Item
(
    PRIMARY KEY(item_id_barcode),
	item_id_barcode int auto_increment,
    item_name varchar(255),
    item_type varchar(255) NOT NULL,
    item_price int
);

CREATE TABLE Pharmacy_Repository
(
    PRIMARY KEY(pharmacy_ID, item_id),

    pharmacy_ID int,
    item_id int ,
    item_quantity int DEFAULT 0,

    FOREIGN KEY (pharmacy_ID) REFERENCES Pharmacy(pharmacy_ID) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Pharmaceutical_Item(item_id_barcode)
);

CREATE TABLE Purchase_operation
(
    PRIMARY KEY(operation_ID, pharmacy_ID),

    operation_ID int auto_increment,
    pharmacy_ID int,
    operation_cash int DEFAULT 0,

    FOREIGN KEY (pharmacy_ID) REFERENCES Pharmacy(pharmacy_ID)  ON DELETE CASCADE
);
/*----------------------------------------------------------------*/
/*---------------------about the patient-------------------------*/


CREATE TABLE Prescription
(
    PRIMARY KEY (Prescription_ID),

    Prescription_ID int auto_increment,
    Prescription_diagnosis varchar(255) NOT NULL,
    Prescription_date date NOT NULL,
    Patient_acc_ID int NOT NULL,
    doctor_acc_ID int NOT NULL,
    pres_status bool default 0,

    FOREIGN KEY (Patient_acc_ID) REFERENCES Account(acc_ID) ON DELETE CASCADE,
    FOREIGN KEY (doctor_acc_ID) references doctor(doctor_acc_ID) 
);

CREATE TABLE Prescription_Medicines
(
    PRIMARY KEY (Prescription_ID, Item_id),

    Quantity int default 0,
    Item_id int,
    Prescription_ID int  auto_increment,

    FOREIGN KEY (Item_id) REFERENCES Pharmaceutical_Item(item_id_barcode),
    FOREIGN KEY (Prescription_ID) REFERENCES Prescription(Prescription_ID)
);

CREATE TABLE Analysis
(
    PRIMARY key(Analysis_Name, Analysis_Date, Patient_acc_ID),

    Analysis_Name varchar(255) NOT NULL,
    Analysis_Date date NOT NULL,
    Result varchar(255) NOT NULL,
    Patient_acc_ID int NOT NULL,

    FOREIGN KEY (Patient_acc_ID) REFERENCES Account(acc_ID)
);

CREATE TABLE Scan
(
    PRIMARY KEY(Scan_Name, Scan_Date, Patient_acc_ID),

    Scan_Name varchar(255) NOT NULL,
    Scan_Date date,
    Result varchar(255) NOT NULL,
    Patient_acc_ID int NOT NULL,

    FOREIGN KEY (Patient_acc_ID) REFERENCES Account(acc_ID)
);


CREATE TABLE Chronic_Disease
(
    PRIMARY KEY(Disease_Name, Patient_acc_ID),

    Disease_Name varchar(255) NOT NULL,
    Disease_Date date NOT NULL,
    Patient_acc_ID int NOT NULL,

    FOREIGN KEY (Patient_acc_ID) REFERENCES Account(acc_ID)
);
/********************************************************************/
/**/
INSERT INTO `pharmacy_app_db`.`account` ( `acc_email`, `acc_password`, `Fname`, `Mname`, `Lname`, `gender`, `Bdate`, `phoneNum`, `User_type`) VALUES ( 'm@m.com', 'm ', 'dg', 'd', 'sf', 0, '2000-10-20', 015, 'Doctor');
INSERT INTO `pharmacy_app_db`.`account` ( `acc_email`, `acc_password`, `Fname`, `Mname`, `Lname`, `gender`, `Bdate`, `phoneNum`, `User_type`) VALUES ( 'mo@m.com', 'm ', 'dg', 'd', 'sf', 0, '2000-10-20', 0156,'pharmacist');
INSERT INTO `pharmacy_app_db`.`account` ( `acc_email`, `acc_password`, `Fname`, `Mname`, `Lname`, `gender`, `Bdate`, `phoneNum`, `User_type`) VALUES ( 'moo@m.com', 'm ', 'dg', 'd', 'sf', 0, '2000-10-20', 0157, 'Doctor');
/**/
INSERT INTO `pharmacy_app_db`.`pharmaceutical_item` (`item_id_barcode`,`item_name`, `item_type`, `item_price`) VALUES (1,'bro', 'beauty', 10);
INSERT INTO `pharmacy_app_db`.`pharmaceutical_item` (`item_id_barcode`,`item_name`, `item_type`, `item_price`) VALUES (2,'med', 'medicine', 12);
/**/
INSERT INTO `pharmacy_app_db`.`pharmacist` (`Pharmacist_acc_ID`) VALUES ('2');
/**/
INSERT INTO `pharmacy_app_db`.`pharmacy` (`pharmacy_manager_ID`, `pharmacy_name`, `pharmacy_address`) VALUES (2, 'brother', 'shobra');
/**/
INSERT INTO `pharmacy_app_db`.`pharmacy_repository` (`pharmacy_ID`, `item_id`, `item_quantity`) VALUES (1, 1, 50);
INSERT INTO `pharmacy_app_db`.`pharmacy_repository` (`pharmacy_ID`, `item_id`, `item_quantity`) VALUES (1, 2, 100);
/**/
INSERT INTO `pharmacy_app_db`.`analysis` (`Analysis_Name`, `Analysis_Date`, `Result`, `Patient_acc_ID`) VALUES ('cbc', '2000-10-10', 'DB Lecture 3 - Fall 2020.pdf','1');
/**/
INSERT INTO `pharmacy_app_db`.`chronic_disease` (`Disease_Name`, `Disease_Date`, `Patient_acc_ID`) VALUES ('brd', '2000-10-10', '1');
/**/
INSERT INTO `pharmacy_app_db`.`doctor` (`doctor_acc_ID`, `doctor_degree`, `doctor_specialization`, `doctor_address`) VALUES ('3', 'bech', 'suergery', 'shobra');
/**/
INSERT INTO `pharmacy_app_db`.`prescription` (`Prescription_ID`, `Prescription_diagnosis`, `Prescription_date`, `Patient_acc_ID`, `doctor_acc_ID`) VALUES ('1', 'DB Lecture 1 - Fall 2020.pdf', '2000-10-10', '1', '3');
/**/
INSERT INTO `pharmacy_app_db`.`prescription_medicines` (`Quantity`, `Item_id`, `Prescription_ID`) VALUES ('5', 1, '1');
/**/
INSERT INTO `pharmacy_app_db`.`purchase_operation` (`operation_ID`, `pharmacy_ID`, `operation_cash`) VALUES ('1', '1', '10');
/**/
INSERT INTO `pharmacy_app_db`.`scan` (`Scan_Name`, `Scan_Date`, `Result`, `Patient_acc_ID`) VALUES ('leg', '2000-10-10', 'DB Lecture 1 - Fall 2020.pdf', '1');
INSERT INTO `pharmacy_app_db`.`scan` (`Scan_Name`, `Scan_Date`, `Result`, `Patient_acc_ID`) VALUES ('scan2', '2000-10-10', 'DB Lecture 6 - Fall 2020.pdf', '1');
/**/

