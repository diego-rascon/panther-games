import { supabase } from '$lib/db';

export const load = async () => {
	const fetchMembers = async () => {
		const { data } = await supabase
			.rpc('get_clients_members')
			.order('miembro_id', { ascending: false });
		return data ?? [];
	};

	const fetchClients = async () => {
		const { data } = await supabase
			.rpc('get_clients')
			.eq('cliente_miembro', false)
			.order('cliente_nombre', { ascending: true });
		return data ?? [];
	};

	return {
		members: fetchMembers(),
		clients: fetchClients()
	};
};
