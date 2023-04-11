import { supabase } from '$lib/supabaseClient';

export async function load() {
	const { data } = await supabase.from('categories').select();

	return {
		categories: data ?? []
	};
}
