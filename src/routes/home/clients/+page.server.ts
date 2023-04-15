import { supabase } from '$lib/db';

export const load = async () => {
	const fetchClients = async () => {
		const { data } = await supabase
			.from('cliente')
			.select()
			.order('cliente_id', { ascending: true });
		return data ?? [];
	};
	return { clients: fetchClients() };
}