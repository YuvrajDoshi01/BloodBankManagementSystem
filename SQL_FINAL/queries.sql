-- Retrieve the list of all blood units based on their current availiblity status

SELECT b.ID,
       b.blood_type,
       b.volume,
       b.expiry_date,
       bb.name AS blood_bank_name,
       CASE
           WHEN b.ID IS NULL THEN 'Available'
           ELSE 'Not Available'
       END AS availability_status
FROM BloodBag b
LEFT JOIN BloodTransfusion bt ON b.ID = bt.blood_bag_id
LEFT JOIN BloodBank bb ON b.blood_bank_id = bb.ID
ORDER BY availability_status;

-- Update the inventory of Blood units after a new donation
-- KEEP IN MIND TO CHANGE THE DONOR_ID, BLOOD_BANK_ID, BLOOD_TYPE and DATES

INSERT INTO BloodBag (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id)
VALUES ('O+',
        '500 ml',
        DATE_ADD(NOW(), INTERVAL 56 DAY),
        NOW(),
        donor_id,
        blood_bank_id);

-- Retrieve the list of all donors along with their personal details and donation history

SELECT Donor.ID,
       Donor.name AS donor_name,
       Donor.phone AS donor_phone,
       Donor.email AS donor_email,
       BloodBag.blood_type AS blood_type,
       BloodBag.volume AS blood_volume,
       BloodBag.expiry_date AS expiry_date,
       BloodBag.donation_date AS donation_date,
       BloodBank.name AS blood_bank_name
FROM Donor
JOIN BloodBag ON Donor.ID = BloodBag.donor_id
JOIN BloodBank ON BloodBag.blood_bank_id = BloodBank.ID;

-- Add a new donor to the database
-- We assume that we need to add all the details together

INSERT INTO Donor (name, phone, email)
VALUES ('John Doe',
        '555-1234',
        'johndoe@example.com');


INSERT INTO Address (street, city, state, zip_code)
VALUES ('123 Main St',
        'Anytown',
        'CA',
        '12345');

-- Adding a BloodBank to the database,

INSERT INTO BloodBank (name, license_number, address_id)
VALUES ('ABC Blood Bank',
        '12345',
        LAST_INSERT_ID());

-- Adding a donation from the new user to the new BloodBank

INSERT INTO BloodBag (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id)
VALUES ('O+',
        '500ml',
        '2024-04-11',
        '2023-04-11',
        LAST_INSERT_ID(),
        LAST_INSERT_ID());

-- Add a new blood unit to the inventory

INSERT INTO BloodBag (blood_type, volume, expiry_date, blood_bank_id)
VALUES ('A+',
        '50ml',
        '2022-04-04',
        10);

-- Retrieve the information of all the donors whose blood group is AB+

SELECT d.ID,
       d.name,
       d.phone,
       d.email,
       b.blood_type
FROM Donor d
JOIN BloodBag b ON d.ID = b.donor_id
WHERE b.blood_type = 'AB+';

-- Retrieve the information of all the donors whose blood group contains the BloodFactor B(B+/B-/AB+/AB-)
-- Change the BloodFactor to whichever factor blood you would like to see the matches of

SELECT d.ID,
       d.name,
       d.phone,
       d.email,
       b.blood_type
FROM Donor d
JOIN BloodBag b ON d.ID = b.donor_id
WHERE b.blood_type like '%B%';

-- Delete the information of a specific donor
-- Change the Donor.ID to whatever ID you like to delete

DELETE Donor,
       Address,
       BloodBag,
       BloodTest
FROM Donor
LEFT JOIN Address ON Donor.ID= Address.ID
LEFT JOIN BloodBag ON Donor.ID = BloodBag.donor_id
LEFT JOIN BloodTest ON BloodBag.ID = BloodTest.blood_bag_id
WHERE Donor.ID = 1;

-- Retrieve the list of blood Units that are about to expire in the next 30 days

SELECT b.ID,
       b.blood_type,
       b.volume,
       b.expiry_date,
       bb.name AS blood_bank_name
FROM BloodBag b
JOIN BloodBank bb ON b.blood_bank_id = bb.ID
WHERE b.expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY);

-- Retrieve the information of all the donors who can donate to a person with the blood group of B+
-- For A+ change (B+,O+,B-,O-) to (A+, O+, A-, O-)
-- For A- change to (O-, A-)
-- Similarly do for every blood type

SELECT d.ID,
       d.name,
       d.phone,
       d.email,
       b.blood_type
FROM Donor d
JOIN BloodBag b ON d.ID = b.donor_id
WHERE b.blood_type IN ('B+',
                       'O+',
                       'B-',
                       'O-');