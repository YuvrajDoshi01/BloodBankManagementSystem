INSERT INTO Donor (name, phone, email) VALUES 
    ('John Smith', '555-123-4567', 'johnsmith@email.com'),
    ('Jane Doe', '555-987-6543', 'janedoe@email.com'),
    ('Mark Johnson', '555-555-5555', 'markjohnson@email.com'),
    ('Emily Chen', '555-111-2222', 'emilychen@email.com'),
    ('Michael Lee', '555-555-1212', 'michaellee@email.com'),
    ('Maria Rodriguez', '555-888-9999', 'mariarodriguez@email.com'),
    ('David Brown', '555-444-5555', 'davidbrown@email.com'),
    ('Sarah Kim', '555-222-3333', 'sarahkim@email.com'),
    ('Daniel Jones', '555-777-7777', 'danieljones@email.com'),
    ('Jennifer Davis', '555-333-4444', 'jenniferdavis@email.com');


INSERT INTO Address (street, city, state, zip_code) VALUES 
    ('123 Main St', 'Los Angeles', 'CA', '90001'),
    ('456 Elm St', 'New York', 'NY', '10001'),
    ('789 Oak St', 'Chicago', 'IL', '60601'),
    ('321 Pine St', 'San Francisco', 'CA', '94101'),
    ('654 Maple St', 'Houston', 'TX', '77001'),
    ('987 Cedar St', 'Miami', 'FL', '33101'),
    ('1111 Walnut St', 'Philadelphia', 'PA', '19101'),
    ('2222 Cherry St', 'Seattle', 'WA', '98101'),
    ('3333 Birch St', 'Boston', 'MA', '02101'),
    ('4444 Ash St', 'Atlanta', 'GA', '30301');

INSERT INTO BloodBank (name, license_number, address_id) VALUES 
    ('Red Cross', '12345', 1),
    ('BloodWorks', '54321', 2),
    ('LifeSource', '11111', 3),
    ('OneBlood', '22222', 4),
    ('Central Blood Bank', '33333', 5),
    ('Blood Assurance', '44444', 6),
    ('New York Blood Center', '55555', 7),
    ('Puget Sound Blood Center', '66666', 8),
    ('Carter BloodCare', '77777', 9),
    ('Vitalant', '88888', 10);

INSERT INTO BloodBag (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id) VALUES 
    ('A+', '250ml', '2024-04-11', '2023-04-10', 1, 1),
    ('B+', '500ml', '2024-05-10', '2023-04-05', 2, 1),
    ('O-', '250ml', '2024-04-20', '2023-04-03', 3, 2),
    ('AB+', '750ml', '2024-05-02', '2023-03-30', 4, 2),
    ('B-', '500ml', '2024-06-01', '2023-03-28', 5, 1),
    ('A+', '250ml', '2024-04-10', '2023-03-27', 6, 2),
    ('O+', '500ml', '2024-05-15', '2023-03-25', 7, 1),
    ('B+', '500ml', '2024-05-10', '2023-03-22', 8, 1),
    ('A-', '250ml', '2024-04-30', '2023-03-20', 9, 2),
    ('AB-', '750ml', '2024-05-25', '2023-03-15', 10, 1);

INSERT INTO Recipient (name, phone, email, address_id)
VALUES 
  ('John Doe', '555-1234', 'johndoe@example.com', 1),
  ('Jane Smith', '555-5678', 'janesmith@example.com', 2),
  ('Bob Johnson', '555-9876', 'bjohnson@example.com', 3),
  ('Sarah Lee', '555-5432', 'sarahlee@example.com', 4),
  ('David Kim', '555-8765', 'dkim@example.com', 5),
  ('Megan Brown', '555-2345', 'mbrown@example.com', 6),
  ('Peter Chen', '555-6543', 'pchen@example.com', 7),
  ('Linda Davis', '555-7890', 'ldavis@example.com', 8),
  ('Tom Wilson', '555-4321', 'twilson@example.com', 9),
  ('Samantha Garcia', '555-6789', 'sgarcia@example.com', 10);

INSERT INTO BloodTransfusion (transfusion_date, recipient_id, blood_bag_id)
VALUES 
  ('2022-01-01', 1, 1),
  ('2022-01-02', 2, 2),
  ('2022-01-03', 3, 3),
  ('2022-01-04', 4, 4),
  ('2022-01-05', 5, 5),
  ('2022-01-06', 6, 6),
  ('2022-01-07', 7, 7),
  ('2022-01-08', 8, 8),
  ('2022-01-09', 9, 9),
  ('2022-01-10', 10, 10);

INSERT INTO BloodTest (test_type, test_date, test_result, blood_bag_id) VALUES 
  ('HIV', '2023-04-10', 'Negative', 1),
  ('Hepatitis B', '2023-04-10', 'Positive', 2),
  ('Hepatitis C', '2023-04-09', 'Negative', 3),
  ('Syphilis', '2023-04-08', 'Positive', 4),
  ('Malaria', '2023-04-07', 'Negative', 5),
  ('West Nile Virus', '2023-04-06', 'Negative', 6),
  ('Chagas', '2023-04-05', 'Positive', 7),
  ('Zika', '2023-04-04', 'Negative', 8),
  ('HTLV', '2023-04-03', 'Negative', 9),
  ('Babesiosis', '2023-04-02', 'Positive', 10);
