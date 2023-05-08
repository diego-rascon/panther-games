import { supabase } from '$lib/db';

export const load = async () => {
	const fetchMembers = async () => {
		const { data } = await supabase
			.rpc('get_clients_members')
			.order('miembro_id', { ascending: false });
		return data ?? [];
	};

	return { members: fetchMembers() };
};
