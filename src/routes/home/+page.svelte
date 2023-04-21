<script lang="ts">
	import { supabase } from '$lib/db';
	import { fade } from 'svelte/transition';
	import SectionTitle from '../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/Category.svelte';
	import Product from '../../components/Product.svelte';
	import AddButton from '../../components/AddButton.svelte';
	import AddProduct from '../../components/add-menus/AddProduct.svelte';
	import CartProduct from '../../components/CartProduct.svelte';
	import ConfirmDialog from '../../components/modals/confirmDialog.svelte';

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

	const editProduct = (productId: number) => {
		console.log('Editar producto');
	};

	const changeStock = (productId: number) => {
		console.log('Cambiar stock');
	};

	const deleteProduct = async () => {
		const { error } = await supabase
			.from('producto')
			.update({ producto_activo: false })
			.eq('producto_id', productToDeleteID)
			.select()
			.single();
		if (error) console.log(error.message);
		products = products.filter((product: any) => product.producto_id != productToDeleteID);
		toggleConfirmation();
	};

	const confirmDelete = (productId: number) => {
		productToDeleteID = productId;
		toggleConfirmation();
	};

	let confirmationVisible = false;
	let productToDeleteID: number;

	const toggleConfirmation = () => {
		confirmationVisible = !confirmationVisible;
	};

	const registerProduct = async () => {
		await supabase.rpc('register_sale');
	};

	const addProductPlatform = async (productId: number) => {
		await supabase
			.from('producto_plataforma')
			.insert({ producto_id: productId, plataforma_id: platformId });
	};

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
			addProductPlatform(product.producto_id);
			products = [product, ...products];
		}
		toggleAddMenu();
	};

	$: cartVisible = cart.length > 0;

	const addToCart = async (productId: number) => {
		await supabase.from('carrito').insert({ producto_id: productId, producto_cantidad: 1 });
		const { data: cartItem } = await supabase
			.rpc('products_cart')
			.eq('producto_id', productId)
			.single();
		cart = [cartItem ?? [], ...cart];

		fetchTotal();
	};

	const removeFromCart = async (cartId: number) => {
		await supabase.from('carrito').delete().eq('carrito_id', cartId);
		cart = cart.filter((item: any) => item.carrito_id != cartId);
		fetchTotal();
	};

	const emptyCart = async () => {
		await supabase.from('carrito').delete().neq('carrito_id', 0);
		cart = [];
		fetchTotal();
	};

	const updateQuantity = async (cartId: number, quantity: number) => {
		await supabase
			.from('carrito')
			.update({ producto_cantidad: quantity })
			.eq('carrito_id', cartId)
			.select()
			.single();

		const updatedItem = cart.find((item: any) => item.carrito_id === cartId);
		updatedItem.producto_cantidad = quantity;
		fetchTotal();
	};

	let cartTotal: number;

	const fetchTotal = async () => {
		const { data: total }: any = await supabase.rpc('get_total').single();
		cartTotal = total.producto_precio;
	};

	fetchTotal();

	let addMenuVisible = false;

	const toggleAddMenu = () => {
		console.log('aaa');

		addMenuVisible = !addMenuVisible;
	};
</script>

<div class="mb-20 space-y-4 transition-all {cartVisible ? 'mr-64' : ''}">
	<SectionTitle text="Productos" />
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
				{addToCart}
				{editProduct}
				{changeStock}
				deleteProduct={confirmDelete}
				isGame={product.categoria_id === 1}
				id={product.producto_id}
				name={product.producto_nombre}
				stock={product.producto_stock}
				price={product.producto_precio}
				platform={product.plataforma_nombre}
			/>
		{/each}
	</div>
</div>

<div
	class="fixed inset-y-0 right-0 w-64 p-4 bg-stone-900 border-l border-stone-800 transition ease-in-out {!cartVisible
		? 'translate-x-full'
		: ''}"
>
	<div class="flex flex-col space-y-4">
		<SectionSubtitle text="Carrito" />
		<button
			on:click={emptyCart}
			class="py-4 border-2 hover:bg-stone-800 active:bg-stone-950 border-pink-700 outline-none focus:outline-pink-700 rounded-xl transition-all"
		>
			Vaciar carrito
		</button>
		<div class="grid grid-cols-1 gap-4 transition-all overflow-auto">
			{#each cart as product}
				<div transition:fade={{ duration: 150 }}>
					<CartProduct
						quantityHandler={updateQuantity}
						removeHandler={removeFromCart}
						id={product.carrito_id}
						name={product.producto_nombre}
						price={product.producto_precio}
						stock={product.producto_stock}
						quantity={product.producto_cantidad}
					/>
				</div>
			{/each}
		</div>
		<div class="flex text-xl px-4 justify-between">
			<p class="font-bold">Total:</p>
			<p>$ {cartTotal}</p>
		</div>
		<button
			on:click={registerProduct}
			class="py-4 bg-green-700 hover:bg-green-600 active:bg-green-800 outline-none focus:outline-green-700 font-bold rounded-xl transition-all"
		>
			Realizar venta
		</button>
	</div>
</div>
<div class="fixed bottom-0 transition-all {cartVisible ? 'right-64' : 'right-0'}">
	<AddButton on:click={toggleAddMenu} />
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
{#if confirmationVisible}
	<ConfirmDialog
		cancelHandler={toggleConfirmation}
		confirmHandler={deleteProduct}
		title="Eliminar Producto"
		text="¿Está seguro de que desea eliminar el producto?"
	/>
{/if}
