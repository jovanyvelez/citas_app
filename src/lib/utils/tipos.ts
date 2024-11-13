import { z } from "zod";

export const userSchema = z.object({
  fecha: z.string().length(16),
  especialidad: z.string().max(2),
  medico: z.string().max(2),
  clinica: z.string().max(2),
  disponible: z.string().max(2),
  activo: z.enum(["activo", "inactivo"]),
});

export const crudSchema = userSchema.extend({
  id: userSchema.shape.disponible.optional()
});
