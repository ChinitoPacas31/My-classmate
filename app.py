from flask import Flask, render_template, request, redirect, url_for, session
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector, hashlib

app = Flask(__name__)
app.secret_key = 'your_secret_key'

#aqui empieza el desmadre de las fotos
import os
from werkzeug.utils import secure_filename

# Configuración para subir imágenes
UPLOAD_FOLDER = 'static/uploads'  # Asegúrate de que esta carpeta ya exista
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Función para verificar extensiones permitidas
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def get_db_connection():
    return mysql.connector.connect(user="root", password="", host="localhost", port="3308", database="myclassmate")


@app.route('/')
def index():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Recupera los 4 mejores tutores por calificación
    cursor.execute("""
        SELECT user.name, user.lastName, user.profile_picture, tutor.asesoryCost, tutor.meanRating, 
               tutor.online, user.term
        FROM user
        INNER JOIN tutor ON user.idUser = tutor.user_idUser
        ORDER BY tutor.meanRating DESC
        LIMIT 4
    """)
    top_tutors = cursor.fetchall()
    
    cursor.close()
    conn.close()

    return render_template('index.html', top_tutors=top_tutors)

from datetime import datetime

@app.route('/agendar', methods=['GET', 'POST'])
def agendar():
    # Verificar si el usuario está autenticado
    if 'user_id' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        # Obtener y validar los datos del formulario
        tutor_id = request.form.get('tutor_user_idUser')
        student_id = session['user_id']
        fecha = request.form['scheduledDate']
        slot_time_id = request.form.get('slootTime_idSlootTime')

        # Verificar que tutor_id no esté vacío y convertirlo a entero
        if not tutor_id:
            return "Por favor selecciona un tutor", 400
        
        try:
            tutor_id = int(tutor_id)
        except ValueError:
            return "ID del tutor no válido", 400

        # Verificar que slot_time_id no esté vacío y convertirlo a entero
        if not slot_time_id:
            return "Por favor selecciona un horario", 400
        
        try:
            slot_time_id = int(slot_time_id)
        except ValueError:
            return "ID del horario no válido", 400

        # Guardar el registro en la tabla schedule
        conn = get_db_connection()
        cursor = conn.cursor()
        try:
            cursor.execute(
                """
                INSERT INTO schedule (tutor_user_idUser, student_user_idUser, scheduledDate, slootTime_idSlootTime)
                VALUES (%s, %s, %s, %s)
                """,
                (tutor_id, student_id, fecha, slot_time_id)
            )
            conn.commit()
        finally:
            cursor.close()
            conn.close()

        return redirect(url_for('tutors'))

    # Obtener todos los horarios disponibles para el dropdown
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT idSlotTime, startTime, endTime FROM slottime")
    slot_times = cursor.fetchall()

    # Obtener todos los tutores (id y nombre) para el dropdown
    cursor.execute("SELECT idUser, name FROM user INNER JOIN tutor ON user.idUser = tutor.user_idUser")
    tutors = cursor.fetchall()
    print(tutors)  # Verificar los datos de los tutores en la consola para depuración

    cursor.close()
    conn.close()

    return render_template('agendar.html', slot_times=slot_times, tutors=tutors)


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        profile_picture = request.files['profile_picture']
        name = request.form['name']
        lastName = request.form['lastName']
        college_idCollege = request.form['college_idCollege']
        idDegree_subdegree = request.form['idDegree_subdegree']
        term = request.form['term']
        email = request.form['email']
        password = request.form['password']
        is_tutor = request.form['is_tutor']
        cost = request.form['cost'] if is_tutor == 'yes' else None

        # Manejar la foto de perfil
        profile_picture_path = None
        if profile_picture and allowed_file(profile_picture.filename):
            filename = secure_filename(profile_picture.filename)
            profile_picture_path = os.path.join(app.config['UPLOAD_FOLDER'], filename).replace("\\", "/")
            profile_picture.save(profile_picture_path)  # Guarda la imagen

        # Verificar el dominio del correo electrónico
        if not email.endswith('@utch.edu.mx'):
            return 'El correo debe tener la terminación @utch.edu.mx'

        # Conectar a la base de datos e insertar el usuario
        conn = get_db_connection()
        cur = conn.cursor()

        # Inserción en la tabla user
        cur.execute(
            'INSERT INTO user (name, lastName, college_idCollege, idDegree_subdegree, term, email, password, profile_picture) '
            'VALUES (%s, %s, %s, %s, %s, %s, %s, %s)',
            (name, lastName, college_idCollege, idDegree_subdegree, term, email, password, profile_picture_path)
        )
        user_id = cur.lastrowid  # Recupera el id del usuario recién insertado

        # Inserción automática en la tabla student
        cur.execute('INSERT INTO student (user_idUser, online, createdAt, active) VALUES (%s, %s, %s, %s)', (user_id, 0, datetime.now(), 1))

        # Si el usuario selecciona ser tutor, inserta en la tabla tutor
        if is_tutor == 'yes' and cost:
            cur.execute('INSERT INTO tutor (user_idUser, asesoryCost, meanRating, online, createdAt, active) VALUES (%s, %s, %s, %s, %s, %s)', (user_id, cost, 0, 0, datetime.now(), 1))

        conn.commit()
        cur.close()
        conn.close()

        return redirect(url_for('index'))
    
    # Obtener universidades y especialidades para los dropdowns
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    cur.execute("SELECT idCollege, name FROM college")
    colleges = cur.fetchall()  # Lista de universidades con id y nombre

    cur.execute("SELECT idSubdegree, name FROM subdegree")
    subdegrees = cur.fetchall()  # Lista de especialidades con id y nombre

    cur.close()
    conn.close()

    return render_template('register.html', colleges=colleges, subdegrees=subdegrees)

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

        if user:  # Compara directamente la contraseña almacenada
            # Recuperar el valor almacenado en password y separar salt y hash
            salted_password = user['password']
            salt, stored_hash = salted_password.split(':')

            # Generar el hash de la contraseña ingresada con el salt
            attempt_hash = hashlib.sha256((salt + password).encode('utf-8')).hexdigest().upper()

        # Verificar si el hash generado coincide con el almacenado
        if attempt_hash == stored_hash:
            session['user_id'] = user['idUser']
            session['user_name'] = user['name']
            session['user_email'] = user['email']
            session['user_rating'] = user.get('meanRating', '0')
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
    # Verifica si el usuario está autenticado
    if 'user_id' not in session:
        return redirect(url_for('login'))
    
    user_id = session['user_id']
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    # Obtén la información del usuario y las relaciones necesarias
    cur.execute("""
        SELECT 
            user.name, 
            user.lastName, 
            user.email, 
            user.term, 
            user.profile_picture, 
            degree.name AS degree_name, 
            subdegree.name AS subdegree_name,
            college.name AS college_name,
            tutor.asesoryCost,
            tutor.meanRating
        FROM user
        LEFT JOIN degree_subdegree ON user.idDegree_Subdegree = degree_subdegree.idDegree_Subdegree
        LEFT JOIN degree ON degree_subdegree.degree_idDegree = degree.idDegree
        LEFT JOIN subdegree ON degree_subdegree.subdegree_idSubdegree = subdegree.idSubdegree
        LEFT JOIN college ON user.college_idCollege = college.idCollege
        LEFT JOIN tutor ON user.idUser = tutor.user_idUser
        WHERE user.idUser = %s
    """, (user_id,))
    user = cur.fetchone()
    
    #REVIEWS
    # Verificar si el usuario es tutor 
    cur.execute("SELECT * FROM tutor WHERE user_idUser = %s", (user_id,))
    tutor = cur.fetchone()

    # Si el usuario es tutor, obtener las reseñas
    reviews = []
    if tutor:
        cur.execute("""
            SELECT review.rating, review.description, user.name AS student_name, user.lastName AS student_lastname, user.profile_picture AS student_profile_picture
            FROM review
            JOIN user ON review.student_user_idUser = user.idUser
            WHERE tutor_user_idUser = %s
        """, (user_id,))
    reviews = cur.fetchall()

    cur.close()
    conn.close()

    # Pasa los datos del usuario a la plantilla
    return render_template('perfil.html', user=user, tutor=tutor, reviews=reviews)

@app.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    if request.method == 'POST':
        # Aquí manejas la lógica de actualización de perfil (por ejemplo, actualizar nombre, email, etc.)
        pass

    # Renderiza el formulario de edición de perfil
    return render_template('edit_profile.html')



@app.route('/tutors')
def tutors():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Recupera datos de todos los tutores
    cursor.execute("""
        SELECT user.name, user.lastName, user.profile_picture, tutor.asesoryCost, tutor.meanRating, 
               tutor.online, user.term
        FROM user
        INNER JOIN tutor ON user.idUser = tutor.user_idUser
    """)
    tutors = cursor.fetchall()
    
    cursor.close()
    conn.close()

    return render_template('tutors.html', tutors=tutors)

@app.route('/calificar', methods=['GET', 'POST'])
def calificar():
    # Verificar si el usuario está autenticado
    if 'user_id' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        tutor_id = request.form.get('tutor_user_idUser')
        student_id = session['user_id']
        rating = request.form.get('rating')
        description = request.form.get('description', '')

        # Validar inputs
        if not tutor_id or not rating:
            return "Por favor selecciona un tutor y una calificación", 400

        # Insertar nueva reseña en la tabla review
        cursor.execute("""
            INSERT INTO review (tutor_user_idUser, student_user_idUser, rating, description)
            VALUES (%s, %s, %s, %s)
        """, (tutor_id, student_id, rating, description))
        conn.commit()

        # Actualizar la calificación promedio del tutor
        cursor.execute("""
            UPDATE tutor
            SET meanRating = (
                SELECT AVG(rating)
                FROM review
                WHERE tutor_user_idUser = %s
            )
            WHERE user_idUser = %s
        """, (tutor_id, tutor_id))
        conn.commit()

        cursor.close()
        conn.close()
        return redirect(url_for('tutors'))

    # Obtener la lista de tutores
    cursor.execute("SELECT idUser, name, lastName FROM user INNER JOIN tutor ON user.idUser = tutor.user_idUser")
    tutors = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('calificar.html', tutors=tutors)

@app.route('/delete_account', methods=['POST'])
def delete_account():
    # Verifica si el usuario está autenticado
    if 'user_id' not in session:
        return redirect(url_for('login'))

    user_id = session['user_id']
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        # Elimina primero cualquier dato relacionado con el usuario (dependiendo de tu base de datos, puedes tener relaciones que también debas borrar)
        cursor.execute('DELETE FROM review WHERE tutor_user_idUser = %s OR student_user_idUser = %s', (user_id, user_id))
        cursor.execute('DELETE FROM tutor WHERE user_idUser = %s', (user_id,))
        cursor.execute('DELETE FROM student WHERE user_idUser = %s', (user_id,))
        cursor.execute('DELETE FROM user WHERE idUser = %s', (user_id,))

        conn.commit()

        # Cierra la sesión del usuario
        session.pop('user_id', None)
        session.pop('user_name', None)
        session.pop('user_email', None)
        session.pop('user_rating', None)

    except Exception as e:
        conn.rollback()
        print(f"Error al eliminar la cuenta: {e}")

    finally:
        cursor.close()
        conn.close()

    return redirect(url_for('index'))  # Redirige al inicio después de eliminar la cuenta


if __name__ == '__main__':
    app.run(port=3000, debug=True)