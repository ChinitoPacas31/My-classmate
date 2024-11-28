from flask import Flask, render_template, request, redirect, url_for, session
from werkzeug.security import generate_password_hash, check_password_hash
from flask_mail import Mail, Message
import mysql.connector, hashlib

app = Flask(__name__)
app.secret_key = 'your_secret_key'

#aqui empieza el desmadre de las fotos
import os
from werkzeug.utils import secure_filename
import time
from datetime import datetime

# Configuración para subir imágenes
UPLOAD_FOLDER = 'static/uploads'  # Asegúrate de que esta carpeta ya exista
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Función para verificar extensiones permitidas
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def get_db_connection():
    return mysql.connector.connect(user="root", password="", host="localhost", port="3306", database="myclassmate")

# Configuración de Flask-Mail (asegúrate de reemplazar con tus credenciales)
app.config['MAIL_SERVER'] = 'smtp.googlemail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'myclassmate8@gmail.com'  # Cambia esto
app.config['MAIL_PASSWORD'] = 'zlcq jjta ripg yruz'        # Cambia esto
mail = Mail(app)


@app.route('/')
def index():
    # Obtén el user_id de la sesión
    user_id = session.get('user_id')  # Este se usa solo si necesitas saber el usuario actual logueado

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Recupera los 4 mejores tutores por calificación
    cursor.execute("""
        SELECT user.idUser, user.name, user.lastName, user.profile_picture, tutor.asesoryCost, tutor.meanRating, 
               tutor.online, user.term
        FROM user
        INNER JOIN tutor ON user.idUser = tutor.user_idUser
        ORDER BY tutor.meanRating DESC
        LIMIT 4
    """)
    top_tutors = cursor.fetchall()

    # Agrega las materias de cada tutor
    for tutor in top_tutors:
        tutor_id = tutor['idUser']  # Usa el ID de cada tutor
        cursor.execute("""
            SELECT s.name AS subject_name, sc.name AS category_name
            FROM tutor_subject ts
            JOIN subject s ON ts.subject_idSubject = s.idSubject
            JOIN subjectcategory sc ON s.subjectCategory_idSubjectCategory = sc.idSubjectCategory
            WHERE ts.tutor_user_idUser = %s
        """, (tutor_id,))
        subjects = cursor.fetchall() or []
        tutor['subjects'] = subjects  # Añade las materias a cada tutor

    cursor.close()
    conn.close()

    return render_template('index.html', top_tutors=top_tutors)

from datetime import datetime

@app.route('/help')
def help():
    return render_template('help.html')

@app.route('/mydates')
def mydates():
        # Verifica si el usuario está autenticado
    if 'user_id' not in session:
        return redirect(url_for('login'))

    # Obtén el user_id de la sesión
    user_id = session.get('user_id')  # Obtén el ID del usuario de la sesión de manera segura
    if not user_id:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    # Obtén los datos del usuario
    cur.execute("SELECT * FROM user WHERE idUser = %s", (user_id,))
    user = cur.fetchone()

        # Verificar si el usuario es tutor
    cur.execute("SELECT * FROM tutor WHERE user_idUser = %s", (user_id,))
    tutor = cur.fetchone()

    notis = []
     # Si el usuario es tutor, obtener reseñas y notificaciones
    if tutor:
         cur.execute("""
            SELECT tutorsNotification.tutor_user_idUser, tutorsNotification.student_user_idUser, tutorsNotification.description, tutorsNotification.seen, tutorsNotification.createdAt, user.name AS student_name, user.lastname AS student_lastname, user.profile_picture 
            FROM tutorsNotification
            JOIN user ON tutorsNotification.student_user_idUser = user.idUser
            WHERE tutorsNotification.tutor_user_idUser = %s
            ORDER BY tutorsNotification.createdAt DESC
        """, (user_id,))
    notis = cur.fetchall() or []
    
        # Cierra la conexión a la base de datos
    cur.close()
    conn.close()

    return render_template('mydates.html', user=user, tutor=tutor, notis=notis)

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

        if not tutor_id:
            return "Por favor selecciona un tutor", 400

        try:
            tutor_id = int(tutor_id)
        except ValueError:
            return "ID del tutor no válido", 400

        if not slot_time_id:
            return "Por favor selecciona un horario", 400

        try:
            slot_time_id = int(slot_time_id)
        except ValueError:
            return "ID del horario no válido", 400

        try:
            fecha = datetime.strptime(fecha, '%Y-%m-%d')
        except ValueError:
            return "Formato de fecha inválido. Usa AAAA-MM-DD.", 400

        # Guardar el registro en la tabla schedule y crear una notificación
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
            
            notification_description = f"El estudiante {session['user_name']} ha agendado una cita para {fecha}."
            cursor.execute(
                """
                INSERT INTO tutorsNotification (tutor_user_idUser, student_user_idUser, description, seen, createdAt)
                VALUES (%s, %s ,%s, %s, %s)
                """,
                (tutor_id, student_id, notification_description, 0, datetime.now())
            )

            # Obtener el correo del tutor
            cursor.execute("SELECT email FROM user WHERE idUser = %s", (tutor_id,))
            tutor_email = cursor.fetchone()
            if tutor_email:
                tutor_email = tutor_email[0]

            conn.commit()
        except Exception as e:
            conn.rollback()
            print(f"Error al agendar cita o crear notificación: {e}")
            return "Hubo un error al procesar la solicitud", 500
        finally:
            cursor.close()
            conn.close()

        # Enviar correo al tutor
        if tutor_email:
            try:
                msg = Message(
                    "Nueva cita agendada",
                    sender="noreply@miapp.com",
                    recipients=[tutor_email]
                )
                msg.body = f"""
                Hola,
                
                Se ha agendado una nueva cita para el {fecha.strftime('%Y-%m-%d')}.
                Estudiante: {session['user_name']}
                """
                mail.send(msg)
            except Exception as e:
                print(f"Error al enviar el correo: {e}")
                return "Cita agendada, pero no se pudo enviar el correo", 500

        return redirect(url_for('tutors'))

    # Obtener horarios disponibles para el formulario
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT idSlotTime, startTime, endTime FROM slottime")
        slot_times = cursor.fetchall()

        cursor.execute("SELECT idUser, name FROM user INNER JOIN tutor ON user.idUser = tutor.user_idUser")
        tutors = cursor.fetchall()
    except Exception as e:
        print(f"Error al cargar datos para agendar: {e}")
        return "Error al cargar datos para agendar", 500
    finally:
        cursor.close()
        conn.close()

    return render_template('agendar.html', slot_times=slot_times, tutors=tutors)


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        # Obtener datos del formulario
        profile_picture = request.files['profile_picture']
        name = request.form['name']
        lastName = request.form['lastName']
        college_idCollege = request.form['college_idCollege']
        idDegree_subdegree = request.form['idDegree_subdegree']
        term = request.form['term']
        email = request.form['email']
        password = request.form['password']
        is_tutor = request.form.get('is_tutor', 'no')  # Default 'no'
        cost = request.form['cost'] if is_tutor == 'yes' else None
        selected_subjects = request.form.getlist('subjects') if is_tutor == 'yes' else []

        # Validar foto de perfil
        profile_picture_path = None
        if profile_picture and allowed_file(profile_picture.filename):
            filename = secure_filename(profile_picture.filename)
            timestamp = time.strftime("%Y%m%d_%H%M%S")
            filename = f"{filename.rsplit('.', 1)[0]}_{timestamp}.{filename.rsplit('.', 1)[1]}"
            profile_picture_path = os.path.join(app.config['UPLOAD_FOLDER'], filename).replace("\\", "/")
            profile_picture.save(profile_picture_path)

        # Validar el correo electrónico
        if not email.endswith('@utch.edu.mx'):
            return 'El correo debe tener la terminación @utch.edu.mx', 400

        # Validar que el costo esté presente si el usuario es tutor
        if is_tutor == 'yes' and (not cost or not cost.isdigit() or int(cost) <= 0):
            return 'Debes ingresar un costo válido para ser tutor', 400

        # Conexión a la base de datos
        conn = get_db_connection()
        cur = conn.cursor()

        try:
            # Insertar en la tabla `user`
            cur.execute(
                '''
                INSERT INTO user (name, lastName, college_idCollege, idDegree_subdegree, term, email, password, profile_picture) 
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                ''',
                (name, lastName, college_idCollege, idDegree_subdegree, term, email, password, profile_picture_path)
            )
            user_id = cur.lastrowid

            # Verificar si el usuario ya está en la tabla `student`
            cur.execute('SELECT COUNT(*) FROM student WHERE user_idUser = %s', (user_id,))
            if cur.fetchone()[0] == 0:
                cur.execute(
                    '''
                    INSERT INTO student (user_idUser, online, createdAt, active) 
                    VALUES (%s, %s, %s, %s)
                    ''',
                    (user_id, 0, datetime.now(), 1)
                )

            # Insertar en la tabla `tutor` si aplica
            if is_tutor == 'yes' and cost:
                cur.execute(
                    '''
                    INSERT INTO tutor (user_idUser, asesoryCost, meanRating, online, createdAt, active) 
                    VALUES (%s, %s, %s, %s, %s, %s)
                    ''',
                    (user_id, cost, 0, 0, datetime.now(), 1)
                )

                # Validar y registrar materias seleccionadas
                for subject_id in selected_subjects:
                    cur.execute('SELECT COUNT(*) FROM subject WHERE idSubject = %s', (subject_id,))
                    if cur.fetchone()[0] == 1:  # La materia existe
                        cur.execute(
                            '''
                            INSERT INTO tutor_subject (tutor_user_idUser, subject_idSubject) 
                            VALUES (%s, %s)
                            ''',
                            (user_id, subject_id)
                        )

            conn.commit()
        except Exception as e:
            conn.rollback()  # Revertir cambios en caso de error
            return f'Ocurrió un error: {str(e)}', 500
        finally:
            cur.close()
            conn.close()

        return redirect(url_for('index'))

    # Si es un método GET, cargar datos para los dropdowns
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    try:
        # Obtener universidades
        cur.execute("SELECT idCollege, name FROM college")
        colleges = cur.fetchall()

        # Obtener especialidades
        cur.execute("SELECT idSubdegree, name FROM subdegree")
        subdegrees = cur.fetchall()

        # Obtener categorías y materias
        cur.execute("SELECT idSubjectCategory, name FROM subjectcategory")
        categories = cur.fetchall()

        for category in categories:
            cur.execute(
                '''
                SELECT idSubject, name 
                FROM subject 
                WHERE subjectCategory_idSubjectCategory = %s
                ''',
                (category['idSubjectCategory'],)
            )
            category['subjects'] = cur.fetchall()
    finally:
        cur.close()
        conn.close()

    return render_template('register.html', colleges=colleges, subdegrees=subdegrees, categories=categories)




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

    # Obtén el user_id de la sesión
    user_id = session.get('user_id')  # Obtén el ID del usuario de la sesión de manera segura
    if not user_id:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    # Obtén la información del usuario y sus relaciones necesarias
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

    # Verificar si el usuario es tutor
    cur.execute("SELECT * FROM tutor WHERE user_idUser = %s", (user_id,))
    tutor = cur.fetchone()

    # Inicializa listas vacías para reseñas, notificaciones y materias
    reviews = []
    notis = []
    subjects = []

    # Si el usuario es tutor, obtener reseñas, notificaciones y materias
    if tutor:
        # Reseñas del tutor
        cur.execute("""
            SELECT review.rating, review.description, user.name AS student_name, user.lastName AS student_lastname, user.profile_picture AS student_profile_picture
            FROM review
            JOIN user ON review.student_user_idUser = user.idUser
            WHERE tutor_user_idUser = %s
            ORDER BY createdAt DESC
        """, (user_id,))
        reviews = cur.fetchall() or []

        # Notificaciones para el tutor
        cur.execute("""
            SELECT tutorsNotification.tutor_user_idUser, tutorsNotification.student_user_idUser, tutorsNotification.description, tutorsNotification.seen, tutorsNotification.createdAt, user.name AS student_name, user.lastname AS student_lastname, user.profile_picture 
            FROM tutorsNotification
            JOIN user ON tutorsNotification.student_user_idUser = user.idUser
            WHERE tutorsNotification.tutor_user_idUser = %s
            ORDER BY tutorsNotification.createdAt DESC
        """, (user_id,))
        notis = cur.fetchall() or []

        # Materias que imparte el tutor
        cur.execute("""
            SELECT s.name AS subject_name, sc.name AS category_name
            FROM tutor_subject ts
            JOIN subject s ON ts.subject_idSubject = s.idSubject
            JOIN subjectcategory sc ON s.subjectCategory_idSubjectCategory = sc.idSubjectCategory
            WHERE ts.tutor_user_idUser = %s
        """, (user_id,))
        subjects = cur.fetchall() or []

    # Cierra la conexión a la base de datos
    cur.close()
    conn.close()

    # Pasa los datos del usuario y materias a la plantilla
    return render_template('perfil.html', user=user, tutor=tutor, reviews=reviews, notis=notis, subjects=subjects)


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
        SELECT tutor.user_idUser, user.name, user.lastName, user.profile_picture, 
               tutor.asesoryCost, tutor.meanRating, tutor.online, user.term
        FROM user
        INNER JOIN tutor ON user.idUser = tutor.user_idUser
    """)
    tutors = cursor.fetchall()

    # Diccionario para almacenar tutores y sus materias
    tutors_with_subjects = []
    
    for tutor in tutors:
        tutor_id = tutor['user_idUser']
        
        # Recupera las materias del tutor
        cursor.execute("""
            SELECT s.name AS subject_name, sc.name AS category_name
            FROM tutor_subject ts
            JOIN subject s ON ts.subject_idSubject = s.idSubject
            JOIN subjectcategory sc ON s.subjectCategory_idSubjectCategory = sc.idSubjectCategory
            WHERE ts.tutor_user_idUser = %s
        """, (tutor_id,))
        subjects = cursor.fetchall()
        
        # Agrega las materias al tutor
        tutor['subjects'] = subjects
        tutors_with_subjects.append(tutor)

    cursor.close()
    conn.close()

    return render_template('tutors.html', tutors=tutors_with_subjects)

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