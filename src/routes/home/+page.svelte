<script lang="ts">
	import { supabase } from '$lib/db';
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/Category.svelte';
	import Product from '../../components/Product.svelte';
	import ShoppingCart from '../../components/ShoppingCart.svelte';
	import AddButton from '../../components/AddButton.svelte';
	import AddProduct from '../../components/add-menus/AddProduct.svelte';

	export let data;
	let { categories, products, platforms, cart } = data;
	$: ({ categories, products, platforms, cart } = data);

	let categoryId: number;
	let platformId: number;
	let name: string;
	let price: number;
	let stock: number;
	let minimumStock: number;
	let used: boolean = false;

	const addProductPlatform = async (productId: number) => {
		const { error } = await supabase
			.from('producto_plataforma')
			.insert({ producto_id: productId, plataforma_id: platformId });
		if (error) console.log(error.message);
	};

	const addProduct = async () => {
		const { data: product, error } = await supabase
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
		if (error) {
			console.log(error.message);
		} else if (product) {
			addProductPlatform(product.producto_id);
			products = [product, ...products];
		}
		toggleAddMenu();
	};

	let cartVisible = false;

	const toggleCart = () => {
		if (cart.length > 0) {
			cartVisible = true;
		}
	};

	toggleCart();

	const addToCart = async (productId: number, productQuantity: number) => {
		const { data } = await supabase
			.from('carrito')
			.insert({ producto_id: productId, producto_cantidad: productQuantity })
			.select()
			.single();
		cart = [data ?? [], ...cart];
		toggleCart();
	};

	let addMenuVisible = false;

	const toggleAddMenu = () => {
		addMenuVisible = !addMenuVisible;
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
				clickHandler={addToCart}
				id={product.producto_id}
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
<div class="fixed bottom-0 {cartVisible ? 'right-64' : 'right-0'}">
	<AddButton clickHandler={toggleAddMenu} />
</div>
{#if addMenuVisible}
	<AddProduct
		cancelHandler={toggleAddMenu}
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
