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
			.from('producto')
			.select()
			.order('producto_id', { ascending: true });
		return data ?? [];
	};
	return {
        categories: fetchCategories(),
        products: fetchProducts()
    };
}

/*
const fetchCategories = async () => {
		let { data, error } = await supabase
			.from('categoria')
			.select('*')
			.order('categoria_id', { ascending: true });
		if (error) {
			console.log('Error', error);
		} else {
			categories = data;
		}
		loadingCategories = false;
	};

	const fetchProducts = async () => {
		let { data, error } = await supabase
			.from('producto')
			.select('*')
			.order('producto_id', { ascending: true });
		if (error) {
			console.log('Error', error);
		} else {
			products = data;
		}
		loadingProducts = false;
	};

*/