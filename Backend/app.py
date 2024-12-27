from flask import Flask, jsonify, request
import mysql.connector
from dotenv import load_dotenv
import os
import datetime

# Load environment variables
load_dotenv()

# Initialize Flask app
app = Flask(__name__)

# Database configuration
app.config['MYSQL_HOST'] = os.getenv('MYSQL_HOST', 'localhost')
app.config['MYSQL_USER'] = os.getenv('MYSQL_USER', 'root')
app.config['MYSQL_PASSWORD'] = os.getenv('MYSQL_PASSWORD', 'CPSC408!')
app.config['MYSQL_DB'] = os.getenv('MYSQL_DB', 'ExpenseBudgetingSystem')

# Function to get a database connection
def get_db_connection():
    return mysql.connector.connect(
        host=app.config['MYSQL_HOST'],
        user=app.config['MYSQL_USER'],
        password=app.config['MYSQL_PASSWORD'],
        database=app.config['MYSQL_DB']
    )

# CRUD Operations for User Table
## 1. Read (GET)
@app.route('/users', methods=['GET'])
def get_users():
    """Fetch all active users."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM User WHERE Status = 'Active'")
        users = cursor.fetchall()
        db.close()
        result = [
            {"userID": row[0], "name": row[1], "age": row[2], "email": row[3], "status": row[4]}
            for row in users
        ]
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 2. Create (POST)
@app.route('/users', methods=['POST'])
def add_user():
    """Add a new user."""
    try:
        data = request.json
        # Validate input
        if not data.get('name') or not data.get('email') or not data.get('password'):
            return jsonify({"error": "Missing required fields: name, email, password"}), 400

        db = get_db_connection()
        cursor = db.cursor()
        query = "INSERT INTO User (Name, Age, Email, Password, Status) VALUES (%s, %s, %s, %s, %s)"
        values = (data['name'], data['age'], data['email'], data['password'], 'Active')
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": "User added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 3. Update (PUT)
@app.route('/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    """Update an existing user's details."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()
        query = "UPDATE User SET Name = %s, Age = %s, Email = %s WHERE UserID = %s"
        values = (data['name'], data['age'], data['email'], user_id)
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": f"User {user_id} updated successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 4. Delete (DELETE)
@app.route('/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    """Soft delete a user by setting their status to Inactive."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        query = "UPDATE User SET Status = 'Inactive' WHERE UserID = %s"
        cursor.execute(query, (user_id,))
        db.commit()
        db.close()
        return jsonify({"message": f"User {user_id} marked as inactive"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
## --- CRUD Operations for Budget Table ---

## 1. Read (GET) Budgets for a User
@app.route('/budgets/<int:user_id>', methods=['GET'])
def get_user_budgets(user_id):
    """Fetch all budgets for a specific user."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM Budget WHERE UserID = %s", (user_id,))
        budgets = cursor.fetchall()
        db.close()
        result = [
            {
                "budgetID": row[0],
                "userID": row[1],
                "startDate": str(row[2]),
                "endDate": str(row[3]),
                "monthlyLimit": float(row[4]),
                "status": row[5]
            }
            for row in budgets
        ]
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 2. Create (POST) a New Budget
@app.route('/budgets', methods=['POST'])
def add_budget():
    """Add a new budget."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()
        query = """
            INSERT INTO Budget (UserID, StartDate, EndDate, MonthlyLimit, Status)
            VALUES (%s, %s, %s, %s, %s)
        """
        values = (
            data['userID'], 
            data['startDate'], 
            data['endDate'], 
            data['monthlyLimit'], 
            'Active'
        )
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": "Budget added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 3. Update (PUT) an Existing Budget
@app.route('/budgets/<int:budget_id>', methods=['PUT'])
def update_budget(budget_id):
    """Update an existing budget."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()
        query = """
            UPDATE Budget 
            SET StartDate = %s, EndDate = %s, MonthlyLimit = %s, Status = %s
            WHERE BudgetID = %s
        """
        values = (
            data['startDate'], 
            data['endDate'], 
            data['monthlyLimit'], 
            data['status'], 
            budget_id
        )
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": f"Budget {budget_id} updated successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 4. Delete (DELETE) a Budget
@app.route('/budgets/<int:budget_id>', methods=['DELETE'])
def delete_budget(budget_id):
    """Delete a budget."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        query = "DELETE FROM Budget WHERE BudgetID = %s"
        cursor.execute(query, (budget_id,))
        db.commit()
        db.close()
        return jsonify({"message": f"Budget {budget_id} deleted successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
## --- CRUD Operations for Transaction Table ---

## 1. Read (GET) Transactions for a User
@app.route('/transactions/<int:user_id>', methods=['GET'])
def get_user_transactions(user_id):
    """Fetch all transactions for a specific user."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        query = """
            SELECT Transaction.*, Budget.MonthlyLimit
            FROM Transaction
            LEFT JOIN Budget ON Transaction.BudgetID = Budget.BudgetID
            WHERE Transaction.UserID = %s
        """
        cursor.execute(query, (user_id,))
        transactions = cursor.fetchall()
        db.close()
        result = [
            {
                "transactionID": row[0],
                "userID": row[1],
                "budgetID": row[2],  # Include BudgetID
                "amount": float(row[3]),
                "transactionDate": str(row[4]),
                "categoryID": row[5],
                "description": row[6],
                "type": row[7],
                "monthlyLimit": float(row[8]) if row[8] else None,  # Include Budget details
            }
            for row in transactions
        ]
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
## 2. Create (POST) a New Transaction
@app.route('/transactions', methods=['POST'])
def add_transaction():
    """Add a new transaction and check budget limits."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()

        # Add the transaction
        query = """
            INSERT INTO Transaction (UserID, BudgetID, Amount, TransactionDate, CategoryID, Description, Type)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        values = (
            data['userID'],
            data['budgetID'],  # Include BudgetID
            data['amount'],
            data['transactionDate'],
            data['categoryID'],
            data['description'],
            data['type'],
        )
        cursor.execute(query, values)

        # Check if the budget limit is exceeded
        budget_query = """
            SELECT SUM(t.Amount), b.MonthlyLimit
            FROM Transaction t
            INNER JOIN Budget b ON t.BudgetID = b.BudgetID
            WHERE t.BudgetID = %s
        """
        cursor.execute(budget_query, (data['budgetID'],))
        result = cursor.fetchone()

        if result:
            total_spent, monthly_limit = result
            if total_spent > monthly_limit:
                # Create an alert
                alert_query = """
                    INSERT INTO Alert (UserID, BudgetID, Message, AlertDate, Status)
                    VALUES (%s, %s, %s, %s, %s)
                """
                alert_message = f"Budget limit exceeded! You have spent ${total_spent:.2f} out of ${monthly_limit:.2f}."
                alert_values = (
                    data['userID'],
                    data['budgetID'],
                    alert_message,
                    datetime.date.today().strftime('%Y-%m-%d'),
                    'Unread'
                )
                cursor.execute(alert_query, alert_values)

        db.commit()
        db.close()
        return jsonify({"message": "Transaction added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
## 3. Update (PUT) an Existing Transaction
@app.route('/transactions/<int:transaction_id>', methods=['PUT'])
def update_transaction(transaction_id):
    """Update an existing transaction."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()
        query = """
            UPDATE Transaction 
            SET BudgetID = %s, Amount = %s, TransactionDate = %s, CategoryID = %s, Description = %s, Type = %s
            WHERE TransactionID = %s
        """
        values = (
            data['budgetID'],  # Include BudgetID
            data['amount'],
            data['transactionDate'],
            data['categoryID'],
            data['description'],
            data['type'],
            transaction_id,
        )
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": f"Transaction {transaction_id} updated successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
## 4. Delete (DELETE) a Transaction
@app.route('/transactions/<int:transaction_id>', methods=['DELETE'])
def delete_transaction(transaction_id):
    """Delete a transaction."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        query = "DELETE FROM Transaction WHERE TransactionID = %s"
        cursor.execute(query, (transaction_id,))
        db.commit()
        db.close()
        return jsonify({"message": f"Transaction {transaction_id} deleted successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
## --- CRUD Operations for Category Table ---

## 1. Read (GET) All Categories
@app.route('/categories', methods=['GET'])
def get_categories():
    """Fetch all categories."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM Category")
        categories = cursor.fetchall()
        db.close()
        result = [
            {"categoryID": row[0], "name": row[1], "description": row[2]}
            for row in categories
        ]
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 2. Create (POST) a New Category
@app.route('/categories', methods=['POST'])
def add_category():
    """Add a new category."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()
        query = "INSERT INTO Category (Name, Description) VALUES (%s, %s)"
        values = (data['name'], data['description'])
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": "Category added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 3. Update (PUT) an Existing Category
@app.route('/categories/<int:category_id>', methods=['PUT'])
def update_category(category_id):
    """Update an existing category."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()
        query = "UPDATE Category SET Name = %s, Description = %s WHERE CategoryID = %s"
        values = (data['name'], data['description'], category_id)
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": f"Category {category_id} updated successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 4. Delete (DELETE) a Category
@app.route('/categories/<int:category_id>', methods=['DELETE'])
def delete_category(category_id):
    """Delete a category."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        query = "DELETE FROM Category WHERE CategoryID = %s"
        cursor.execute(query, (category_id,))
        db.commit()
        db.close()
        return jsonify({"message": f"Category {category_id} deleted successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
## --- CRUD Operations for Alert Table ---

## 1. Read (GET) Alerts for a User
@app.route('/alerts/<int:user_id>', methods=['GET'])
def get_user_alerts(user_id):
    """Fetch all alerts for a specific user or budget."""
    budget_id = request.args.get('budgetID')  # Optional parameter
    try:
        db = get_db_connection()
        cursor = db.cursor()

        if budget_id:
            cursor.execute("SELECT * FROM Alert WHERE UserID = %s AND BudgetID = %s", (user_id, budget_id))
        else:
            cursor.execute("SELECT * FROM Alert WHERE UserID = %s", (user_id,))
        
        alerts = cursor.fetchall()
        db.close()
        result = [
            {
                "alertID": row[0],
                "userID": row[1],
                "budgetID": row[2],
                "message": row[3],
                "alertDate": str(row[4]),
                "status": row[5]
            }
            for row in alerts
        ]
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 2. Create (POST) a New Alert
@app.route('/alerts', methods=['POST'])
def add_alert():
    """Add a new alert."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()
        query = "INSERT INTO Alert (UserID, Message, AlertDate, Status) VALUES (%s, %s, %s, %s)"
        values = (data['userID'], data['message'], data['alertDate'], data['status'])
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": "Alert added successfully"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 3. Update (PUT) an Existing Alert
@app.route('/alerts/<int:alert_id>', methods=['PUT'])
def update_alert(alert_id):
    """Update an existing alert."""
    try:
        data = request.json
        db = get_db_connection()
        cursor = db.cursor()
        query = "UPDATE Alert SET Message = %s, AlertDate = %s, Status = %s WHERE AlertID = %s"
        values = (data['message'], data['alertDate'], data['status'], alert_id)
        cursor.execute(query, values)
        db.commit()
        db.close()
        return jsonify({"message": f"Alert {alert_id} updated successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

## 4. Delete (DELETE) an Alert
@app.route('/alerts/<int:alert_id>', methods=['DELETE'])
def delete_alert(alert_id):
    """Delete an alert."""
    try:
        db = get_db_connection()
        cursor = db.cursor()
        query = "DELETE FROM Alert WHERE AlertID = %s"
        cursor.execute(query, (alert_id,))
        db.commit()
        db.close()
        return jsonify({"message": f"Alert {alert_id} deleted successfully"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Main Runner
if __name__ == '__main__':
    app.run(debug=True)