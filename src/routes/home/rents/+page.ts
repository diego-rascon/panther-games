import { supabase } from '$lib/db';

export const load = async () => {
	const fetchRents = async () => {
		const { data } = await supabase
			.from('renta')
			.select()
			.order('renta_fecha_final', { ascending: false });
		return data ?? [];
	};
	return { rents: fetchRents() };
};
