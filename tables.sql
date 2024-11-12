
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL
);

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    edad INTEGER NOT NULL,
    email TEXT UNIQUE NOT NULL,
    tipo_documento TEXT NOT NULL,
    documento TEXT UNIQUE NOT NULL,
    telefono TEXT NOT NULL,
    celular TEXT NOT NULL,
    direccion TEXT NOT NULL,
    rol_id TEXT NOT NULL
    token TEXT UNIQUE NOT NULL,
    password TEXT,
    FOREIGN KEY (rol_id) REFERENCES roles(id)
);

CREATE TABLE especialidades (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL
);

CREATE TABLE clinicas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT UNIQUE NOT NULL,
    direccion TEXT NOT NULL,
    telefono TEXT NOT NULL
);

CREATE TABLE citas (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    paciente_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    clinica_id INTEGER NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    estado TEXT NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES patients(id),
    FOREIGN KEY (medico_id) REFERENCES doctors(id),
    FOREIGN KEY (especialidad_id) REFERENCES specialties(id),
    FOREIGN KEY (clinica_id) REFERENCES clinics(id)
);

CREATE TABLE doctor_especilidad (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    FOREIGN KEY (medico_id) REFERENCES doctors(id),
    FOREIGN KEY (especialidad_id) REFERENCES specialties(id)
);
