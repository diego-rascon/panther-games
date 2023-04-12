import { supabase } from '$lib/supabaseClient';

export const load = async () => {
	const fetchUsers = async () => {
		const { data } = await supabase.from('usuarios').select();
		return data ?? [];
	};

	return {
		streamed: {
			users: fetchUsers()
		}
	};
};
