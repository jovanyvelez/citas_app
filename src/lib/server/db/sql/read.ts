import {db} from '$lib/server/db/index'
import { agenda } from '$lib/server/db/data';

export async function queryAgenda() {
  return await db.select().from(agenda);
}
