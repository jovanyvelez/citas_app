import { sqliteTable, text, integer } from 'drizzle-orm/sqlite-core';

export const users = sqliteTable('users', {
	    id: text().primaryKey().$defaultFn(()=>crypto.randomUUID()),
			email: text().unique().notNull(),
			passwordHash: text().notNull(),
			role: text().notNull()
});

export const patients = sqliteTable('patients', {
  id: text().primaryKey().$defaultFn(() => crypto.randomUUID()),
  documentIdType: text({ enum: ["CC", "TI"] }).notNull(),
  documentId: text().notNull(),
  name: text().notNull(),
  lastName: text().notNull(),
  birthDate: integer(),
  phone: text().notNull(),
  celphone: text().notNull(),
  address: text().notNull(),
  createdAt: integer().$defaultFn(() => new Date().getTime()),
  updatedAt: integer()
});
