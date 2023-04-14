import db from '$lib/db';

export async function load() {
	return { clients: db.clients.all };
}
