import { supabase } from '$lib/supabaseClient';

export async function load() {
	const { data: categories } = await supabase.from('categorias').select();
	const { data: products } = await supabase.from('productos').select();

	return {
		categories: categories ?? [],
		products: products ?? []
	};
}
