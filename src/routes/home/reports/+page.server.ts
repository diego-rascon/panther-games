import { supabase } from '$lib/db';

export const load = async () => {
	const { data } = await supabase.rpc('generalreportgames');
	return { games: data ?? [],};
};
