import { supabase } from '$lib/db';

export async function load() {
	const fetchClients = async () => {
		const { data } = await supabase
			.from('cliente')
			.select()
			.order('cliente_id', { ascending: true });
		return data ?? [];
	};
	return { clients: fetchClients() };
}
