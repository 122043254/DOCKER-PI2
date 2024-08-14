from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
import mysql.connector
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime

app = Flask(__name__)
app.secret_key = 'tu_clave_secreta_aqui'  # Cambia esto por una clave secreta real


def get_db_connection():
    try:
        connection = mysql.connector.connect(
            host='mysql',
            user='root',
            password='root',
            database='Guiatu2'
        )
        return connection
    except mysql.connector.Error as err:
        print(f"Database connection error: {err}")
        raise


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/post')
def post():
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute('SELECT id_destino, nombre_destino FROM Destinos')
    places = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('post.html', places=places)


@app.route('/hoteles', methods=['GET'])
def hoteles():
    id_destino = request.args.get('id_destino', type=int)
    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        'SELECT nombre_hotel, descripcion, url_pagina, url_img, dato1, dato2 FROM Hoteles WHERE id_destino = %s',
        (id_destino,))
    hoteles = cursor.fetchall()
    cursor.close()
    conn.close()
    hoteles_list = [{
        'nombre_hotel': hotel[0],
        'descripcion': hotel[1],
        'url_pagina': hotel[2],
        'url_img': hotel[3],
        'dato1': hotel[4],
        'dato2': hotel[5]
    } for hotel in hoteles]
    return jsonify(hoteles_list)


@app.route('/contact')
def contact():
    return render_template('contact.html')


@app.route('/comentarios')
def comentarios():
    return render_template('comentarios.html')


@app.route('/about')
def about():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT id_destino, nombre_destino FROM Destinos")
    destinos = cursor.fetchall()
    connection.close()

    destinos_list = [
        {
            "id_destino": row[0],
            "nombre_destino": row[1]
        }
        for row in destinos
    ]
    return render_template('about.html', destinos=destinos_list)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        correo = request.form.get('correo')
        contrasena = request.form.get('password')

        if not correo or not contrasena:
            flash('Correo y contrasena son requeridos', 'danger')
            return redirect(url_for('login'))

        try:
            connection = get_db_connection()
            cursor = connection.cursor()
            cursor.execute("SELECT * FROM Usuarios WHERE correo = %s", (correo,))
            user = cursor.fetchone()
            cursor.close()
            connection.close()

            if user:
                if check_password_hash(user[4], contrasena):
                    session['user_id'] = user[0]
                    session['user_name'] = user[1]
                    # Registrar la fecha y hora de inicio de sesión
                    connection = get_db_connection()
                    cursor = connection.cursor()
                    cursor.execute("INSERT INTO Login (id_usuario, login_date) VALUES (%s, NOW())", (user[0],))
                    connection.commit()
                    cursor.close()
                    connection.close()
                    return redirect(url_for('index'))
                else:
                    flash('Contraseña incorrecta', 'danger')
            else:
                flash('Correo no encontrado', 'danger')

        except mysql.connector.Error as err:
            flash(f"Error al iniciar sesión: {err}", 'danger')
        except Exception as e:
            flash(f"Error inesperado: {e}", 'danger')

    return render_template('login.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        nombre = request.form.get('nombre')
        apellido = request.form.get('apellido')
        correo = request.form.get('correo')
        contrasena = request.form.get('contrasena')

        # Verifica si todos los campos están presentes
        if not nombre or not apellido or not correo or not contrasena:
            flash('Todos los campos son requeridos', 'danger')
            return redirect(url_for('register'))

        hashed_password = generate_password_hash(contrasena, method='pbkdf2:sha256')

        try:
            connection = get_db_connection()
            cursor = connection.cursor()

            # Verifica si el correo ya está registrado
            cursor.execute("SELECT * FROM Usuarios WHERE correo = %s", (correo,))
            user = cursor.fetchone()
            if user:
                flash('El correo ya está registrado. Por favor, elige otro.', 'danger')
                cursor.close()
                connection.close()
                return redirect(url_for('register'))

            # Inserta el nuevo usuario
            cursor.execute(
                "INSERT INTO Usuarios (nombre, apellido, correo, contrasena, fecha_registro) VALUES (%s, %s, %s, %s, NOW())",
                (nombre, apellido, correo, hashed_password)
            )
            connection.commit()
            cursor.close()
            connection.close()
            flash('Registro exitoso. Ahora puedes iniciar sesión.', 'success')
            return redirect(url_for('login'))

        except mysql.connector.Error as err:
            flash(f"Error al registrar el usuario: {err}", 'danger')
            if connection.is_connected():
                connection.rollback()
            return redirect(url_for('register'))

        except Exception as e:
            flash(f"Error inesperado: {e}", 'danger')
            return redirect(url_for('register'))

    return render_template('register.html')


@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('user_name', None)
    return redirect(url_for('index'))


@app.route('/get_destinations', methods=['GET'])
def get_destinations():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("SELECT id_destino, nombre_destino, descripcion FROM Destinos")
    destinos = cursor.fetchall()

    images = {
        1: "bernal1.jpg",
        2: "termas1.jpg",
        3: "sierra_gorda1.jpg",
        4: "chuveje1.jpg"
    }

    destinations_list = [
        {
            "id": row[0],
            "name": row[1],
            "description": row[2],
            "image": images.get(row[0], "placeholder.jpg")
        }
        for row in destinos]
    return jsonify(destinations_list)


@app.route('/submit_comment', methods=['POST'])
def submit_comment():
    data = request.json
    id_destino = data.get('id_destino')
    comment = data.get('comment')
    rating = data.get('rating')

    if not id_destino or not comment or not rating:
        return jsonify({"status": "error", "message": "All fields are required"}), 400

    if 'user_id' not in session:
        return jsonify({"status": "error", "message": "User not authenticated"}), 401

    id_usuario = session['user_id']
    fecha_opinion = datetime.now().strftime('%Y-%m-%d')

    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        INSERT INTO Opiniones (id_usuario, id_destino, comentario, calificacion, fecha_opinion)
        VALUES (%s, %s, %s, %s, %s)
    """, (id_usuario, id_destino, comment, rating, fecha_opinion))
    connection.commit()

    return jsonify({"status": "success"})


@app.route('/get_comments/<int:id_destino>', methods=['GET'])
def get_comments(id_destino):
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT Opiniones.id_opinion, Opiniones.comentario, Opiniones.calificacion, Opiniones.fecha_opinion, Usuarios.nombre
        FROM Opiniones
        JOIN Usuarios ON Opiniones.id_usuario = Usuarios.id_usuario
        WHERE Opiniones.id_destino = %s
    """, (id_destino,))
    comments = cursor.fetchall()
    connection.close()

    comments_list = [
        {
            "id_opinion": row[0],
            "comment": row[1],
            "rating": row[2],
            "date": row[3],
            "user_name": row[4]
        }
        for row in comments
    ]
    return jsonify(comments_list)


@app.route('/edit_comment', methods=['POST'])
def edit_comment():
    data = request.json
    id_opinion = data.get('id_opinion')
    new_comment = data.get('comment')

    if not id_opinion or not new_comment:
        return jsonify({"status": "error", "message": "All fields are required"}), 400

    if 'user_id' not in session:
        return jsonify({"status": "error", "message": "User not authenticated"}), 401

    connection = get_db_connection()
    cursor = connection.cursor()

    cursor.execute("SELECT id_usuario FROM Opiniones WHERE id_opinion = %s", (id_opinion,))
    comment_owner = cursor.fetchone()
    if not comment_owner or comment_owner[0] != session['user_id']:
        connection.close()
        return jsonify({"status": "error", "message": "You can only edit your own comments"}), 403

    cursor.execute("""
        UPDATE Opiniones
        SET comentario = %s
        WHERE id_opinion = %s
    """, (new_comment, id_opinion))
    connection.commit()
    connection.close()

    return jsonify({"status": "success"})


@app.route('/get_activities/<int:id_destino>', methods=['GET'])
def get_activities(id_destino):
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("""
        SELECT id_actividad, nombre_actividad, descripcion, duracion, costos
        FROM Actividades
        WHERE id_destino = %s
    """, (id_destino,))
    activities = cursor.fetchall()
    connection.close()

    images = {
        1: "Bernal.webp",
        2: "tallerBernal.png",
        3: "vinelloBernal.png",
        4: "AguaTermalesSanJoaquin.png",
        5: "LuciernagasSanJoaquin.jpg",
        6: "ReforestacionSanJoaquin.png",
        7: "AveSierraGorda.jpg",
        8: "sierraGorda.png",
        9: "EcoturismoSierra.png",
        10: "LimpiezaSenderoChuveje.png",
        11: "ConservacionAguaChuveje.png",
        12: "CampamentoChuveje.png"
    }

    activities_list = [
        {
            "id_actividad": row[0],
            "nombre_actividad": row[1],
            "descripcion": row[2],
            "duracion": str(row[3]),  # Convertir a cadena si es necesario
            "costos": row[4],
            "image": url_for('static', filename='assets/' + images.get(row[0], "placeholder.jpg"))
        }
        for row in activities
    ]
    return jsonify(activities_list)


@app.errorhandler(404)
def paginanotfound(e):
    return 'Revisa tu sintaxis: No encontré nada'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
