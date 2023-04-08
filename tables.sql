CREATE TABLE Donor (
  ID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255),
  phone varchar(20),
  email varchar(255)
);

CREATE TABLE Address (
  ID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  street varchar(255),
  city varchar(255),
  state varchar(255),
  zip_code varchar(20)
);

CREATE TABLE BloodBank (
  ID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255),
  license_number varchar(255),
  address_id int,
  FOREIGN KEY (address_id) REFERENCES Address(ID)
);

CREATE TABLE BloodBag (
  ID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  blood_type varchar(10),
  volume varchar(10),
  expiry_date date,
  donation_date date,
  donor_id int,
  blood_bank_id int,
  FOREIGN KEY (donor_id) REFERENCES Donor(ID),
  FOREIGN KEY (blood_bank_id) REFERENCES BloodBank(ID)
);

CREATE TABLE BloodTest (
  ID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  test_type varchar(255),
  test_date date,
  test_result varchar(255),
  blood_bag_id int,
  FOREIGN KEY (blood_bag_id) REFERENCES BloodBag(ID)
);

CREATE TABLE Recipient (
  ID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(255),
  phone varchar(20),
  email varchar(255),
  address_id int,
  FOREIGN KEY (address_id) REFERENCES Address(ID)
);

CREATE TABLE BloodTransfusion (
  ID int NOT NULL AUTO_INCREMENT PRIMARY KEY,
  transfusion_date date,
  recipient_id int,
  blood_bag_id int,
  FOREIGN KEY (recipient_id) REFERENCES Recipient(ID),
  FOREIGN KEY (blood_bag_id) REFERENCES BloodBag(ID)
);

