import { supabase } from '$lib/db';

export const load = async () => {
	const fetchClients = async () => {
		const { data } = await supabase
			.rpc('get_clients')
			.neq('cliente_id', 1)
			.order('cliente_id', { ascending: false });
		return data ?? [];
	};

	return { clients: fetchClients() };
};
