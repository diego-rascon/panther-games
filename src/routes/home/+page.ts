import { supabase } from '$lib/db';
import dayjs from 'dayjs';

export const load = async () => {
	const fetchCategories = async () => {
		const { data } = await supabase
			.from('categoria')
			.select()
			.order('categoria_id', { ascending: true });
		return data ?? [];
	};

	const fetchProducts = async () => {
		const { data } = await supabase
			.rpc('products_platforms')
			.order('producto_id', { ascending: false });
		return data ?? [];
	};

	const fetchPlatforms = async () => {
		const { data } = await supabase
			.from('plataforma')
			.select()
			.order('plataforma_id', { ascending: true });
		return data ?? [];
	};

	const fetchCart = async () => {
		const { data } = await supabase.rpc('products_cart');
		return data ?? [];
	};

	const fetchClients = async () => {
		const { data } = await supabase
			.from('cliente')
			.select()
			.neq('cliente_id', 1)
			.order('cliente_nombre', { ascending: true });
		return data ?? [];
	};

	const fetchMembers = async () => {
		const currentDate = dayjs(new Date()).format('YYYY-MM-DD');
		const { data } = await supabase
			.rpc('get_clients_members')
			.gte('miembro_fecha_final', currentDate)
			.eq('miembro_activo', true)
			.neq('cliente_id', 1)
			.order('cliente_nombre', { ascending: true });
		return data ?? [];
	};
	return {
		categories: fetchCategories(),
		products: fetchProducts(),
		platforms: fetchPlatforms(),
		cart: fetchCart(),
		clients: fetchClients(),
		members: fetchMembers()
	};
};
