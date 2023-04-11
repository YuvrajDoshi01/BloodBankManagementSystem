from flask import Flask, jsonify, request,render_template,redirect
from flask_mysqldb import MySQL

app = Flask(__name__)

# MySQL configurations
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '8875093192'
app.config['MYSQL_DB'] = 'blood_bank'
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
    return render_template('blood_units.html', data=result)

# 2) Update the inventory after a new donation
@app.route('/donation', methods=['GET','POST'])
def donation():
    if request.method == 'POST':

        donor_data = request.json
        name = donor_data['name']
        phone = donor_data['phone']
        email = donor_data['email']
        street = donor_data['street']
        city = donor_data['city']
        state = donor_data['state']
        zip_code = donor_data['zip_code']
        blood_type = donor_data['blood_type']
        volume = donor_data['volume']
        expiry_date = donor_data['expiry_date']
        donation_date = donor_data['donation_date']
        donor_id = donor_data.get('donor_id')
        
        # Check if the donor exists in the donor table
        cursor = mysql.connection.cursor()
        cursor.execute("SELECT * FROM donor WHERE ID=%s", (donor_id,))
        donor = cursor.fetchone()
        
        if donor is None:
            # Donor does not exist, create new donor
            cursor.execute("INSERT INTO donor (name, phone, email) VALUES (%s, %s, %s)", (name, phone, email))
            cursor.execute("INSERT INTO address (street, city, state, zip_code) VALUES (%s, %s, %s, %s)", (street, city, state, zip_code))
            donor_id = cursor.lastrowid
            # cursor.execute("INSERT INTO bloodbag (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id) VALUES (%s, %s, %s, %s, %s, %s)", (blood_type, volume, expiry_date, donation_date, donor_id, 1))
            # mysql.connection.commit()
        
        else:
            # Donor exists, update volume in bloodbag table
            cursor.execute("UPDATE bloodbag SET volume=volume+%s WHERE donor_id=%s", (volume, donor_id,))

        print(2)
        # Insert blood bag information into bloodbag table, using the donor_id
        cursor.execute("INSERT INTO bloodbag (blood_type, volume, expiry_date, donation_date, donor_id, blood_bank_id) VALUES (%s, %s, %s, %s, %s, %s)", (blood_type, volume, expiry_date, donation_date, donor_id, 1))
        mysql.connection.commit()
        
        cursor.close()
        return redirect('/blood_units')
    else :
        return render_template('form.html')

# 3) Retrieve the list of all donors with their donation history
# If donation history is none, blood_group along with the expiry_date and the donation_date and the volume is set to none
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
    return render_template('donor_details.html',donors = result)

# 4) Adding a new donor to the database
@app.route('/donor', methods=['POST','GET'])
def add_donor():
    if request.method == 'POST':    
        name = request.json['name']
        phone = request.json['phone']
        email = request.json['email']
        
        cur = mysql.connection.cursor()
        cur.execute('''INSERT INTO Donor (name, phone, email)
                    VALUES (%s, %s, %s)''',
                    (name, phone, email))
        donor_id = cur.lastrowid

        street = request.json['street']
        city = request.json['city']
        state = request.json['state']
        zip_code = request.json['zip_code']
        cur.execute("INSERT INTO ADDRESS (street, city, state, zip_code) VALUES (%s, %s, %s, %s)", (street, city, state, zip_code))
        address_id = cur.lastrowid

        mysql.connection.commit()
        cur.close()
        return redirect('/donors')
    else :
        return render_template('add_donor.html')

# 5) Update the information of the donor
@app.route('/donor/<int:donor_id>', methods=['GET','POST'])
def update_donor_information(donor_id):
    if request.method == 'POST':
        name = request.json['name']
        phone = request.json['phone']
        email = request.json['email']
        cur = mysql.connection.cursor()
        cur.execute('''UPDATE Donor SET name = %s, phone = %s, email = %s
                    WHERE ID = %s''',
                    (name, phone, email, donor_id))
        
        street = request.json['street']
        city = request.json['city']
        state = request.json['state']
        zip_code = request.json['zip_code']

        cur.execute('''UPDATE ADDRESS SET street = %s,city=%s,state=%s,zip_code= %s 
                    WHERE ID = %s ''', (street,city,state,zip_code,donor_id))
        mysql.connection.commit()
        cur.close()
        return redirect('/donors')
    else:
        return render_template('donor_edit.html',donor_id = donor_id)
    


@app.route('/donors/blood_group/<blood_group>',methods=['GET'])
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
                'id': row.get('ID'),
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
        return render_template('donor_retrieve.html',donors = donors,blood_group= blood_group)

    except Exception as e:
        # Handle any errors that occur during the database operation
        print(e)
        return jsonify({'error': str(e)})
    
@app.route('/donors/delete/<donor_id>', methods=['DELETE','GET'])
def delete_donor(donor_id):
    if request.method == 'DELETE':
        # Blood Transfusion and also Blood Test
        # Connect to the database
        connection = mysql.connect
        cursor = connection.cursor()

        # Delete the specified donor from the database
        query2 = f"SELECT ID FROM BloodBag where donor_id = {donor_id}"
        cursor.execute(query2)
        print(1)
        results = cursor.fetchall()
        print(results)
        for result in results:
            print(result)
            ID = str(result.get('ID'))
            query0 = f"DELETE FROM BloodTransfusion where blood_bag_id = {ID}"
            query = f"DELETE FROM BloodTest where blood_bag_id = {ID}"
            query = f"DELETE FROM BloodBag where donor_id = {donor_id}"
            print(3)
        query = f"DELETE FROM Donor WHERE ID = {donor_id}"
        cursor.execute(query)
        print(4)
        connection.commit()

        # Close the database connection and return a success message
        cursor.close()
        connection.close()
        return render_template('delete_donor.html')

    else:
        # Handle any errors that occur during the database operation
        
        return render_template('delete_donor.html',donor_id= donor_id)

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
                'id': row.get('ID'),
                'name': row.get('name'),
                'phone': row.get('phone'),
                'email': row.get('email'),
                'expiry_date': row.get('expiry_date').strftime('%Y-%m-%d')
            }
            donors.append(donor)

        # Close the database connection and return the list of donors as a JSON object
        cursor.close()
        connection.close()
        return render_template('near_expiry.html', donors= donors,number_of_days = number_of_days)

    except Exception as e:
        # Handle any errors that occur during the database operation
        return jsonify({'error': str(e)})

@app.route('/',methods = ['GET'])
def homepage():
    return render_template('home.html')