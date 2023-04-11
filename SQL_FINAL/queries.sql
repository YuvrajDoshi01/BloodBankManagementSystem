-- Retrieve the list of all blood units based on their current availiblity status
SELECT b.ID, b.blood_type, b.volume, b.expiry_date, bb.name AS blood_bank_name,
CASE 
   WHEN b.ID IS NULL THEN 'Available'
   ELSE 'Not Available'
END AS availability_status
FROM BloodBag b
LEFT JOIN BloodTransfusion bt ON b.ID = bt.blood_bag_id
LEFT JOIN BloodBank bb ON b.blood_bank_id = bb.ID;

-- Update the inventory of Blood units after a new donation
UPDATE BloodBag
SET donation_date = CURRENT_DATE, donor_id = 1, blood_bank_id = 1
WHERE ID = 1;

-- Retrieve the list of all donors along with their personal details and donation history
SELECT d.ID, d.name, d.phone, d.email, COUNT(b.ID) AS donation_count
FROM Donor d
LEFT JOIN BloodBag b ON d.ID = b.donor_id
GROUP BY d.ID;

-- Add a new donor to the database
INSERT INTO Donor (name, phone, email) 
VALUES ('John Doe', '555-1234', 'johndoe@example.com');

INSERT INTO Address (street, city, state, zip_code) 
VALUES ('123 Main St', 'Anytown', 'CA', '12345');

INSERT INTO BloodBank (name, license_number, address_id) 
VALUES ('ABC Blood Bank', '12345', LAST_INSERT_ID());

INSERT INTO BloodBag (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id) 
VALUES ('O+', '500ml', '2024-04-11', '2023-04-11', LAST_INSERT_ID(), LAST_INSERT_ID());

-- Add a new blood unit to the inventory 
INSERT INTO BloodBag (blood_type, volume, expiry_date, blood_bank_id)
VALUES ('A+', '50ml', '2022-04-04', 10);

-- Retrieve the information of all the donors whose blood group is AB+
SELECT d.ID, d.name, d.phone, d.email, b.blood_type
FROM Donor d
JOIN BloodBag b ON d.ID = b.donor_id
WHERE b.blood_type = 'AB+';

-- Delete the information of a specific donor
DELETE Donor, Address, BloodBag, BloodTest
FROM Donor
LEFT JOIN Address ON Donor.address_id = Address.ID
LEFT JOIN BloodBag ON Donor.ID = BloodBag.donor_id
LEFT JOIN BloodTest ON BloodBag.ID = BloodTest.blood_bag_id
WHERE Donor.ID = 1;



-- Retrieve the list of blood Units that are about to expire in the next 30 days
SELECT b.ID, b.blood_type, b.volume, b.expiry_date, bb.name AS blood_bank_name
FROM BloodBag b
JOIN BloodBank bb ON b.blood_bank_id = bb.ID
WHERE b.expiry_date BETWEEN CURRENT_DATE AND DATE_ADD(CURRENT_DATE, INTERVAL 30 DAY);