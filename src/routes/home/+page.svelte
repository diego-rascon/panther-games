<script lang="ts">
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/Category.svelte';
	import Product from '../../components/Product.svelte';
	import ShoppingCart from '../../components/ShoppingCart.svelte';
	import AddButton from '../../components/AddButton.svelte';
	import AddProduct from '../../components/add-menus/AddProduct.svelte';
	import { supabase } from '$lib/db';

	export let data;
	let { categories, products, platforms } = data;
	$: ({ categories, products, platforms } = data);

	let categoryId: number;
	let platformId: number;
	let name: string;
	let price: number;
	let stock: number;
	let minimumStock: number;
	let used: boolean = false;

	const addProduct = async () => {
		const { data: product } = await supabase
			.from('producto')
			.insert({
				categoria_id: categoryId,
				producto_nuevo: !used,
				producto_nombre: name,
				producto_precio: price,
				producto_stock: stock,
				producto_minimo: minimumStock
			})
			.select()
			.single();

		if (product) {
			const productId = product.producto_id;
			const { error } = await supabase
				.from('producto_plataforma')
				.insert({ producto_id: productId, plataforma_id: platformId });
			if (error) console.log(error.message);
		}

		products = [product, ...products];
		closeAddMenu();
	};

	let cartVisible = false;

	const openCart = () => {
		cartVisible = true;
	};

	let addMenuVisible = false;

	const openAddMenu = () => {
		addMenuVisible = true;
	};

	const closeAddMenu = () => {
		addMenuVisible = false;
	};
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
			<Product
				name={product.producto_nombre}
				stock={product.producto_stock}
				price={product.producto_precio}
				platform={product.plataforma_nombre}
				isGame={product.categoria_id === 1 ? true : false}
			/>
		{/each}
	</div>
</div>
<ShoppingCart {cartVisible} />
<AddButton {cartVisible} clickHandler={openAddMenu} />
{#if addMenuVisible}
	<AddProduct
		cancelHandler={closeAddMenu}
		confirmHandler={addProduct}
		{categories}
		{platforms}
		bind:categoryId
		bind:platformId
		bind:name
		bind:price
		bind:stock
		bind:minimumStock
		bind:used
	/>
{/if}
