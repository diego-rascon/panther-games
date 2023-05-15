import { supabase } from '$lib/db';

export const load = async () => {
	
	const fetchVentas = async () => {
		const { data } = await supabase.rpc('');
		return data ?? [];
	};
	return {
		ventas: fetchVentas()
	}; 
};
