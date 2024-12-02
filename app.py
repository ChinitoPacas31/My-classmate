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
UPLOAD_FOLDER = 'static/uploads'  
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

# Función para verificar extensiones permitidas
def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def get_db_connection():
    return mysql.connector.connect(user="root", password="", host="localhost", port="3306", database="myclassmate")

# Configuración de Flask-Mail
app.config['MAIL_SERVER'] = 'smtp.googlemail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'myclassmate8@gmail.com'  
app.config['MAIL_PASSWORD'] = 'zlcq jjta ripg yruz'        
mail = Mail(app)


@app.route('/')
def index():
    
    user_id = session.get('user_id')  

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
        tutor_id = tutor['idUser'] 
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

    
    user_id = session.get('user_id')  
    if not user_id:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    
    cur.execute("SELECT * FROM user WHERE idUser = %s", (user_id,))
    user = cur.fetchone()

        
    cur.execute("SELECT * FROM tutor WHERE user_idUser = %s", (user_id,))
    tutor = cur.fetchone()

    notis = []
    
    if tutor:
         cur.execute("""
            SELECT tutorsNotification.tutor_user_idUser, tutorsNotification.student_user_idUser, tutorsNotification.description, tutorsNotification.seen, tutorsNotification.createdAt, user.name AS student_name, user.lastname AS student_lastname, user.profile_picture 
            FROM tutorsNotification
            JOIN user ON tutorsNotification.student_user_idUser = user.idUser
            WHERE tutorsNotification.tutor_user_idUser = %s
            ORDER BY tutorsNotification.createdAt DESC
        """, (user_id,))
    notis = cur.fetchall() or []
    
    
    cur.close()
    conn.close()

    return render_template('mydates.html', user=user, tutor=tutor, notis=notis)

@app.route('/agendar', methods=['GET', 'POST'])
def agendar():
    
    if 'user_id' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        
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
        
        profile_picture = request.files['profile_picture']
        name = request.form['name']
        lastName = request.form['lastName']
        college_idCollege = request.form['college_idCollege']
        idDegree_subdegree = request.form['idDegree_subdegree']
        term = request.form['term']
        email = request.form['email']
        password = request.form['password']
        is_tutor = request.form.get('is_tutor', 'no')  
        cost = request.form['cost'] if is_tutor == 'yes' else None
        selected_subjects = request.form.getlist('subjects') if is_tutor == 'yes' else []

    
        profile_picture_path = None
        if profile_picture and allowed_file(profile_picture.filename):
            filename = secure_filename(profile_picture.filename)
            timestamp = time.strftime("%Y%m%d_%H%M%S")
            filename = f"{filename.rsplit('.', 1)[0]}_{timestamp}.{filename.rsplit('.', 1)[1]}"
            profile_picture_path = os.path.join(app.config['UPLOAD_FOLDER'], filename).replace("\\", "/")
            profile_picture.save(profile_picture_path)


        if not email.endswith('@utch.edu.mx'):
            return 'El correo debe tener la terminación @utch.edu.mx', 400


        if is_tutor == 'yes' and (not cost or not cost.isdigit() or int(cost) <= 0):
            return 'Debes ingresar un costo válido para ser tutor', 400


        conn = get_db_connection()
        cur = conn.cursor()

        try:
            
            cur.execute(
                '''
                INSERT INTO user (name, lastName, college_idCollege, idDegree_subdegree, term, email, password, profile_picture) 
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                ''',
                (name, lastName, college_idCollege, idDegree_subdegree, term, email, password, profile_picture_path)
            )
            user_id = cur.lastrowid

    
            cur.execute('SELECT COUNT(*) FROM student WHERE user_idUser = %s', (user_id,))
            if cur.fetchone()[0] == 0:
                cur.execute(
                    '''
                    INSERT INTO student (user_idUser, online, createdAt, active) 
                    VALUES (%s, %s, %s, %s)
                    ''',
                    (user_id, 0, datetime.now(), 1)
                )


            if is_tutor == 'yes' and cost:
                cur.execute(
                    '''
                    INSERT INTO tutor (user_idUser, asesoryCost, meanRating, online, createdAt, active) 
                    VALUES (%s, %s, %s, %s, %s, %s)
                    ''',
                    (user_id, cost, 0, 0, datetime.now(), 1)
                )

                
                for subject_id in selected_subjects:
                    cur.execute('SELECT COUNT(*) FROM subject WHERE idSubject = %s', (subject_id,))
                    if cur.fetchone()[0] == 1:  
                        cur.execute(
                            '''
                            INSERT INTO tutor_subject (tutor_user_idUser, subject_idSubject) 
                            VALUES (%s, %s)
                            ''',
                            (user_id, subject_id)
                        )

            conn.commit()
        except Exception as e:
            conn.rollback()  
            return f'Ocurrió un error: {str(e)}', 500
        finally:
            cur.close()
            conn.close()

        return redirect(url_for('index'))

    
    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    try:
    
        cur.execute("SELECT idCollege, name FROM college")
        colleges = cur.fetchall()

    
        cur.execute("SELECT idSubdegree, name FROM subdegree")
        subdegrees = cur.fetchall()

        
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

        if user:  
            
            salted_password = user['password']
            salt, stored_hash = salted_password.split(':')

            
            attempt_hash = hashlib.sha256((salt + password).encode('utf-8')).hexdigest().upper()

        
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
    
    if 'user_id' not in session:
        return redirect(url_for('login'))


    user_id = session.get('user_id')  
    if not user_id:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cur = conn.cursor(dictionary=True)

    
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

    
    cur.execute("SELECT * FROM tutor WHERE user_idUser = %s", (user_id,))
    tutor = cur.fetchone()

    
    reviews = []
    notis = []
    subjects = []

    
    if tutor:
        
        cur.execute("""
            SELECT review.rating, review.description, user.name AS student_name, user.lastName AS student_lastname, user.profile_picture AS student_profile_picture
            FROM review
            JOIN user ON review.student_user_idUser = user.idUser
            WHERE tutor_user_idUser = %s
            ORDER BY createdAt DESC
        """, (user_id,))
        reviews = cur.fetchall() or []

        
        cur.execute("""
            SELECT tutorsNotification.tutor_user_idUser, tutorsNotification.student_user_idUser, tutorsNotification.description, tutorsNotification.seen, tutorsNotification.createdAt, user.name AS student_name, user.lastname AS student_lastname, user.profile_picture 
            FROM tutorsNotification
            JOIN user ON tutorsNotification.student_user_idUser = user.idUser
            WHERE tutorsNotification.tutor_user_idUser = %s
            ORDER BY tutorsNotification.createdAt DESC
        """, (user_id,))
        notis = cur.fetchall() or []

        
        cur.execute("""
            SELECT s.name AS subject_name, sc.name AS category_name
            FROM tutor_subject ts
            JOIN subject s ON ts.subject_idSubject = s.idSubject
            JOIN subjectcategory sc ON s.subjectCategory_idSubjectCategory = sc.idSubjectCategory
            WHERE ts.tutor_user_idUser = %s
        """, (user_id,))
        subjects = cur.fetchall() or []

    
    cur.close()
    conn.close()


    return render_template('perfil.html', user=user, tutor=tutor, reviews=reviews, notis=notis, subjects=subjects)


@app.route('/edit_profile', methods=['GET', 'POST'])
def edit_profile():
    if request.method == 'POST':
       
        pass

   
    return render_template('edit_profile.html')



@app.route('/tutors')
def tutors():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    
    cursor.execute("""
        SELECT tutor.user_idUser, user.name, user.lastName, user.profile_picture, 
               tutor.asesoryCost, tutor.meanRating, tutor.online, user.term
        FROM user
        INNER JOIN tutor ON user.idUser = tutor.user_idUser
    """)
    tutors = cursor.fetchall()

   
    tutors_with_subjects = []
    
    for tutor in tutors:
        tutor_id = tutor['user_idUser']
        
    
        cursor.execute("""
            SELECT s.name AS subject_name, sc.name AS category_name
            FROM tutor_subject ts
            JOIN subject s ON ts.subject_idSubject = s.idSubject
            JOIN subjectcategory sc ON s.subjectCategory_idSubjectCategory = sc.idSubjectCategory
            WHERE ts.tutor_user_idUser = %s
        """, (tutor_id,))
        subjects = cursor.fetchall()
        
        
        tutor['subjects'] = subjects
        tutors_with_subjects.append(tutor)

    cursor.close()
    conn.close()

    return render_template('tutors.html', tutors=tutors_with_subjects)

@app.route('/calificar', methods=['GET', 'POST'])
def calificar():
    
    if 'user_id' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        tutor_id = request.form.get('tutor_user_idUser')
        student_id = session['user_id']
        rating = request.form.get('rating')
        description = request.form.get('description', '')

        
        if not tutor_id or not rating:
            return "Por favor selecciona un tutor y una calificación", 400

    
        cursor.execute("""
            INSERT INTO review (tutor_user_idUser, student_user_idUser, rating, description)
            VALUES (%s, %s, %s, %s)
        """, (tutor_id, student_id, rating, description))
        conn.commit()

        
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

    
    cursor.execute("SELECT idUser, name, lastName FROM user INNER JOIN tutor ON user.idUser = tutor.user_idUser")
    tutors = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('calificar.html', tutors=tutors)

@app.route('/delete_account', methods=['POST'])
def delete_account():
    
    if 'user_id' not in session:
        return redirect(url_for('login'))

    user_id = session['user_id']
    conn = get_db_connection()
    cursor = conn.cursor()

    try:

        cursor.execute('DELETE FROM review WHERE tutor_user_idUser = %s OR student_user_idUser = %s', (user_id, user_id))
        cursor.execute('DELETE FROM tutor WHERE user_idUser = %s', (user_id,))
        cursor.execute('DELETE FROM student WHERE user_idUser = %s', (user_id,))
        cursor.execute('DELETE FROM user WHERE idUser = %s', (user_id,))

        conn.commit()

        
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

    return redirect(url_for('index'))  



if __name__ == '__main__':
    app.run(port=3000, debug=True)