import { db } from '$lib/server/db/index';
import { agenda, especialidades, clinicas } from '$lib/server/db/data';

export async function queryAgenda() {
	return await db.select().from(agenda);
}

export async function espeAgenda() {
	const especialidades = await db.query.especialidades.findMany({
		columns: {
			id: true,
		  nombre: true
		},
		with: {
			doctores: {
				columns: {},
				with: {
					doctor: {
						columns: {
						  id: true,
							nombre: true,
							apellido: true
						}
					}
				}
			}
		}
	});
	return especialidades;
}

export async function queryClinicas() {
  type Clinicas = {id:number, nombre:string};
  const clinicasQuery: Clinicas[] = await db.select({ id: clinicas.id, nombre: clinicas.nombre }).from(clinicas);
  return clinicasQuery;
}
