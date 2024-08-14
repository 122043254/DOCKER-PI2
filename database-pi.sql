-- Crear la base de datos
#CREATE DATABASE Guiatu2;

-- Usar la base de datos
USE Guiatu2;

-- Crear tabla Usuarios
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT,
    nombre VARCHAR(150),
    apellido VARCHAR(150),
    correo VARCHAR(100),
    contrasena VARCHAR(225),
    fecha_registro DATE,
    PRIMARY KEY (id_usuario)
);

-- Crear tabla Login
CREATE TABLE Login (
    id INT AUTO_INCREMENT,
    id_usuario INT,
    login_date DATETIME,
    PRIMARY KEY (id),
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
);

-- Crear tabla Administradores
CREATE TABLE Administradores (
    id_administrador INT AUTO_INCREMENT,
    id_usuario INT,
    rol VARCHAR(50),
    fecha_inicio DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    PRIMARY KEY (id_administrador)
);

-- Crear tabla Destinos
CREATE TABLE Destinos (
    id_destino INT AUTO_INCREMENT,
    nombre_destino VARCHAR(255),
    descripcion VARCHAR(600),
    PRIMARY KEY (id_destino)
);

-- Crear tabla Atractivos_Turisticos
CREATE TABLE Atractivos_Turisticos (
    id_atractivo_turistico INT AUTO_INCREMENT,
    id_destino INT,
    nombre_atractivo VARCHAR(100),
    descripcion VARCHAR(600),
    horario_apertura TIME,
    horario_cierre TIME,
    FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino),
    PRIMARY KEY (id_atractivo_turistico)
);

-- Crear tabla Historia_Eventos_Destinos
CREATE TABLE Historia_Eventos_Destinos (
    id_historia_evento INT AUTO_INCREMENT,
    id_destino INT,
    descripcion_fecha_evento VARCHAR(600),
    FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino),
    PRIMARY KEY (id_historia_evento)
);

-- Crear tabla Hoteles
CREATE TABLE Hoteles (
    id_hotel INT AUTO_INCREMENT,
    nombre_hotel VARCHAR(100),
    descripcion VARCHAR(600),
    url_pagina VARCHAR(2083),
    url_img VARCHAR(2083),
    dato1 VARCHAR(50),
    dato2 VARCHAR(50),
    id_destino INT,
    PRIMARY KEY (id_hotel),
    FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino)
);

-- Crear tabla Actividades
CREATE TABLE Actividades (
    id_actividad INT AUTO_INCREMENT,
    nombre_actividad VARCHAR(100),
    descripcion VARCHAR(600),
    duracion TIME,
    id_destino INT,
    costos DECIMAL(10,2),
    PRIMARY KEY (id_actividad),
    FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino)
);

-- Crear tabla Reservas
CREATE TABLE Reservas (
    id_reserva INT AUTO_INCREMENT,
    id_usuario INT,
    id_hotel INT,
    id_actividad INT,
    fecha_reserva DATE,
    fecha_inicio DATE,
    fecha_fin DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_hotel) REFERENCES Hoteles(id_hotel),
    FOREIGN KEY (id_actividad) REFERENCES Actividades(id_actividad),
    PRIMARY KEY (id_reserva)
);

-- Crear tabla Sostenibilidad_Destinos
CREATE TABLE Sostenibilidad_Destinos (
    id_sostenibilidad INT AUTO_INCREMENT,
    id_destino INT,
    descripcion VARCHAR(600),
    FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino),
    PRIMARY KEY (id_sostenibilidad)
);

-- Crear tabla Opiniones
CREATE TABLE Opiniones (
    id_opinion INT AUTO_INCREMENT,
    id_usuario INT,
    id_destino INT,
    calificacion INT,
    comentario VARCHAR(300),
    fecha_opinion DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
    FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino),
    PRIMARY KEY (id_opinion)
);

-- INSERTS
INSERT INTO Usuarios (nombre, apellido, correo, contrasena, fecha_registro) VALUES
('Juan', 'Pérez', 'juan.perez@example.com', 'contraseña123', '2024-08-01'),
('Ana', 'Gómez', 'ana.gomez@example.com', 'contraseña456', '2024-08-02'),
('Carlos', 'Martínez', 'carlos.martinez@example.com', 'contraseña789', '2024-08-03'),
('Laura', 'Hernández', 'laura.hernandez@example.com', 'contraseña101', '2024-08-04');

INSERT INTO Destinos (nombre_destino, descripcion) VALUES
('Peña de Bernal', 'Escala o camina hasta la tercera formación monolítica más grande del mundo, ubicada en el Pueblo Mágico de Bernal. Desde la cima, disfrutarás de impresionantes vistas panorámicas'),
('Las Termas de San Joaquín', 'Relájate en las aguas termales de este balneario ubicado en el municipio de San Joaquín, rodeado de un entorno natural impresionante.'),
('Sierra Gorda', 'Explora la belleza natural de la Sierra Gorda, donde encontrarás cascadas, ríos, grutas y una diversidad de flora y fauna.'),
('La Cascada de Chuveje', 'Haz una caminata por la selva para llegar a esta impresionante cascada de más de 30 metros de altura, ubicada en la Sierra Gorda de Querétaro.');

-- Actividades en Peña de Bernal
INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos) VALUES
('Senderismo y Escalada con Guías Locales', 'Descubre la magia de la Peña de Bernal a través de emocionantes actividades al aire libre, como el senderismo y la escalada. Nuestros guías locales expertos te llevarán a explorar la belleza natural de este monolito, uno de los más grandes del mundo. La caminata hacia la cima ofrece vistas panorámicas espectaculares y una experiencia única. ¡No te lo pierdas!', '07:00:00', 1, 50.00),
('Talleres de Artesanías Locales', 'Asistir a talleres de fabricación de artesanías con materiales locales y sostenibles, promoviendo la cultura y las prácticas tradicionales', '09:00:00', 1, 0.00),
('Visitas a Viñedos Orgánicos', 'Explorar viñedos que practican agricultura orgánica y sostenible, aprendiendo sobre técnicas de cultivo respetuosas con el medio ambiente.', '07:00:00', 1, 250.00);

-- Actividades en Termas San Joaquín
INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos) VALUES
('Baños Termales con Energía Sostenible', 'Disfrutar de las aguas termales alimentadas por fuentes geotérmicas, mientras te informas sobre las prácticas de eficiencia energética en el manejo de las instalaciones.', '08:00:00', 2, 270.00),
('Sendero de historias y luciérnagas', 'El Sendero del Camino Real es una ruta de nueve kilómetros que comienza en el llamado Puerto de las Pilas, en la cabecera municipal de San Joaquín.', '07:00:00', 2, 0.00),
('Jornadas de Reforestación', 'Participa en actividades de reforestación y mantenimiento de áreas verdes en los alrededores, ayudando a restaurar el ecosistema local.', '06:00:00', 2, 0.00);

-- Actividades en Sierra Gorda
INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos) VALUES
('Observación de Fauna Silvestre', 'Explora la rica biodiversidad de la Sierra Gorda con actividades de observación de fauna en su hábitat natural.', '09:00:00', 3, 80.00),
('Excursión de un día al Cañón del Río Escanela', 'Aventura de un día completo explorando el impresionante cañón y sus alrededores, con actividades guiadas de senderismo y exploración.', '08:00:00', 3, 90.00),
('Visita a Proyectos de Conservación', 'Participa en visitas guiadas a proyectos locales que trabajan en la conservación y protección del medio ambiente.', '06:00:00', 3, 0.00);

-- Actividades en Cascada de Chuveje
INSERT INTO Actividades (nombre_actividad, descripcion, duracion, id_destino, costos) VALUES
('Caminatas Guiadas a la Cascada', 'Disfruta de caminatas guiadas por expertos que te llevarán a explorar la majestuosa Cascada de Chuveje y sus alrededores.', '05:00:00', 4, 60.00),
('Camping y Observación de Estrellas', 'Acampa cerca de la cascada y disfruta de una noche bajo las estrellas con vistas impresionantes y tranquilidad.', '24:00:00', 4, 100.00),
('Talleres de Fotografía Natural', 'Participa en talleres para capturar la belleza de la cascada y el paisaje circundante a través de la fotografía.', '04:00:00', 4, 50.00);

-- Inserciones de hoteles
INSERT INTO Hoteles (nombre_hotel,descripcion,url_pagina,url_img,dato1,dato2,id_destino)
VALUES
('Hotel de Piedra','El Hotel de Piedra se encuentra en Bernal y ofrece bar y restaurante. Este hotel de 4 estrellas cuenta con WiFi gratuita y recepción 24 horas. La Peña de Bernal está a 600 metros.','https://www.booking.com/hotel/mx/de-piedra.es-mx.html?aid=306396&label=bernal-mx-RY43pYGnFNOgfIBJEui0JQS392667752851%3Apl%3Ata%3Ap1%3Ap2%3Aac%3Aap%3Aneg%3Afi%3Atikwd-358868930840%3Alp9129474%3Ali%3Adec%3Adm%3Appccp%3DUmFuZG9tSVYkc2RlIyh9YdnZzv7u3SiOco5fpqS0M1M&sid=4a3f7eda614e207cc6ca2e46fb8cebac&all_sr_blocks=330473302_278772936_0_0_0;checkin=2024-08-11;checkout=2024-08-12;dest_id=-1652940;dest_type=city;dist=0;group_adults=2;group_children=0;hapos=1;highlighted_blocks=330473302_278772936_0_0_0;hpos=1;matching_block_id=330473302_278772936_0_0_0;no_rooms=1;req_adults=2;req_children=0;room1=A%2CA;sb_price_type=total;sr_order=popularity;sr_pri_blocks=330473302_278772936_0_0_0__285407;srepoch=1722819689;srpvid=63b10609fa49003f;type=total;ucfs=1&','https://cf.bstatic.com/xdata/images/hotel/square600/266637971.webp?k=cc9ed2d128fff1c895c560c7f31db7476ae848d33d8c98b19317d22594dc76f4&o=','Sustentable','Libre de humo',1),
('Suites Campestres Montebello','Suites Campestres Montebello se encuentra en Bernal, a 8,9 km de Peña de Bernal, y ofrece alojamiento con piscina al aire libre, parking privado gratis, jardín y terraza.','https://www.booking.com/hotel/mx/montebello-bernal.es.html?label=bernal-mx-RY43pYGnFNOgfIBJEui0JQS392667752851%3Apl%3Ata%3Ap1%3Ap2%3Aac%3Aap%3Aneg%3Afi%3Atikwd-358868930840%3Alp9129474%3Ali%3Adec%3Adm%3Appccp%3DUmFuZG9tSVYkc2RlIyh9YdnZzv7u3SiOco5fpqS0M1M&gclid=Cj0KCQjwzby1BhCQARIsAJ_0t5OOGVTmUzu37ofoW13LAvUPxguHcbn4LS0IEtf1XseHeBNm5GbMO3EaAn8cEALw_wcB&aid=306396','https://cf.bstatic.com/xdata/images/hotel/square600/254209480.webp?k=e6c6e9faae3a7b01cd61d3b8ff765b5e9caaf8fe9e43efe782f0e13ef5d4a5ab&o=https://cf.bstatic.com/xdata/images/hotel/square600/266637971.webp?k=cc9ed2d128fff1c895c560c7f31db7476ae848d33d8c98b19317d22594dc76f4&o=','Sustentable','Libre de humo',1),
('Hotel Boutique Rancho San Jose','Ofrece alojamiento con terraza y wifi gratis en todo el alojamiento, además de parking privado gratis. Este hotel de 4 estrellas ofrece mostrador de información turística.','https://www.booking.com/hotel/mx/boutique-rancho-san-jorge.es.html?label=bernal-mx-RY43pYGnFNOgfIBJEui0JQS392667752851%3Apl%3Ata%3Ap1%3Ap2%3Aac%3Aap%3Aneg%3Afi%3Atikwd-358868930840%3Alp9129474%3Ali%3Adec%3Adm%3Appccp%3DUmFuZG9tSVYkc2RlIyh9YdnZzv7u3SiOco5fpqS0M1M&gclid=Cj0KCQjwzby1BhCQARIsAJ_0t5OOGVTmUzu37ofoW13LAvUPxguHcbn4LS0IEtf1XseHeBNm5GbMO3EaAn8cEALw_wcB&aid=306396','https://cf.bstatic.com/xdata/images/hotel/square600/561182184.webp?k=406ffd999fc87a47552884999f02e2132c782c502007cdb81c61fc3911080bb8&o=','Sustentable','Libre de humo',1),
('Loft Casa-Octeria','Moderno loft tendencia brutalista en medio de la naturaleza y unas vistas increibles,ventanales para apreciar mejor las vistas y una arquitectura que se abraza con el entorno.','https://www.airbnb.mx/rooms/953167592985237480?adults=1&children=0&enable_m3_private_room=true&infants=0&pets=0&search_mode=regular_search&check_in=2024-08-11&check_out=2024-08-16&source_impression_id=p3_1722822503_P3Bw9tElOrvAhtjI&previous_page_section_name=1000&federated_search_id=2cf0acba-5083-4369-8a8a-090ac9d8514a','https://a0.muscache.com/im/pictures/b4b95d97-7bb1-41be-bbda-6fbbba0a594b.jpg?im_w=720','Sustentable','Libre de humo',2),
('Casa de descanso toluquillas','Casa de descanso con las mejores vistas a las montañas y con todas las comodidades que te harán una estancia inigualable.','https://www.airbnb.mx/rooms/597172300603051948?adults=1&children=0&enable_m3_private_room=true&infants=0&pets=0&search_mode=regular_search&check_in=2024-08-11&check_out=2024-08-16&source_impression_id=p3_1722823289_P3OO2e-Kcc9H4PWn&previous_page_section_name=1000&federated_search_id=59a754a8-8b8f-4ba7-859b-ebeb11141970','https://a0.muscache.com/im/pictures/f1f35137-58b6-4f43-8951-7260882ed69d.jpg?im_w=720','Sustentable','Libre de humo',2),
('Bosque de San Joaquín (Cabaña 1)','Muy bien amueblada y acogedora, ideal para relajarse y estar cerca de la naturaleza. Ideal para 4 personas. Muy cómoda y segura, con velador 24/7.','https://www.airbnb.mx/rooms/22925956?adults=1&children=0&enable_m3_private_room=true&infants=0&pets=0&search_mode=regular_search&check_in=2024-08-11&check_out=2024-08-16&source_impression_id=p3_1722823167_P3TqTl40-vvKDFiQ&previous_page_section_name=1000&federated_search_id=59a754a8-8b8f-4ba7-859b-ebeb11141970','https://a0.muscache.com/im/pictures/a5680240-6eee-4719-b9ec-065f41a34b29.jpg?im_w=720','Sustentable','Libre de humo',2),
('Mision Jalpan','Nuestro hotel en Querétaro cuenta con 38 habitaciones con servicios y amenidades de primera clase.','https://www.tripadvisor.com.mx/Hotel_Review-g1597259-d603333-Reviews-Mision_Jalpan-Jalpan_de_Serra_Central_Mexico_and_Gulf_Coast.html','https://media-cdn.tripadvisor.com/media/photo-s/0a/4e/bf/20/fuente-patio-central.jpg','Sustentable','Libre de humo',3),
('Hotel Carretas by Rotamundos','Servicios como terraza, cafetería y bar te esperan en Hotel Carretas by Rotamundos. Podrás conectarte al wifi gratis en las habitaciones y encontrarás diversos servicios, como restaurante.','https://www.expedia.mx/Jalpan-De-Serra-Hoteles-Hotel-Carretas-By-Rotamundos.h59358600.Informacion-Hotel?chkin=2024-08-18&chkout=2024-08-19&x_pwa=1&rfrr=HSR&pwa_ts=1722824250200&referrerUrl=aHR0cHM6Ly93d3cuZXhwZWRpYS5teC9Ib3RlbC1TZWFyY2g%3D&useRewards=false&rm1=a2&regionId=623288425094787072&destination=Franciscan%20Missions%20in%20the%20Sierra%20Gorda%20of%20Quer%C3%A9taro%2C%20Quer%C3%A9taro%2C%20Mexico&destType=MARKET&latLong=21.282654%2C-99.487281&sort=RECOMMENDED&top_dp=1577&top_cur=MXN&gclid=Cj0KCQjwzby1BhCQARIsAJ_0t5NmjSTtGYB4l4Pbu24j9tDi-VmLd6LAI4KNoXuzvQMVJKF4xfzDfNoaAjyzEALw_wcB&semcid=MX.UB.GOOGLE.DT-c-ES.HOTEL&semdtl=a112476355564.b1117227760863.g1kwd-6798948788.e1c.m1Cj0KCQjwzby1BhCQARIsAJ_0t5NmjSTtGYB4l4Pbu24j9tDi-VmLd6LAI4KNoXuzvQMVJKF4xfzDfNoaAjyzEALw_wcB.r1e0295d161cd4c79dd22423c1262a071f9ebf3786497d38ee384d27619d8bd5f9.c1.j19129474.k1.d1629102039268.h1b.i1.l1.n1.o1.p1.q1.s1.t1.x1.f1.u1.v1.w1&userIntent=&selectedRoomType=233465452&selectedRatePlan=388956690&searchId=161926db-06d6-4767-8d35-2209eb9a79c1&propertyName=Hotel%20Carretas%20by%20Rotamundos','https://images.trvl-media.com/lodging/60000000/59360000/59358600/59358600/eacafe0f.jpg?impolicy=resizecrop&rw=455&ra=fit','Sustentable','Libre de humo',3),
('Río Hotel y Glamping','Río HOTEL y glamping te ofrece una variedad de servicios, como jardín y muchos más. Podrás conectarte al wifi gratis en las habitaciones.','https://www.expedia.mx/Rio-HOTEL-Y-Glamping.h101512362.Informacion-Hotel?chkin=2024-08-18&chkout=2024-08-19&x_pwa=1&rfrr=HSR&pwa_ts=1722824249432&referrerUrl=aHR0cHM6Ly93d3cuZXhwZWRpYS5teC9Ib3RlbC1TZWFyY2g%3D&useRewards=false&rm1=a2&regionId=623288425094787072&destination=Franciscan%20Missions%20in%20the%20Sierra%20Gorda%20of%20Quer%C3%A9taro%2C%20Quer%C3%A9taro%2C%20Mexico&destType=MARKET&latLong=21.282654%2C-99.487281&sort=RECOMMENDED&top_dp=1254&top_cur=MXN&gclid=Cj0KCQjwzby1BhCQARIsAJ_0t5NmjSTtGYB4l4Pbu24j9tDi-VmLd6LAI4KNoXuzvQMVJKF4xfzDfNoaAjyzEALw_wcB&semcid=MX.UB.GOOGLE.DT-c-ES.HOTEL&semdtl=a112476355564.b1117227760863.g1kwd-6798948788.e1c.m1Cj0KCQjwzby1BhCQARIsAJ_0t5NmjSTtGYB4l4Pbu24j9tDi-VmLd6LAI4KNoXuzvQMVJKF4xfzDfNoaAjyzEALw_wcB.r1e0295d161cd4c79dd22423c1262a071f9ebf3786497d38ee384d27619d8bd5f9.c1.j19129474.k1.d1629102039268.h1b.i1.l1.n1.o1.p1.q1.s1.t1.x1.f1.u1.v1.w1&userIntent=&selectedRoomType=324050941&selectedRatePlan=393487177&searchId=161926db-06d6-4767-8d35-2209eb9a79c1&propertyName=R%C3%ADo%20HOTEL%20y%20glamping','https://images.trvl-media.com/lodging/102000000/101520000/101512400/101512362/e4fcec00.jpg?impolicy=resizecrop&rw=455&ra=fit','Sustentable','Libre de humo',3),
('Cabañas Terrazul','Cabañas Terrazul se ubica en un desarrollo turístico de Puerto del Rodezno en el Municipio de Pinal de Amoles, región serrana del Estado de Querétaro, apropiado para quienes les agrada disfrutar plenamente del contacto con la naturaleza.','https://www.cabanasterrazul.com/','https://static.wixstatic.com/media/5330a1_1be41e82de124cf69fa2ab6db3241822~mv2.jpg/v1/fill/w_390,h_292,al_c,q_80,usm_0.66_1.00_0.01/5330a1_1be41e82de124cf69fa2ab6db3241822~mv2.jpg&quot','Sustentable','Libre de humo',4),
('Puerto del Zopilote','En Puerto del Zopilote, vivirás una estancia inigualable, donde podrás relajarte y disfrutar de vistas espectaculares en un entorno natural incomparable.','https://www.puertodelzopilote.travel/','https://dynamic-media-cdn.tripadvisor.com/media/photo-o/28/b9/6b/4e/vista-aerea-de-la-cabana.jpg?w=300&h=-1&s=1','Sustentable','Libre de humo',4),
('La Casa De Los Cuatro Vientos','Ubicados en lo alto de la montaña, sobre bosques y arroyos, te ofrecemos dos alojamientos únicos: Casa de Piedra y Cabaña Palafito, ambas con todos los servicios y la seguridad que necesitas para entrar en contacto con la naturaleza.','https://www.casa4vientos.com/','https://static.wixstatic.com/media/d0d5dd_f4474de6118949bb81be973de8e39991~mv2.png/v1/fill/w_393,h_262,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/DSC00938_2%20reducida.png','Sustentable','Libre de humo',4);

-- Inserciones de opiniones
INSERT INTO Opiniones (id_usuario, id_destino, calificacion, comentario, fecha_opinion) VALUES
(1, 1, 5, '¡Una experiencia increíble! Las vistas desde la cima de la Peña de Bernal son impresionantes.', '2024-08-10'),
(2, 2, 4, 'Las termas son perfectas para relajarse. Solo un poco más de señalización en el sendero de acceso.', '2024-08-11'),
(3, 3, 5, 'La biodiversidad en la Sierra Gorda es impresionante. Los guías son muy conocedores.', '2024-08-12'),
(4, 4, 3, 'La cascada es hermosa, pero el camino hasta allí es bastante difícil.', '2024-08-13');
