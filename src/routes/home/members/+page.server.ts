import { supabase } from '$lib/db';

export const load = async () => {
	const fetchMembers = async () => {
		const { data } = await supabase.rpc('clients_members');
		return data ?? [];
	};
	return { members: fetchMembers() };
};
