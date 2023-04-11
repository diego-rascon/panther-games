import { supabase } from '$lib/supabaseClient';

export async function load() {
	const { data: categories } = await supabase.from('categorias').select();
	const { data: products } = await supabase.from('productos').select();
	const { data: platforms } = await supabase.from('plataformas').select();
	const { data: productsPlatforms } = await supabase.from('productos_plataformas').select();

	return {
		categories: categories ?? [],
		products: products ?? [],
		platforms: platforms ?? [],
		productsPlatforms: productsPlatforms ?? []
	};
}
