
DROP TABLE IF EXISTS citas;
DROP TABLE IF EXISTS agenda;
DROP TABLE IF EXISTS doctor_especialidad;
DROP TABLE IF EXISTS especialidades;
DROP TABLE IF EXISTS clinicas;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS roles;

-- Crear tablas
CREATE TABLE roles (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre TEXT NOT NULL
);

CREATE TABLE usuarios (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre TEXT NOT NULL,
    apellido TEXT NOT NULL,
    edad INTEGER NOT NULL,
    email TEXT NOT NULL,
    tipo_documento TEXT NOT NULL,
    documento TEXT NOT NULL UNIQUE,
    telefono TEXT,
    celular TEXT,
    direccion TEXT NOT NULL,
    rol_id INTEGER NOT NULL,
    password_hash TEXT NOT NULL,
    token_auth TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (rol_id) REFERENCES roles(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE clinicas (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre TEXT NOT NULL,
    direccion TEXT NOT NULL,
    telefono TEXT NOT NULL,
    email TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE especialidades (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    nombre TEXT NOT NULL,
    descripcion TEXT,
    created_at TEXT DEFAULT (datetime('now'))
);

CREATE TABLE doctor_especialidad (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    created_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (medico_id) REFERENCES usuarios(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE agenda (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    fecha TEXT NOT NULL,
    hora TEXT NOT NULL,
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
    clinica_id INTEGER NOT NULL,
    disponible INTEGER DEFAULT 1,
    estado TEXT DEFAULT 'activo',
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    created_by INTEGER NOT NULL,
    FOREIGN KEY (created_by) REFERENCES usuarios(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (clinica_id) REFERENCES clinicas(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (especialidad_id) REFERENCES especialidades(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (medico_id) REFERENCES usuarios(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE citas (
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    agenda_id INTEGER NOT NULL,
    paciente_id INTEGER NOT NULL,
    fecha_reserva TEXT DEFAULT (datetime('now')),
    estado TEXT NOT NULL,
    motivo TEXT,
    notas_medicas TEXT,
    created_at TEXT DEFAULT (datetime('now')),
    updated_at TEXT DEFAULT (datetime('now')),
    FOREIGN KEY (paciente_id) REFERENCES usuarios(id) ON UPDATE NO ACTION ON DELETE NO ACTION,
    FOREIGN KEY (agenda_id) REFERENCES agenda(id) ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Crear índices
CREATE INDEX idx_usuarios_email ON usuarios(email);
CREATE INDEX idx_agenda_fecha_hora ON agenda(fecha, hora);
CREATE INDEX idx_agenda_medico ON agenda(medico_id);
CREATE INDEX idx_citas_agenda ON citas(agenda_id);

-- Insertar datos de prueba
-- Roles
INSERT INTO roles (nombre) VALUES
('admin'),
('medico'),
('paciente');

-- Usuarios (contraseña hash simulado)
INSERT INTO usuarios (nombre, apellido, edad, email, tipo_documento, documento, telefono, celular, direccion, rol_id, password_hash) VALUES
-- Admin
('Admin', 'Sistema', 30, 'admin@clinica.com', 'DNI', '12345678', '123456789', '987654321', 'Calle Admin 123', 1, '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPHtaFj1nURhy'),
-- Médicos
('Juan', 'Pérez', 45, 'juan.perez@clinica.com', 'DNI', '23456789', '234567890', '876543210', 'Av. Médicos 456', 2, '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPHtaFj1nURhy'),
('María', 'González', 38, 'maria.gonzalez@clinica.com', 'DNI', '34567890', '345678901', '765432109', 'Calle Salud 789', 2, '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPHtaFj1nURhy'),
-- Pacientes
('Pedro', 'López', 25, 'pedro@mail.com', 'DNI', '45678901', '456789012', '654321098', 'Av. Principal 101', 3, '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPHtaFj1nURhy'),
('Ana', 'Martínez', 33, 'ana@mail.com', 'DNI', '56789012', '567890123', '543210987', 'Jr. Alameda 202', 3, '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPHtaFj1nURhy');

-- Clínicas
INSERT INTO clinicas (nombre, direccion, telefono, email) VALUES
('Clínica Central', 'Av. Principal 1234', '111222333', 'central@clinica.com'),
('Clínica Norte', 'Calle Norte 567', '444555666', 'norte@clinica.com');

-- Especialidades
INSERT INTO especialidades (nombre, descripcion) VALUES
('Medicina General', 'Atención médica general y preventiva'),
('Cardiología', 'Especialidad en sistema cardiovascular'),
('Pediatría', 'Atención médica para niños y adolescentes');

-- Doctor Especialidad
INSERT INTO doctor_especialidad (medico_id, especialidad_id) VALUES
(2, 1), -- Juan Pérez - Medicina General
(2, 2), -- Juan Pérez - Cardiología
(3, 1), -- María González - Medicina General
(3, 3); -- María González - Pediatría

-- Agenda (próximos 5 días)
INSERT INTO agenda (fecha, hora, medico_id, especialidad_id, clinica_id, disponible, estado, created_by)
SELECT
    date(datetime('now', '+' || n || ' days')),
    hora,
    medico_id,
    especialidad_id,
    clinica_id,
    1,
    'activo',
    1
FROM (
    SELECT 0 as n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
) dias,
(
    SELECT '09:00' as hora UNION SELECT '10:00' UNION SELECT '11:00' UNION SELECT '12:00'
) horas,
(
    SELECT 2 as medico_id, 1 as especialidad_id, 1 as clinica_id UNION
    SELECT 3, 3, 2
) medicos;

-- Citas (algunas citas de ejemplo)
INSERT INTO citas (agenda_id, paciente_id, estado, motivo) VALUES
(1, 4, 'confirmada', 'Consulta general'),
(5, 5, 'confirmada', 'Control pediátrico'),
(10, 4, 'pendiente', 'Dolor de cabeza');

-- Marcar algunas citas como no disponibles en agenda
UPDATE agenda SET disponible = 0 WHERE id IN (1, 5, 10);
