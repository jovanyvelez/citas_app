import { relations } from "drizzle-orm/relations";
import { roles, usuarios, doctorEspecialidad, especialidades, agenda, clinicas, citas, usuariosAuth } from "./schema";

export const usuariosRelations = relations(usuarios, ({one, many}) => ({
	role: one(roles, {
		fields: [usuarios.rolId],
		references: [roles.id]
	}),
	doctorEspecialidads: many(doctorEspecialidad),
	agenda_medicoId: many(agenda, {
		relationName: "agenda_medicoId_usuarios_id"
	}),
	agenda_createdBy: many(agenda, {
		relationName: "agenda_createdBy_usuarios_id"
	}),
	citas: many(citas),
	usuariosAuths: many(usuariosAuth),
}));

export const rolesRelations = relations(roles, ({many}) => ({
	usuarios: many(usuarios),
}));

export const doctorEspecialidadRelations = relations(doctorEspecialidad, ({one}) => ({
	usuario: one(usuarios, {
		fields: [doctorEspecialidad.medicoId],
		references: [usuarios.id]
	}),
	especialidade: one(especialidades, {
		fields: [doctorEspecialidad.especialidadId],
		references: [especialidades.id]
	}),
}));

export const especialidadesRelations = relations(especialidades, ({many}) => ({
	doctorEspecialidads: many(doctorEspecialidad),
	agenda: many(agenda),
}));

export const agendaRelations = relations(agenda, ({one, many}) => ({
	usuario_medicoId: one(usuarios, {
		fields: [agenda.medicoId],
		references: [usuarios.id],
		relationName: "agenda_medicoId_usuarios_id"
	}),
	especialidade: one(especialidades, {
		fields: [agenda.especialidadId],
		references: [especialidades.id]
	}),
	clinica: one(clinicas, {
		fields: [agenda.clinicaId],
		references: [clinicas.id]
	}),
	usuario_createdBy: one(usuarios, {
		fields: [agenda.createdBy],
		references: [usuarios.id],
		relationName: "agenda_createdBy_usuarios_id"
	}),
	citas: many(citas),
}));

export const clinicasRelations = relations(clinicas, ({many}) => ({
	agenda: many(agenda),
}));

export const citasRelations = relations(citas, ({one}) => ({
	agenda: one(agenda, {
		fields: [citas.agendaId],
		references: [agenda.id]
	}),
	usuario: one(usuarios, {
		fields: [citas.pacienteId],
		references: [usuarios.id]
	}),
}));

export const usuariosAuthRelations = relations(usuariosAuth, ({one}) => ({
	usuario: one(usuarios, {
		fields: [usuariosAuth.emailUser],
		references: [usuarios.email]
	}),
}));