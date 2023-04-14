import db from '$lib/db';

export async function load() {
	console.log('hehe');
	return { clients: db.clients.all };
}
