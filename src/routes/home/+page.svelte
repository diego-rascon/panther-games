<script lang="ts">
	import { supabase } from '$lib/db';
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/Category.svelte';
	import Product from '../../components/Product.svelte';
	import ShoppingCart from '../../components/ShoppingCart.svelte';
	import AddButton from '../../components/AddButton.svelte';

	export let data;
	let { categories, products } = data;
	$: ({ categories, products } = data);

	let cartVisible = false;
	let addMenuVisible = false;

	const openCart = () => {
		cartVisible = true;
	}

	const openAddMenu = () => {
		addMenuVisible = true;
	}
</script>

<div class="mb-20 transition-all {cartVisible ? 'mr-64' : ''}">
	<SectionSubtitle text="Categorías" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each categories as category}
			<Category text={category.categoria_nombre} />
		{/each}
	</div>
	<SectionSubtitle text="Inventario" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each products as product}
			<Product text={product.producto_nombre} category={product.categoria_id} />
		{/each}
	</div>
	<ShoppingCart {cartVisible} />
	<AddButton {cartVisible} clickHandler={openCart} />
</div>
