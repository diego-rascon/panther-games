import { supabase } from '$lib/db';

export const load = async () => {
	
	const fetchVentas = async () => {
		const { data } = await supabase.rpc('generalreportventas');
		return data ?? [];
	};
	return {
		ventas: fetchVentas()
	}; 
};
