import { superValidate, message } from 'sveltekit-superforms';
import { crudSchema } from '$lib/utils/tipos';
import { zod } from 'sveltekit-superforms/adapters';
import { error, fail, redirect } from '@sveltejs/kit';
import { espeAgenda, queryClinicas } from '$lib/server/db/sql/read';

// todo
export const load = async () => {
  const form = await superValidate(zod(crudSchema));
	const especialidades = await espeAgenda();
	const clinicas = await queryClinicas()
	return { form, especialidades, clinicas };
};


export const actions = {
  grabar: async ({ request }:{request:Request}) => {
    const formData = await request.formData();
    const form = await superValidate(formData, zod(crudSchema));
    console.log(form);
    return
  }

}
