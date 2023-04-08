INSERT INTO Donor (name, phone, email) VALUES
  ('Alice Smith', '555-1234', 'alice.smith@example.com'),
  ('Bob Johnson', '555-5678', 'bob.johnson@example.com'),
  ('Charlie Brown', '555-9012', 'charlie.brown@example.com');

INSERT INTO Address (street, city, state, zip_code) VALUES
  ('123 Main St', 'Anytown', 'CA', '12345'),
  ('456 Oak St', 'Somewhere', 'NY', '67890'),
  ('789 Pine St', 'Nowhere', 'TX', '24680');

INSERT INTO BloodBank (name, license_number, address_id) VALUES
  ('Red Cross', '12345-67890', 1),
  ('Blood Centers of America', '24680-12345', 2);

INSERT INTO BloodBag (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id) VALUES
  ('A+', '500 ml', '2023-06-01', '2023-04-01', 1, 1),
  ('B+', '250 ml', '2023-05-01', '2023-03-01', 2, 1),
  ('AB+', '750 ml', '2023-07-01', '2023-04-05', 3, 2);

INSERT INTO BloodTest (test_type, test_date, test_result, blood_bag_id) VALUES
  ('HIV', '2023-04-05', 'Negative', 1),
  ('Hepatitis B', '2023-04-05', 'Positive', 2),
  ('Hepatitis C', '2023-04-05', 'Negative', 3);

INSERT INTO Recipient (name, phone, email, address_id) VALUES
  ('David Lee', '555-2468', 'david.lee@example.com', 3),
  ('Elizabeth Kim', '555-3690', 'elizabeth.kim@example.com', 2),
  ('Frank Wang', '555-4826', 'frank.wang@example.com', 1);

INSERT INTO BloodTransfusion (transfusion_date, recipient_id, blood_bag_id) VALUES
  ('2023-04-10', 1, 1),
  ('2023-04-11', 2, 2),
  ('2023-04-12', 3, 3);


