import { supabase } from '$lib/db';

export const load = async () => {
	const fetchSales = async () => {
		const { data } = await supabase.from('venta').select().order('venta_id', { ascending: false });
		return data ?? [];
	};
	return { sales: fetchSales() };
};
