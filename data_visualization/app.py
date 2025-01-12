from flask import Flask, render_template, request, jsonify,send_file,  redirect, url_for,request,Blueprint
import mysql.connector  
from datetime import datetime, timedelta
import pandas as pd
from io import BytesIO
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib import colors
from db_connection import get_connection



app = Flask(__name__)

data_visualization_bp = Blueprint('data_visualization', __name__, template_folder='templates', static_folder='static')


# # MySQL Database Configuration
# DB_CONFIG = {
#     'host': 'localhost',
#     'user': 'root',
#     'password': 'root',
#     'database': 'ProjectUFFT'
# }

# Use to store expanse data which is fetched from the filters 
Expense_data=[]

# Utility function to fetch database connection
def get_db_connection():
    #return mysql.connector.connect(**DB_CONFIG)
    return get_connection()

@data_visualization_bp.route('/fetch_family_members', methods=['GET'])
def fetch_family_members():
    family_id = request.args.get('family_id', type=int)
    family_members = []
    if family_id:
        with get_db_connection() as connection:
            with connection.cursor(dictionary=True) as cursor:
                cursor.execute("SELECT user_id, name FROM users WHERE family_id = %s", (family_id,))
                family_members = cursor.fetchall()
    return jsonify({"family_members": family_members})

def fetch_families():
    families = []
    with get_db_connection() as connection:
        with connection.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT family_id, family_name FROM families")
            families = cursor.fetchall()
    return families


@data_visualization_bp.route('/', methods=['GET', 'POST'])
def index():
    families = fetch_families()
    family_members = []
    expense_data = []
    category_totals = {}
    grouped_expenses = {}  # For grouping expenses by user
    selected_user_id = None
    search_query = ''
    time_range = ''
    start_date = ''
    end_date = ''
    family_id = None
    no_records = False  # Flag for no records
    success_message = False  # Default value for success message flag

    if request.method == 'POST':
        family_id = request.form.get('family_id')
        selected_user_id = request.form.get('user_id')
        search_query = request.form.get('search_query', '').strip()
        time_range = request.form.get('time_range')
        start_date = request.form.get('start_date')
        end_date = request.form.get('end_date')

        if family_id:
            with get_db_connection() as connection:
                with connection.cursor(dictionary=True) as cursor:
                    cursor.execute("SELECT user_id, name FROM users WHERE family_id = %s", (family_id,))
                    family_members = cursor.fetchall()

                    Expense_data.clear()

            user_ids = [member['user_id'] for member in family_members]

            if selected_user_id == "all":
                selected_user_id = user_ids
            else:
                selected_user_id = [selected_user_id]

            query = """
                SELECT e.expense_id, e.user_id, u.name AS user_name, e.description, e.amount, c.name AS category_name, e.date
                FROM expenses e
                JOIN users u ON e.user_id = u.user_id
                JOIN categories c ON e.category_id = c.category_id
                WHERE e.family_id = %s AND e.user_id IN (%s)
            """
            query = query % ("%s", ",".join(['%s'] * len(selected_user_id)))
            params = [family_id] + selected_user_id

            if search_query:
                query += " AND e.description LIKE %s"
                params.append(f"%{search_query}%")

            if time_range == 'custom' and start_date and end_date:
                query += " AND e.date BETWEEN %s AND %s"
                params.extend([start_date, end_date])
            elif time_range == 'week':
                query += " AND e.date >= DATE_SUB(NOW(), INTERVAL 1 WEEK)"
            elif time_range == 'month':
                query += " AND e.date >= DATE_SUB(NOW(), INTERVAL 1 MONTH)"
            elif time_range == 'year':
                query += " AND e.date >= DATE_SUB(NOW(), INTERVAL 1 YEAR)"

            query += " ORDER BY e.date"

            with get_db_connection() as connection:
                with connection.cursor(dictionary=True) as cursor:
                    cursor.execute(query, params)
                    expense_data = cursor.fetchall()
                    Expense_data.append(expense_data)
                    # print(Expense_data[0])

            # Group expenses by user_id for multiple pie charts
            grouped_expenses = {}
            for expense in expense_data:
                user_id = expense['user_id']
                user_name = expense['user_name']
                if user_id not in grouped_expenses:
                    grouped_expenses[user_id] = {'user_name': user_name, 'categories': {}}
                category = expense['category_name']
                amount = expense['amount']
                grouped_expenses[user_id]['categories'][category] = grouped_expenses[user_id]['categories'].get(category, 0) + amount

            # Check if no records were found
            no_records = len(expense_data) == 0
            
    if request.args.get('success_message') == 'success':
        success_message = True
            
        
    return render_template(
        'dv_index.html',
        families=families,
        family_members=family_members,
        expenses=expense_data,
        grouped_expenses=grouped_expenses,  # Send grouped data
        category_totals=category_totals,
        selected_user_id=selected_user_id,
        family_id=family_id,
        search_query=search_query,
        time_range=time_range,
        start_date=start_date,
        end_date=end_date,
        success_message=success_message,
        no_records=no_records  # Pass the flag to the template
    )



@data_visualization_bp.route('/download/csv')
def download_csv():
    # Prepare CSV data
    if not Expense_data:
        return "No matching expenses found.", 404
    
    
    expenses=Expense_data[0]
    data = {
    'Sr no': [idx + 1 for idx, _ in enumerate(expenses)], 
    'Category': [exp['category_name'] for exp in expenses],
    'Amount': [exp['amount'] for exp in expenses],
    'Date': [exp['date'].strftime("%d-%m-%Y") for exp in expenses],
    'Description': [exp['description'] or "N/A" for exp in expenses],
    'User Name': [exp['user_name'] for exp in expenses]
    }
    # Create CSV
    df = pd.DataFrame(data)
    output = BytesIO()
    df.to_csv(output, index=False, encoding='utf-8')
    output.seek(0)

    # Return CSV file
    return send_file(output, as_attachment=True, download_name='expenses.csv', mimetype='text/csv')

# Route to download Excel
@data_visualization_bp.route('/download/excel')
def download_excel():
    if not Expense_data:
        render_template('base.html') 
        return "<h1>404 Data Not Found<h1>", 404
    
    expenses=Expense_data[0]
    data = {
        'Sr no': [idx + 1 for idx, _ in enumerate(expenses)],
        'Category': [exp['category_name'] for exp in expenses],
        'Amount': [exp['amount'] for exp in expenses],
        'Date': [exp['date'].strftime("%d-%m-%Y") for exp in expenses],
        'Description': [exp['description'] or "N/A" for exp in expenses],
        'User Name' : [exp['user_name'] for exp in expenses]
    }
    df = pd.DataFrame(data)
    output = BytesIO()
    with pd.ExcelWriter(output, engine='xlsxwriter') as writer:
        df.to_excel(writer, index=False, sheet_name='Expenses')
    output.seek(0)
    return send_file(output, as_attachment=True, download_name='expenses.xlsx', mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')


# Route to download PDF
@data_visualization_bp.route('/download/pdf')
def download_pdf():
    if not Expense_data:
        render_template('base.html') 
        return "<h1>404 Data Not Found<h1>", 404
    
    expenses=Expense_data[0]
    data = [['Sr no', 'Category', 'Amount', 'Date', 'Description', 'User Name']]
    data += [
    [idx + 1, exp['category_name'], f"{exp['amount']:.2f}", exp['date'].strftime("%d-%m-%y"), exp['description'] or "N/A", exp['user_name']]
    for idx, exp in enumerate(expenses)
    ]

    pdf_output = BytesIO()
    doc = SimpleDocTemplate(pdf_output, pagesize=letter)
    table = Table(data)
    table.setStyle(TableStyle([('BACKGROUND', (0, 0), (-1, 0), colors.grey), ('GRID', (0, 0), (-1, -1), 1, colors.black)]))
    doc.build([Paragraph("Expense Report", getSampleStyleSheet()['Heading1']), Spacer(1, 12), table])
    pdf_output.seek(0)

    return send_file(pdf_output, as_attachment=True, download_name="expenses.pdf", mimetype="application/pdf")

@data_visualization_bp.route('/save_report', methods=['GET','POST'])
def save_report():
    if not Expense_data:
        return redirect(url_for('index'))  # Redirect if no expenses found
    
    expenses = Expense_data[0]
    user_id = request.args.get('user_id')# Get the user_id from the URL or session, if needed
    report_data = generate_report_data(expenses)
    
    # Insert the report into the database
    try:
        with get_db_connection() as connection:
            with connection.cursor() as cursor:
                cursor.execute("""
                    INSERT INTO Reports (user_id, content, generated_at)
                    VALUES (%s, %s, %s)
                """, (user_id, report_data, datetime.now()))
                connection.commit()
    except Exception as e:
        print(f"Error saving report: {e}")
        return "Failed to save report.", 500
    
    return redirect(url_for('data_visualization.index', success_message="success"))  # Redirect back to the home page

    

def generate_report_data(expenses):
    # Generate the report content based on the expenses
    report_content = "Expense Report\n"
    report_content += "ID, Category, Amount, Date, Description, User Name\n"
    for exp in expenses:
        report_content += f"{exp['expense_id']}, {exp['category_name']}, {exp['amount']}, {exp['date']}, {exp['description']}, {exp['user_name']}\n"
    
    return report_content


@data_visualization_bp.route('/history')
def show_history():
    reports = []
    with get_db_connection() as connection:
        with connection.cursor(dictionary=True) as cursor:
            cursor.execute("SELECT report_id, user_id, content, generated_at FROM Reports ORDER BY generated_at DESC")
            reports = cursor.fetchall()

    return render_template('history.html', reports=reports)

@data_visualization_bp.route('/delete_report', methods=['POST'])
def delete_report():
    report_id = request.form.get('report_id')

    # Connect to the database and delete the report
    connection = get_db_connection()
    cursor = connection.cursor()
    
    # Deleting the report from the database
    delete_query = "DELETE FROM reports WHERE report_id = %s"
    cursor.execute(delete_query, (report_id,))
    connection.commit()
    
    cursor.close()
    connection.close()

    # Redirect back to the report history page
    return redirect(url_for('data_visualization.show_history'))

@data_visualization_bp.route('/show_report/<int:report_id>')
def show_report(report_id):
    connection = get_db_connection()
    cursor = connection.cursor(dictionary=True)
    
    # Fetch the report content and other details from the database
    cursor.execute("SELECT report_id, user_id, content, generated_at FROM reports WHERE report_id = %s", (report_id,))
    report = cursor.fetchone()
    cursor.close()
    connection.close()
    
    if report:
        # Parse the content into a list of dictionaries (table rows)
        content_lines = report['content'].strip().split('\n')
        
        # Extract headers from the first line and parse the rest as data
        content_headers = ["Expense Report ID", "Category", "Amount", "Date", "Description", "User Name"]
        content_data = [
            dict(zip(content_headers, line.split(', ')))
            for line in content_lines[2:]  # Skip the first line (headers)
        ]

        return render_template('show_report.html', report=report, content_data=content_data)
    else:
        return "<h1>Report not found</h1>", 404




@data_visualization_bp.errorhandler(404)
def page_not_found(e):
    return render_template(
        'index.html',
        error_message="Invalid action! The page you are trying to access does not exist.",
        families=[],
        family_members=[],
        expenses=[],
        category_totals={}
    ), 404


from collections import defaultdict
# # Function to generate summary
# def generate_summary(expense_data):
#     total_expense = sum(exp['amount'] for exp in expense_data)
    
#     summary = f"<br>Total expense: ₹{total_expense}<br>"
    
#     users = {}

#     # Grouping expenses by users
#     for exp in expense_data:
#         user_name = exp['user_name']
#         if user_name not in users:
#             users[user_name] = []
#         users[user_name].append(exp)

#     # Looping through users and calculating their expenses
#     for user_name, expenses in users.items():
#         summary += f"{user_name} :-     "
#         user_total_expense = sum(exp['amount'] for exp in expenses)
#         summary += f"Total Expense: ₹{user_total_expense}<br>"
        
#         # Group expenses by category
#         categories = {}
#         for exp in expenses:
#             category = exp['category_name']
#             if category not in categories:
#                 categories[category] = []
#             categories[category].append(exp)
         
#         # Finding highest and lowest expenses
#         highest_expense = max(expenses, key=lambda x: x['amount'])
#         lowest_expense = min(expenses, key=lambda x: x['amount'])
        
#         summary += f"  Highest Expense: {highest_expense['category_name']} - ₹{highest_expense['amount']} on {highest_expense['date']}<br>"
#         summary += f"  Lowest Expense: {lowest_expense['category_name']} - ₹{lowest_expense['amount']} on {lowest_expense['date']}<br>"
    
#     return summary

# # Flask route to generate summary
# @data_visualization_bp.route('/generate_summary', methods=['POST'])
# def generate_summary_endpoint():
#     # Get the JSON data from the request
#     expense_data = Expense_data[0]

#     if not expense_data:
#         return jsonify({"error": "No expense data provided."}), 400

#     # Generate the summary for the expense data
#     summary = generate_summary(expense_data)

#     return jsonify({"summary": summary})


if __name__ == '__main__':
    app.run(debug=True)
