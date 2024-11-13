-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations

CREATE TABLE `roles` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`nombre` text NOT NULL
);
--> statement-breakpoint
CREATE TABLE `usuarios` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`nombre` text NOT NULL,
	`apellido` text NOT NULL,
	`edad` integer NOT NULL,
	`email` text NOT NULL,
	`tipo_documento` text NOT NULL,
	`documento` text NOT NULL,
	`telefono` text,
	`celular` text,
	`direccion` text NOT NULL,
	`rol_id` integer NOT NULL,
	`created_at` text DEFAULT (datetime('now')),
	`updated_at` text DEFAULT (datetime('now')),
	FOREIGN KEY (`rol_id`) REFERENCES `roles`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_usuarios_email` ON `usuarios` (`email`);--> statement-breakpoint
CREATE TABLE `clinicas` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`nombre` text NOT NULL,
	`direccion` text NOT NULL,
	`telefono` text NOT NULL,
	`email` text,
	`created_at` text DEFAULT (datetime('now')),
	`updated_at` text DEFAULT (datetime('now'))
);
--> statement-breakpoint
CREATE TABLE `especialidades` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`nombre` text NOT NULL,
	`descripcion` text,
	`created_at` text DEFAULT (datetime('now'))
);
--> statement-breakpoint
CREATE TABLE `doctor_especialidad` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`medico_id` integer NOT NULL,
	`especialidad_id` integer NOT NULL,
	`created_at` text DEFAULT (datetime('now')),
	FOREIGN KEY (`medico_id`) REFERENCES `usuarios`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE TABLE `agenda` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`fecha` text NOT NULL,
	`hora` text NOT NULL,
	`medico_id` integer NOT NULL,
	`especialidad_id` integer NOT NULL,
	`clinica_id` integer NOT NULL,
	`disponible` integer DEFAULT 1,
	`estado` text DEFAULT 'activo',
	`created_at` text DEFAULT (datetime('now')),
	`updated_at` text DEFAULT (datetime('now')),
	`created_by` integer NOT NULL,
	FOREIGN KEY (`medico_id`) REFERENCES `usuarios`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`especialidad_id`) REFERENCES `especialidades`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`clinica_id`) REFERENCES `clinicas`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`created_by`) REFERENCES `usuarios`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_agenda_medico` ON `agenda` (`medico_id`);--> statement-breakpoint
CREATE INDEX `idx_agenda_fecha_hora` ON `agenda` (`fecha`,`hora`);--> statement-breakpoint
CREATE TABLE `citas` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`agenda_id` integer NOT NULL,
	`paciente_id` integer NOT NULL,
	`fecha_reserva` text DEFAULT (datetime('now')),
	`estado` text NOT NULL,
	`motivo` text,
	`notas_medicas` text,
	`created_at` text DEFAULT (datetime('now')),
	`updated_at` text DEFAULT (datetime('now')),
	FOREIGN KEY (`agenda_id`) REFERENCES `agenda`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`paciente_id`) REFERENCES `usuarios`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_citas_agenda` ON `citas` (`agenda_id`);--> statement-breakpoint
CREATE TABLE `usuarios_auth` (
	`id` text PRIMARY KEY,
	`email_user` text NOT NULL,
	`password_hash` text NOT NULL,
	`token_auth` text,
	`created_at` text DEFAULT (datetime('now')),
	`updated_at` text DEFAULT (datetime('now')),
	FOREIGN KEY (`email_user`) REFERENCES `usuarios`(`email`) ON UPDATE no action ON DELETE no action
);
