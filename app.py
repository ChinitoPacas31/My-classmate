from flask import Flask, render_template, request, redirect, url_for, session
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector

app = Flask(__name__)
app.secret_key = 'your_secret_key'

def get_db_connection():
    return mysql.connector.connect(user="root", password="", host="localhost", port="3308", database="myclassmate")

@app.route('/')
def index():
    return render_template('index.html')

from datetime import datetime

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        lastName = request.form['lastName']
        college_idCollege = request.form['college_idCollege']
        idDegree_subdegree = request.form['idDegree_subdegree']
        term = request.form['term']
        email = request.form['email']
        password = request.form['password']
        is_tutor = request.form['is_tutor']
        cost = request.form['cost'] if is_tutor == 'yes' else None

        if not email.endswith('@utch.edu.mx'):
            return 'El correo debe tener la terminación @utch.edu.mx'

        conn = get_db_connection()
        cur = conn.cursor()

        # Inserción en la tabla `user`
        cur.execute('INSERT INTO user (name, lastName, college_idCollege, idDegree_subdegree, term, email, password) VALUES (%s, %s, %s, %s, %s, %s, %s)',(name, lastName, college_idCollege, idDegree_subdegree, term, email, password))
        user_id = cur.lastrowid  # Recupera el id del usuario recién insertado

        # Inserción automática en la tabla `student`
        cur.execute('INSERT INTO student (user_idUser, online, createdAt, active) VALUES (%s, %s, %s, %s)', (user_id, 0, datetime.now(), 1))

        # Si el usuario selecciona ser tutor, inserta en la tabla `tutor`
        if is_tutor == 'yes' and cost:
            cur.execute('INSERT INTO tutor (user_idUser, asesoryCost, meanRating, online, createdAt, active) VALUES (%s, %s, %s, %s, %s, %s)', (user_id, cost, 0, 0, datetime.now(), 1))

        conn.commit()
        cur.close()
        conn.close()

        return redirect(url_for('index'))
    
    return render_template('register.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        conn = get_db_connection()
        cur = conn.cursor(dictionary=True)
        
        cur.execute('SELECT * FROM user WHERE email = %s', (email,))
        user = cur.fetchone()

        conn.close()

        if user and user['password'] == password:  # Compara directamente la contraseña almacenada
            session['user_id'] = user['idUser']
            session['user_name'] = user['name']
            return redirect(url_for('index'))
        else:
            return 'Invalid email or password'

    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('user_name', None)
    return redirect(url_for('index'))

@app.route('/perfil')
def perfil():
    # Aquí puedes agregar la lógica para el perfil del usuario
    return render_template('perfil.html')

if __name__ == '__main__':
    app.run(port=3000, debug=True)
    