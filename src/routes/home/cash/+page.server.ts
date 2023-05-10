import { supabase } from '$lib/db';

export const load = async () => {
	const fetchCaja = async () => {
		const { data } = await supabase.from('caja').select().order('caja_id', { ascending: false });
		return data ?? [];
	};
	return { caja: fetchCaja() };
};
