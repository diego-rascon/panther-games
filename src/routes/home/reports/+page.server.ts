import { supabase } from '$lib/db';

export const load = async () => {
	const fetchGames = async () => {
		const { data } = await supabase.rpc('generalreportgamescal');
		return data ?? [];
	};
	const fetchConsolas = async () => {
		const { data } = await supabase.rpc('generalreportconsolas');
		return data ?? [];
	};
	const fetchVentas = async () => {
		const { data } = await supabase.rpc('generalreportventas');
		return data ?? [];
	};
	return {
		games: fetchGames(),
		consolas: fetchConsolas(),
		ventas: fetchVentas()
	};
};
