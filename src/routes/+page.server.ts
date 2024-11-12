import { queryAgenda } from '$lib/server/db/sql/read';

export const load = async () => {
	const agenda = await queryAgenda();
	console.log(agenda);
	return { agenda };
};
