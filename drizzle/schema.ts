import { sqliteTable, AnySQLiteColumn, integer, text, index, foreignKey } from "drizzle-orm/sqlite-core"
  import { sql } from "drizzle-orm"

export const roles = sqliteTable("roles", {
	id: integer().primaryKey({ autoIncrement: true }).notNull(),
	nombre: text().notNull(),
});

export const usuarios = sqliteTable("usuarios", {
	id: integer().primaryKey({ autoIncrement: true }).notNull(),
	nombre: text().notNull(),
	apellido: text().notNull(),
	edad: integer().notNull(),
	email: text().notNull(),
	tipoDocumento: text("tipo_documento").notNull(),
	documento: text().notNull(),
	telefono: text(),
	celular: text(),
	direccion: text().notNull(),
	rolId: integer("rol_id").notNull().references(() => roles.id),
	createdAt: text("created_at").default("sql`(datetime('now'))`"),
	updatedAt: text("updated_at").default("sql`(datetime('now'))`"),
},
(table) => {
	return {
		idxUsuariosEmail: index("idx_usuarios_email").on(table.email),
	}
});

export const clinicas = sqliteTable("clinicas", {
	id: integer().primaryKey({ autoIncrement: true }).notNull(),
	nombre: text().notNull(),
	direccion: text().notNull(),
	telefono: text().notNull(),
	email: text(),
	createdAt: text("created_at").default("sql`(datetime('now'))`"),
	updatedAt: text("updated_at").default("sql`(datetime('now'))`"),
});

export const especialidades = sqliteTable("especialidades", {
	id: integer().primaryKey({ autoIncrement: true }).notNull(),
	nombre: text().notNull(),
	descripcion: text(),
	createdAt: text("created_at").default("sql`(datetime('now'))`"),
});

export const doctorEspecialidad = sqliteTable("doctor_especialidad", {
	id: integer().primaryKey({ autoIncrement: true }).notNull(),
	medicoId: integer("medico_id").notNull().references(() => usuarios.id),
	especialidadId: integer("especialidad_id").notNull().references(() => especialidades.id),
	createdAt: text("created_at").default("sql`(datetime('now'))`"),
});

export const agenda = sqliteTable("agenda", {
	id: integer().primaryKey({ autoIncrement: true }).notNull(),
	fecha: text().notNull(),
	hora: text().notNull(),
	medicoId: integer("medico_id").notNull().references(() => usuarios.id),
	especialidadId: integer("especialidad_id").notNull().references(() => especialidades.id),
	clinicaId: integer("clinica_id").notNull().references(() => clinicas.id),
	disponible: integer().default(1),
	estado: text().default("activo"),
	createdAt: text("created_at").default("sql`(datetime('now'))`"),
	updatedAt: text("updated_at").default("sql`(datetime('now'))`"),
	createdBy: integer("created_by").notNull().references(() => usuarios.id),
},
(table) => {
	return {
		idxAgendaMedico: index("idx_agenda_medico").on(table.medicoId),
		idxAgendaFechaHora: index("idx_agenda_fecha_hora").on(table.fecha, table.hora),
	}
});

export const citas = sqliteTable("citas", {
	id: integer().primaryKey({ autoIncrement: true }).notNull(),
	agendaId: integer("agenda_id").notNull().references(() => agenda.id),
	pacienteId: integer("paciente_id").notNull().references(() => usuarios.id),
	fechaReserva: text("fecha_reserva").default("sql`(datetime('now'))`"),
	estado: text().notNull(),
	motivo: text(),
	notasMedicas: text("notas_medicas"),
	createdAt: text("created_at").default("sql`(datetime('now'))`"),
	updatedAt: text("updated_at").default("sql`(datetime('now'))`"),
},
(table) => {
	return {
		idxCitasAgenda: index("idx_citas_agenda").on(table.agendaId),
	}
});

export const usuariosAuth = sqliteTable("usuarios_auth", {
	id: text().primaryKey(),
	emailUser: text("email_user").notNull().references(() => usuarios.email),
	passwordHash: text("password_hash").notNull(),
	tokenAuth: text("token_auth"),
	createdAt: text("created_at").default("sql`(datetime('now'))`"),
	updatedAt: text("updated_at").default("sql`(datetime('now'))`"),
});

