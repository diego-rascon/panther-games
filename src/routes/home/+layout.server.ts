import { supabase } from '$lib/supabaseClient';

export const load = () => {
	const fetchCategories = async () => {
		const { data } = await supabase.from('categoria').select();
		return data ?? [];
	};

	const fetchProducts = async () => {
		const { data } = await supabase.from('producto').select();
		return data ?? [];
	};

	const fetchPlatforms = async () => {
		const { data } = await supabase.from('plataforma').select();
		return data ?? [];
	};

	const fetchProductPlatforms = async () => {
		const { data } = await supabase.from('producto_plataforma').select();
		return data ?? [];
	};

	return {
		categories: fetchCategories(),
		products: fetchProducts(),
		platforms: fetchPlatforms(),
		productsPlatforms: fetchProductPlatforms()
	};
};
