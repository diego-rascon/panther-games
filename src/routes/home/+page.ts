import { supabase } from '$lib/db';

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
			.order('cliente_id', { ascending: false });
		return data ?? [];
	};

	return {
		categories: fetchCategories(),
		products: fetchProducts(),
		platforms: fetchPlatforms(),
		cart: fetchCart(),
		clients: fetchClients()
	};
};