<script lang="ts">
	import { supabase } from '$lib/db';
	import { onMount } from 'svelte';
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/Category.svelte';
	import Product from '../../components/Product.svelte';
	import ShoppingCart from '../../components/ShoppingCart.svelte';
	import AddButton from '../../components/AddButton.svelte';
	import LoadingScreen from '../../components/utils/LoadingScreen.svelte';

	let cartVisible = false;
	let addMenuVisible = false;

	let errorText = '';

	let categories: any = [];
	let loadingCategories = true;
	let products: any = [];
	let loadingProducts = true;

	onMount(() => {
		fetchCategories();
		fetchProducts();
	});

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

	const addCategory = async () => {
		let categoryName = 'nueva categoria'.trim();
		if (categories.length) {
			let { data: category, error } = await supabase
				.from('categoria')
				.insert([{ categoria_nombre: categoryName }])
				.select()
				.single();

			if (error) {
				errorText = error.message;
			} else {
				categories = [...categories, category];
			}
		}
	};

	function setCartVisible() {
		cartVisible = !cartVisible;
	}

	function setAddMenuVisible() {
		addMenuVisible = true;
	}
</script>

<div class="mb-20 transition-all {cartVisible ? 'mr-64' : ''}">
	<SectionSubtitle text="Categorías" />
	{#if loadingCategories}
		<LoadingScreen text="categorías" />
	{:else}
		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
			{#each categories as category}
				<Category text={category.categoria_nombre} />
			{/each}
		</div>
	{/if}
	<SectionSubtitle text="Inventario" />
	{#if loadingProducts}
		<LoadingScreen text="inventario" />
	{:else}
		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
			{#each products as product}
				<Product text={product.producto_nombre} category={product.categoria_id} />
			{/each}
		</div>
	{/if}
	<ShoppingCart {cartVisible} />
	<AddButton {cartVisible} clickHandler={addCategory} />
</div>
