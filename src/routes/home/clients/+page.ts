import { supabase } from '$lib/db';

export const load = async () => {
	const fetchClients = async () => {
		const { data } = await supabase.rpc('get_clients').order('cliente_id', { ascending: false });
		return data ?? [];
	};
	
	return { clients: fetchClients() };
};
