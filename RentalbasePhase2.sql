﻿REM ***************************
REM RentalBase Project Phase II
REM This SQL script was written for
REM use in Oracle Live SQL.

REM ***************************
REM PART A
REM ***************************

REM PROPERTY_TYPE:
REM This table contains a type name and description
REM and is used as an enumeration for property types
REM in the PROPERTY relation.

CREATE TABLE PROPERTY_TYPE
(
	Type				VARCHAR(12)		PRIMARY KEY,
	Description	VARCHAR(250)
);

REM INVOICE_TYPE:
REM This table contains a type name and description
REM and is used as an enumeration for invoice types
REM in the INVOICE relation.

CREATE TABLE INVOICE_TYPE
(
	Type				VARCHAR(12)		PRIMARY KEY,
	Description VARCHAR(250)
);

REM LANDLORD:
REM This table contains a unique ID, name, street,
REM city, state, zipcode, phone number and email address
REM for each landlord.

CREATE TABLE LANDLORD
(
		Id			INT						PRIMARY KEY,
    Name		VARCHAR(50)		NOT NULL,
		Street	VARCHAR(50)		NOT NULL,
    City		VARCHAR(50)		NOT NULL,
    State		VARCHAR(50)		NOT NULL,
    Zip			INT						NOT NULL,
    Phone		CHAR(10)			NOT NULL,
    Email		VARCHAR(50)		NOT NULL,
    CONSTRAINT EMAILSTRINGLORD CHECK(Email LIKE '%@%')
);

REM PROPERTY:
REM This table contains a unique property ID, landlord ID,
REM street, city, state, zipcode, value, description,
REM and property type for each property.  The landlord ID
REM references a landlord in the LANDLORD relation.  The
REM property type references the PROPERTY_TYPE relation.

CREATE TABLE PROPERTY
(
	Id				INT					PRIMARY KEY,
	Lord_ID		INT					DEFAULT 1234,
	Street		VARCHAR(50) NOT NULL,
	City			VARCHAR(50) NOT NULL,
	State			VARCHAR(50) NOT NULL,
	Zip 			INT 				NOT NULL,
	Value 		INT,
	Description VARCHAR(255),
	Type 		VARCHAR(12),
	CONSTRAINT PROPERTY_LANDLORD_FK
	FOREIGN KEY(Lord_ID) REFERENCES LANDLORD(Id) ON DELETE SET NULL,
	CONSTRAINT PROPERTY_PROPTYPE_FK
	FOREIGN KEY(Type) REFERENCES PROPERTY_TYPE(Type) ON DELETE SET NULL
);

REM TENANT:
REM This table contains a unique tenant ID, property ID, name,
REM phone number, email and registration date for each
REM tenant.  The property ID references a property in the
REM PROPERTY relation.

CREATE TABLE TENANT
(
  ID 				INT 					PRIMARY KEY,
	Prop_ID 	INT,
	Name 			VARCHAR(30) 	NOT NULL,
	Phone 		CHAR(10),
	Email 		VARCHAR(30),
	Registration_date DATE	NOT NULL,
	CONSTRAINT TENANT_PROPERTY_FK
	FOREIGN KEY(Prop_ID) REFERENCES PROPERTY(Id) ON DELETE SET NULL,
	CONSTRAINT EMAILSTRINGTEN CHECK(Email LIKE '%@%')
);

REM LEASE:
REM This table contains a unique lease ID, property ID, starting
REM date, duration in months, monthly cost and tenant ID.
REM The property ID references a property in the PROPERTY
REM relation.  The tenant ID references the TENANT relation.

CREATE TABLE LEASE
(
	ID							INT 			PRIMARY KEY,
	Prop_ID 				INT 			NOT NULL,
	Start_date 			DATE,
	Duration_months INT				DEFAULT 12,
	Monthly_rent 		FLOAT,
	Tenant_ID   		INT       NOT NULL,
	CONSTRAINT DURMIN CHECK (Duration_months >= 6),
	CONSTRAINT DURMAX CHECK (Duration_months <= 24),
	CONSTRAINT LEASE_PROPERTY_FK
	FOREIGN KEY(Prop_ID) REFERENCES PROPERTY(Id) ON DELETE CASCADE,
	CONSTRAINT LEASE_TENANT_FK
	FOREIGN KEY(Tenant_ID) REFERENCES TENANT(Id)
);


REM INVOICE:
REM This table contains a unique ID, property ID, issuing
REM date, payment date, description, cost and invoice
REM type.  The property ID references a property in the
REM PROPERTY relation.  The type references the
REM INVOICE_TYPE relation.

CREATE TABLE INVOICE
(
	ID 					INT 				PRIMARY KEY,
	Prop_ID 		INT	DEFAULT NULL,
	Date_issued DATE,
	Date_paid 	DATE,
	Description VARCHAR(255)		DEFAULT 'RENT',
	Cost 				FLOAT,
	Type 				VARCHAR(12),
	CONSTRAINT INVOICE_PROPERTY_FK
	FOREIGN KEY(Prop_ID) REFERENCES PROPERTY(Id),
	CONSTRAINT INVOICE_INVTYPE_FK
	FOREIGN KEY(Type) REFERENCES INVOICE_TYPE(Type) ON DELETE SET NULL
);

REM LEASE_TENANT:
REM This table facilitates the many-to-many relationship for
REM LEASE and TENANT it has two columns which are LeaseID
REM and TenantID

CREATE TABLE LEASE_TENANT
(
	LeaseID		INT			NOT NULL,
	TenantID	INT			NOT NULL,
	CONSTRAINT PK_LEASE_TENANT
	PRIMARY KEY(LeaseID, TenantID),
	CONSTRAINT FK_LT_LEASE
	FOREIGN KEY(LeaseID) REFERENCES LEASE(ID),
	CONSTRAINT FK_LT_TENANT
	FOREIGN KEY(TenantID) REFERENCES TENANT(ID)
);



REM ***************************
REM ***************************
REM Part B
REM ***************************
REM Sample data for PROPERTY_TYPE
REM Summary: store some enums

INSERT INTO PROPERTY_TYPE VALUES ('APT STUDIO', 'An apartment containing one room.');
INSERT INTO PROPERTY_TYPE VALUES ('APT 1BD/1BA', 'A 1 bed and 1 bath apartment');
INSERT INTO PROPERTY_TYPE VALUES ('APT 2BD/1BA', 'A 1 bed and 1 bath apartment');
INSERT INTO PROPERTY_TYPE VALUES ('APT 2BD/2BA', 'A 2 bed and 2 bath apartment');
INSERT INTO PROPERTY_TYPE VALUES ('APT 3BD/1BA', 'A 3 bed and 1 bath apartment');
INSERT INTO PROPERTY_TYPE VALUES ('APT 3BD/2BA', 'A 3 bed and 2 bath apartment');

INSERT INTO PROPERTY_TYPE VALUES ('SFH 1BD/1BA', 'A 1 bed and 1 bath Single Family Home');
INSERT INTO PROPERTY_TYPE VALUES ('SFH 2BD/1BA', 'A 2 bed and 1 bath Single Family Home');
INSERT INTO PROPERTY_TYPE VALUES ('SFH 2BD/2BA', 'A 2 bed and 2 bath Single Family Home');
INSERT INTO PROPERTY_TYPE VALUES ('SFH 3BD/1BA', 'A 3 bed and 1 bath Single Family Home');
INSERT INTO PROPERTY_TYPE VALUES ('SFH 3BD/2BA', 'A 3 bed and 2 bath Single Family Home');
INSERT INTO PROPERTY_TYPE VALUES ('SFH 4BD/2BA', 'A 3 bed and 2 bath Single Family Home');
INSERT INTO PROPERTY_TYPE VALUES ('SFH 4BD/3BA', 'A 4 bed and 3 bath Single Family Home');
INSERT INTO PROPERTY_TYPE VALUES ('SFH LARGE', 'A Single Family Home larger than 4BD/3BA');

INSERT INTO PROPERTY_TYPE VALUES ('IND WRHS', 'Warehouse space');
INSERT INTO PROPERTY_TYPE VALUES ('IND OFFICE', 'Office space');

REM Sample data for INVOICE_TYPE
REM Summary: store some enums

INSERT INTO INVOICE_TYPE VALUES ('MAINTENANCE', 'An invoice for maintenance on a specific property.');
INSERT INTO INVOICE_TYPE VALUES ('RENT', 'An invoice used for lease payments.');
INSERT INTO INVOICE_TYPE VALUES ('DAMAGE', 'An invoice used for lease payments.');
INSERT INTO INVOICE_TYPE VALUES ('REFUND', 'An invoice used for refunding tenants.');
INSERT INTO INVOICE_TYPE VALUES ('MISC', 'Miscilaneous invoice.');

REM Sample data for LANDLORD
REM Summary: store landlords.

INSERT INTO LANDLORD VALUES (1,'Joshua Lansang','332 Lake Forest Drive', 'Seattle', 'WA',  98190, 2061234567, 'jlansang@rbase.com');
INSERT INTO LANDLORD VALUES (2,'Michael Quandt','74 Lookout Ave.', 'Silverlake', 'WA', 98645, 2531234567, 'mquandt@rbase.com');
INSERT INTO LANDLORD VALUES (3,'Alex Reid','834 Ashley St.', 'Malone', 'WA', 98559, 4251234567, 'areid@rbase.com');

INSERT INTO LANDLORD VALUES (4,'C S Lewis','1946 Harper St.','Narnia','WA',00000,1234567890,'cslewis@rbase.com');
INSERT INTO LANDLORD VALUES (5,'Jacob Bain','54 Military St.','Spanaway','WA',98387,2537777777,'baintrain@rbase.com');
INSERT INTO LANDLORD VALUES (6,'Sally Newman','979 Lakeview Rd.','Lakeview','WA',98851,2223334444,'bettercallsal@rbase.com');
INSERT INTO LANDLORD VALUES (7,'Biggs Darklighter','3 Red St.','Yavin','SW',77777,3331113333,'biggs@rbase.com');
INSERT INTO LANDLORD VALUES (8,'Wedge Antilles','2 Red St.','Yavin','SW',77777,2221113333,'wedge@rbase.com');
INSERT INTO LANDLORD VALUES (9,'Guy McGee','12 Oatmeal St.','Vermillion','WA',99992,9786574635,'geemcgee@rbase.com');
INSERT INTO LANDLORD VALUES (10,'Issac Clarke','2008 Kellion St.','Aegis','WA',66666,0707070707,'iclarke@rbase.com');

REM Sample data for PROPERTY
REM Summary: store 4 properties for each type of property
REM as well as one property with no tenant.

INSERT INTO PROPERTY VALUES (1,1,'38 Galvin Road', 'Seattle', 'WA', 98181,5000,'Property Notes Here', 'SFH 1BD/1BA');
INSERT INTO PROPERTY VALUES (2,1,'61 North Mulberry St.', 'Seattle', 'WA',98194,10000,'Property Notes Here', 'APT STUDIO');
INSERT INTO PROPERTY VALUES (3,1,'87 Angel Ave', 'Seattle', 'WA',98109,15000,'Property Notes Here', 'SFH 1BD/1BA');
INSERT INTO PROPERTY VALUES (4,1,'50 Old Dr.', 'Seattle', 'WA',98174,20000,'Property Notes Here', 'SFH 1BD/1BA');

INSERT INTO PROPERTY VALUES (5,2,'9860 Cactus Lane Apt A', 'Tacoma', 'WA', 98417,4000,'Property Notes Here', 'APT 2BD/1BA');
INSERT INTO PROPERTY VALUES (6,2,'9860 Cactus Lane Apt B', 'Tacoma', 'WA', 98417,5000,'Property Notes Here', 'APT 2BD/1BA');
INSERT INTO PROPERTY VALUES (7,2,'9860 Cactus Lane Apt C', 'Tacoma', 'WA', 98417,6000,'Property Notes Here', 'APT 2BD/1BA');
INSERT INTO PROPERTY VALUES (8,2,'9860 Cactus Lane Apt D', 'Tacoma', 'WA', 98417,7000,'Property Notes Here', 'APT 2BD/1BA');

INSERT INTO PROPERTY VALUES (9,3,'7689 W. College St. Suite 1', 'Kent', 'WA', 98031,2000,'Property Notes Here', 'APT STUDIO');
INSERT INTO PROPERTY VALUES (10,3,'7689 W. College St. Suite 2', 'Kent', 'WA', 98031,3000,'Property Notes Here', 'APT STUDIO');
INSERT INTO PROPERTY VALUES (11,3,'7689 W. College St. Suite 3', 'Kent', 'WA', 98031,4000,'Property Notes Here', 'APT STUDIO');
INSERT INTO PROPERTY VALUES (12,3,'7689 W. College St. Suite 4', 'Kent', 'WA', 98031,5000,'Property Notes Here', 'APT STUDIO');

INSERT INTO PROPERTY VALUES (13,4,'1950 Harper St.','Narnia','WA',00000,1000000,'Wardrobe not included.','SFH 1BD/1BA');

REM Sample data for TENANT
REM Summary: store data tenants for each property locations

INSERT INTO TENANT VALUES (1,1,'Thomas M Anders',2063651375,'tanders@gmail.com',DATE '2010-01-01');
INSERT INTO TENANT VALUES (2,1,'Jen D Anders',2063651375,'tanders@gmail.com',DATE '2010-01-01');
INSERT INTO TENANT VALUES (3,2,'Dorothy G Wilkinson',2066482157,'dwilkinson@gmail.com',DATE'2012-02-02');
INSERT INTO TENANT VALUES (4,2,'James F Wilkinson',2066482157,'jwilkinson@gmail.com',DATE'2012-02-02');
INSERT INTO TENANT VALUES (5,3,'George A Whyte',2065501377,'gwhyte@gmail.com',DATE'2012-03-03');
INSERT INTO TENANT VALUES (6,3,'Franky Fish',2065501377,'ffish@gmail.com',DATE'2012-03-03');
INSERT INTO TENANT VALUES (7,4,'Kenneth M Cloud',4253247693,'kcloud@gmail.com',DATE'2012-04-04');

INSERT INTO TENANT VALUES (8,5,'Theresa H Corbeil',4254957464,'tcorbeil@gmail.com',DATE'2012-05-05');
INSERT INTO TENANT VALUES (9,6,'Helene C Diaz',2068719078,'hdiaz@gmail.com',DATE'2012-06-06');
INSERT INTO TENANT VALUES (10,7,'Lowell C Duque',3609844624,'lduque@gmail.com',DATE'2012-07-07');
INSERT INTO TENANT VALUES (11,8,'Juan C Burris',2068496274,'jburris@gmail.com',DATE'2012-08-08');

INSERT INTO TENANT VALUES (12,9,'Janine W Taylor',2069533210,'jtaylor@gmail.com',DATE'2017-09-09');
INSERT INTO TENANT VALUES (13,10,'Anna W Beebe',3606611025,'abeebe@gmail.com',DATE'2017-10-10');
INSERT INTO TENANT VALUES (14,11,'Ray J Crutchfield',5093104460,'rcrutchfield@gmail.com',DATE'2017-11-11');
INSERT INTO TENANT VALUES (15,12,'Julia A Mahoney',3604414963,'jmahoney@gmail.com',DATE'2017-12-12');

INSERT INTO TENANT VALUES (16,NULL,'Not A Tenant',3601234567,'nt@gmail.com',DATE'2012-07-07');



REM Sample data for LEASE
REM Summary: store lease data for each property that is occupied

INSERT INTO LEASE VALUES (1,1,DATE'2010-01-01',12,2000.00,1);
INSERT INTO LEASE VALUES (2,1,DATE'2011-01-01',12,2000.00,1);
INSERT INTO LEASE VALUES (3,1,DATE'2012-01-01',12,2100.33,1);
INSERT INTO LEASE VALUES (4,5,DATE'2012-05-05',12,1500.00,8);
INSERT INTO LEASE VALUES (5,5,DATE'2013-05-05',8,1500.00,8);
INSERT INTO LEASE VALUES (6,5,DATE'2014-05-05',8,1600.00,8);
INSERT INTO LEASE VALUES (7,5,DATE'2015-05-05',8,1700.00,8);
INSERT INTO LEASE VALUES (8,5,DATE'2016-05-05',8,1800.00,8);
INSERT INTO LEASE VALUES (9,9,DATE'2017-09-09',6,1000.00,9);
INSERT INTO LEASE VALUES (10,10,DATE'2017-10-10',6,1100.00,10);
INSERT INTO LEASE VALUES (11,11,DATE'2017-11-11',6,1200.00,11);
INSERT INTO LEASE VALUES (12,12,DATE'2017-12-12',12,1300.00,12);
INSERT INTO LEASE VALUES (13,12,DATE'2013-12-12',12,1400.00,12);
INSERT INTO LEASE VALUES (14,12,DATE'2014-12-12',12,1500.00,12);
INSERT INTO LEASE VALUES (15,12,DATE'2015-12-12',12,1600.00,12);
INSERT INTO LEASE VALUES (16,12,DATE'2016-12-12',12,1600.00,12);
INSERT INTO LEASE VALUES (17,12,DATE'2017-12-12',12,1600.66,12);

REM Making the many-to-many relationship
REM By populating the LEASE_TENANT TABLE

INSERT INTO LEASE_TENANT VALUES (1,1);
INSERT INTO LEASE_TENANT VALUES (1,2);
INSERT INTO LEASE_TENANT VALUES (2,1);
INSERT INTO LEASE_TENANT VALUES (2,2);
INSERT INTO LEASE_TENANT VALUES (3,2);

INSERT INTO LEASE_TENANT VALUES (4,8);
INSERT INTO LEASE_TENANT VALUES (5,8);
INSERT INTO LEASE_TENANT VALUES (6,8);
INSERT INTO LEASE_TENANT VALUES (7,8);
INSERT INTO LEASE_TENANT VALUES (8,8);

INSERT INTO LEASE_TENANT VALUES (9,9);
INSERT INTO LEASE_TENANT VALUES (10,10);
INSERT INTO LEASE_TENANT VALUES (11,11);

INSERT INTO LEASE_TENANT VALUES (12,12);
INSERT INTO LEASE_TENANT VALUES (13,12);
INSERT INTO LEASE_TENANT VALUES (14,12);
INSERT INTO LEASE_TENANT VALUES (15,12);
INSERT INTO LEASE_TENANT VALUES (16,12);
INSERT INTO LEASE_TENANT VALUES (17,12);




REM Sample data for INVOICE
REM Summary: store invoices data for each transaction

INSERT INTO INVOICE VALUES (1,1,DATE'2017-02-02',DATE'2017-02-02','Rent Payment',2000.00,'RENT');
INSERT INTO INVOICE VALUES (2,2,DATE'2017-03-03',DATE'2017-03-03','Rent Payment',2100.00,'RENT');
INSERT INTO INVOICE VALUES (3,3,DATE'2017-04-04',DATE'2017-04-04','Rent Payment',2200.00,'RENT');
INSERT INTO INVOICE VALUES (4,4,DATE'2017-05-05',DATE'2017-05-05','Rent Payment',2300.00,'RENT');
INSERT INTO INVOICE VALUES (5,5,DATE'2017-06-06',DATE'2017-06-06','Rent Payment',1500.00,'RENT');
INSERT INTO INVOICE VALUES (6,6,DATE'2017-07-07',DATE'2017-07-07','Rent Payment',1600.00,'RENT');
INSERT INTO INVOICE VALUES (7,7,DATE'2017-08-08',DATE'2017-08-08','Rent Payment',1700.00,'RENT');
INSERT INTO INVOICE VALUES (8,8,DATE'2017-09-09',DATE'2017-09-09','Rent Payment',1800.00,'RENT');
INSERT INTO INVOICE VALUES (9,9,DATE'2017-10-10',DATE'2017-06-06','Rent Payment',1000.00,'RENT');
INSERT INTO INVOICE VALUES (10,10,DATE'2017-11-11',DATE'2017-07-07','Rent Payment',1100.00,'RENT');
INSERT INTO INVOICE VALUES (11,11,DATE'2017-12-12',DATE'2017-08-08','Rent Payment',1200.00,'RENT');
INSERT INTO INVOICE VALUES (12,12,DATE'2018-01-01',DATE'2017-09-09','Rent Payment',1300.00,'RENT');
INSERT INTO INVOICE VALUES (13,1,DATE'2017-06-08',DATE'2017-06-18','Sink leak',500.00,'MAINTENANCE');
INSERT INTO INVOICE VALUES (14,6,DATE'2017-05-05',DATE'2017-05-10','Shower head broke',100.00,'MAINTENANCE');

REM ***************************
REM ***************************
REM PART C
REM ***************************

REM Query 1
REM Purpose: Display the property type and landlord for
REM each tenant that is renting a property.
REM Expected: A table with 15 tuples containing a tenant
REM name, the landlord in charge of the property they are
REM renting and the type of property.

SELECT T.name AS "Tenant Name",
	   L.name AS "Landlord Name",
	   P.type AS "Property Type"
FROM TENANT T
JOIN PROPERTY P ON T.prop_id=P.id
JOIN LANDLORD L ON P.lord_id=L.id;

REM Query 2
REM Purpose: Count the number of renters in each city.
REM Expected: A table containing 3 tuples that have the
REM number of renters in each city.  Output will be
REM kent 4, Seattle 7, Tacoma 4.

SELECT DISTINCT P.city, COUNT(*)
FROM TENANT T, PROPERTY P
WHERE P.ID=T.prop_id
	AND P.city = ANY (SELECT city
					  FROM PROPERTY)
GROUP BY P.city
ORDER BY P.city;

REM Query 3
REM Purpose: Show the cheapest property for each city
REM and the property landlord.
REM Expected: A table containing 4 tuples that show the
REM address, landlord and value of the cheapest property
REM per city.

SELECT L.name AS Landlord,
	P.street AS Street,
	P.city AS City,
	P.state AS State,
	P.zip AS Zipcode,
	P.value AS Value
FROM LANDLORD L, PROPERTY P
WHERE L.id = P.lord_id
	AND value = (SELECT MIN(value)
				 FROM PROPERTY P2
				 WHERE P.city=P2.city);

REM Query 4
REM Purpose: Display every tenant and property
REM address in the database.
REM Expected: A table containing 17 tuples that
REM show the address and tenant for each property.
REM One property should not have a tenant and one
REM tenant should not have a property rented.

SELECT name AS Tenant, street, city, state, zip
FROM TENANT T
FULL JOIN PROPERTY ON prop_id=PROPERTY.id;

REM Query 5
REM Purpose: Find all the tenants who has a lease
REM with a duration of 6 months or less. We used
REM 'MINUS' for this query which is equivalent
REM to 'EXCEPT'.
REM Expected: A table containing 3 tenant names.
SELECT T.name
FROM TENANT T, LEASE L
WHERE T.id=L.tenant_id
MINUS
(SELECT T.name
FROM TENANT T, LEASE L
WHERE T.id=L.tenant_id AND Duration_months > 6);

REM Query 6
REM Purpose: Find all tenants that are under a
REM landlord with the name "Joshua".
REM Expected: A table containing 7 tenant names.
SELECT T.Name
FROM LANDLORD L, TENANT T, PROPERTY P
WHERE L.id=P.lord_id
	AND P.id=T.prop_id
	AND L.name LIKE '%Joshua%';

REM Query 7
REM Purpose: Find the street address of any property
REM that has had a maintenance invoice costing more
REM than 200.
REM Expected: A table containing a single street address,
REM "9860 Cactus Lane Apt B".

SELECT P.street
FROM PROPERTY P, INVOICE I
WHERE P.id=I.prop_id AND 200 > I.cost AND I.type='MAINTENANCE';

REM Query 8
REM Purpose: Find the average monthly rent for each
REM city in the database.
REM Expected: A table containing 3 cities and their respective
REM average rent based on current leases.

SELECT city, AVG(monthly_rent)
FROM PROPERTY P, LEASE
WHERE P.id=prop_id
GROUP BY city;

REM Query 9
REM Purpose: Find each landlord who has issued a
REM maintenance work order.
REM Expected: A table containing 2 tuples with the landlord
REM name, invoice number and location for the maintenance work order.

SELECT L.name, I.id INVOICE, P.street, P.city
FROM LANDLORD L, INVOICE I, PROPERTY P
WHERE I.prop_id=P.id AND P.lord_id=L.id AND I.type='MAINTENANCE';

REM Query 10
REM Purpose: Find all the number of landlords who do not have properties to manage
REM Expected: A single value table containing the value 6



SELECT COUNT(*)

FROM LANDLORD
WHERE ID NOT IN (SELECT Lord_ID

			       FROM PROPERTY);
