import { supabase } from '$lib/db';

export const load = async () => {
	const fetchUsers = async () => {
		const { data } = await supabase
			.from('usuario')
			.select()
			.order('usuario_id', { ascending: false });
		return data ?? [];
	};
	return { users: fetchUsers() };
};
