from flask import Flask, jsonify, request
from flask_mysqldb import MySQL

app = Flask(__name__)

# MySQL configurations
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '8875093192'
app.config['MYSQL_DB'] = 'blood_bank2'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
mysql = MySQL(app)

# 1) Retrieve the blood units with their current availability status
@app.route('/blood_units', methods=['GET'])
def retrieve_blood_units():
    cur = mysql.connection.cursor()
    cur.execute('''SELECT blood_type, SUM(volume) AS total_volume,
                   SUM(CASE WHEN expiry_date >= CURDATE() THEN volume ELSE 0 END) AS available_volume
                   FROM BloodBag
                   GROUP BY blood_type;''')
    result = cur.fetchall()
    cur.close()
    return jsonify(result)

# 2) Update the inventory after a new donation
@app.route('/donation', methods=['POST'])
def update_inventory():
    blood_type = request.json['blood_type']
    volume = request.json['volume']
    expiry_date = request.json['expiry_date']
    donation_date = request.json['donation_date']
    donor_id = request.json['donor_id']
    blood_bank_id = request.json['blood_bank_id']
    cur = mysql.connection.cursor()
    cur.execute('''INSERT INTO BloodBag (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id)
                   VALUES (%s, %s, %s, %s, %s, %s)''',
                (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id))
    mysql.connection.commit()
    cur.close()
    return jsonify({'message': 'Inventory updated successfully!'})

# 3) Retrieve the list of all donors with their donation history
@app.route('/donors', methods=['GET'])
def retrieve_donors_with_donation_history():
    cur = mysql.connection.cursor()
    cur.execute('''SELECT Donor.*, BloodBag.blood_type, BloodBag.donation_date, BloodBag.expiry_date
                   FROM Donor
                   LEFT JOIN BloodBag
                   ON Donor.ID = BloodBag.donor_id
                   ORDER BY Donor.ID;''')
    result = cur.fetchall()
    cur.close()
    return jsonify(result)

# 4) Adding a new donor to the database
@app.route('/donor', methods=['POST'])
def add_donor():
    name = request.json['name']
    phone = request.json['phone']
    email = request.json['email']
    cur = mysql.connection.cursor()
    cur.execute('''INSERT INTO Donor (name, phone, email)
                   VALUES (%s, %s, %s)''',
                (name, phone, email))
    mysql.connection.commit()
    cur.close()
    return jsonify({'message': 'Donor added successfully!'})

# 5) Update the information of the donor
@app.route('/donor/<int:donor_id>', methods=['PUT'])
def update_donor_information(donor_id):
    name = request.json['name']
    phone = request.json['phone']
    email = request.json['email']
    cur = mysql.connection.cursor()
    cur.execute('''UPDATE Donor SET name = %s, phone = %s, email = %s
                   WHERE ID = %s''',
                (name, phone, email, donor_id))
    mysql.connection.commit()
    cur.close()
    return jsonify({'message': 'Donor information updated successfully!'})

@app.route('/donors/blood_group/<blood_group>')
def retrieve_donors_with_blood_group(blood_group):
    try:
        # Connect to the database
        connect = mysql.connect
        cursor = connect.cursor()

        # Query the database for donors with the specified blood group
        query = "SELECT Donor.ID, Donor.name, Donor.phone, Donor.email, BloodBag.blood_type, BloodBag.donation_date FROM Donor JOIN BloodBag ON Donor.ID = BloodBag.donor_id WHERE BloodBag.blood_type = %s"
        cursor.execute(query, (blood_group,))
        result = cursor.fetchall()
        # Create a list of dictionaries representing each donor's information
        donors = []
        for row in result:
            print(row)
            donor = {
                'id': row.get('id'),
                'name': row.get('name'),
                'phone': row.get('phone'),
                'email': row.get('email'),
                'blood_type': row.get('blood_type'),
                'donation_date': row.get('donation_date').strftime('%Y-%m-%d') # Convert the date object to a string
            }
            donors.append(donor)
        # Close the database connection and return the list of donors
        cursor.close()
        connect.close()
        return jsonify(donors)

    except Exception as e:
        # Handle any errors that occur during the database operation
        print(e)
        return jsonify({'error': str(e)})
    
@app.route('/donors/delete/<donor_id>', methods=['DELETE'])
def delete_donor(donor_id):
    try:
        # Connect to the database
        connection = mysql.connect
        cursor = connection.cursor()

        # Delete the specified donor from the database
        query = "DELETE FROM Donor WHERE ID = %s"
        cursor.execute(query, (donor_id,))
        connection.commit()

        # Close the database connection and return a success message
        cursor.close()
        connection.close()
        return jsonify({'message': 'Donor deleted successfully'})

    except Exception as e:
        # Handle any errors that occur during the database operation
        return jsonify({'error': str(e)})

@app.route('/donors/near-expiry/<number_of_days>', methods=['GET'])
def retrieve_donors_with_near_expiry(number_of_days):
    try:
        # Connect to the database
        connection = mysql.connect
        cursor = connection.cursor()

        # Retrieve the list of donors whose blood is about to expire in the next 30 days
        query = f"SELECT Donor.*, BloodBag.expiry_date FROM Donor INNER JOIN BloodBag ON Donor.ID = BloodBag.donor_id WHERE BloodBag.expiry_date BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL {number_of_days} DAY)"
        cursor.execute(query)
        results = cursor.fetchall()

        # Convert the query results to a list of dictionaries
        donors = []
        for row in results:
            donor = {
                'id': row.get('id'),
                'name': row.get('name'),
                'phone': row.get('phone'),
                'email': row.get('email'),
                'expiry_date': row.get('expiry_date').strftime('%Y-%m-%d')
            }
            donors.append(donor)

        # Close the database connection and return the list of donors as a JSON object
        cursor.close()
        connection.close()
        return jsonify(donors)

    except Exception as e:
        # Handle any errors that occur during the database operation
        return jsonify({'error': str(e)})
