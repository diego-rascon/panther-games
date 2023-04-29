<script lang="ts">
	import { supabase } from '$lib/db';
	import Icon from '@iconify/svelte';
	import cartCrossOutline from '@iconify/icons-solar/cart-cross-outline';
	import { fade } from 'svelte/transition';
	import SectionTitle from '../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/Category.svelte';
	import Product from '../../components/Product.svelte';
	import AddButton from '../../components/AddButton.svelte';
	import AddProduct from '../../components/add-menus/AddProduct.svelte';
	import CartProduct from '../../components/CartProduct.svelte';
	import ConfirmDialog from '../../components/modals/confirmDialog.svelte';
	import Search from '../../components/inputs/Search.svelte';
	import { cartItems } from '$lib/stores';

	export let data;
	let { categories, products, platforms, cart } = data;
	$: ({ categories, products, platforms, cart } = data);

	$: filteredProducts = products;

	$: cartItems.set(cart.map((item: any) => item.producto_id));

	let categoryId: number;
	let platformId: number;
	let name: string;
	let price: number;
	let stock: number;
	let minimumStock: number;
	let used: boolean = false;

	let paymentType: string;
	let payment: number = 0;

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

	const registerSale = async () => {
		const { error } = await supabase.rpc('register_sale', { cliente_id: 1 });
		if (error) console.log(error);
		emptyCart();
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

	const removeFromCart = async (cartId: number, productId: number) => {
		await supabase.from('carrito').delete().eq('carrito_id', cartId);
		cart = cart.filter((item: any) => item.carrito_id != cartId);
		const removedItem = products.find((item: any) => item.producto_id === productId);
		removedItem.on_cart = false;
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

	let cartTotal: number = 0;

	const fetchTotal = async () => {
		const { data: total }: any = await supabase.rpc('get_total').single();
		cartTotal = total.total;
	};

	fetchTotal();

	let search: string;

	const searchProduct = (search: string) => {
		filteredProducts = products.filter((product: any) =>
			product.producto_nombre.toLowerCase().includes(search.toLowerCase())
		);
	};

	let addMenuVisible = false;

	const toggleAddMenu = () => {
		addMenuVisible = !addMenuVisible;
	};
</script>

<div class="mt-14 mb-20 space-y-4 transition-all {cartVisible ? 'mr-64' : ''}">
	<SectionSubtitle text="Categorías" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each categories as category}
			<Category text={category.categoria_nombre} />
		{/each}
	</div>
	<SectionSubtitle text="Inventario" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each filteredProducts as product}
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
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950 transition-all {cartVisible
		? 'mr-64'
		: ''}"
>
	<SectionTitle text="Productos" />
	<Search searchHandler={searchProduct} bind:search />
</div>

<div
	class="fixed inset-y-0 right-0 w-64 h-full flex flex-col p-4 bg-stone-900 border-l border-stone-800 transition ease-in-out {!cartVisible
		? 'translate-x-full'
		: ''}"
>
	<!--Title-->
	<div class="flex justify-between">
		<SectionTitle text="Carrito" />
		<button
			on:click={emptyCart}
			class="p-2 hover:bg-stone-800 active:bg-stone-950 border-pink-700 outline-pink rounded-full transition-all"
		>
			<Icon icon={cartCrossOutline} height={24} />
		</button>
	</div>
	<!--Items-->
	<div
		class="my-4 grid grid-cols-1 gap-4 overflow-y-auto scrollbar-thin scrollbar-thumb-stone-700 scrollbar-thumb-rounded-full transition-all"
	>
		{#each cart as product}
			<div transition:fade={{ duration: 150 }}>
				<CartProduct
					removeHandler={removeFromCart}
					quantityHandler={updateQuantity}
					cartId={product.carrito_id}
					productId={product.producto_id}
					name={product.producto_nombre}
					price={product.producto_precio}
					stock={product.producto_stock}
					quantity={product.producto_cantidad}
				/>
			</div>
		{/each}
	</div>
	<!--Buttons-->
	<div class="mt-auto space-y-4">
		<div class="space-y-2">
			<div class="flex justify-between items-center">
				<p class="text-lg font-bold select-none">Método:</p>
				<select
					bind:value={paymentType}
					class="w-24 p-2 bg-stone-800 outline-pink rounded-xl select-none"
				>
					<option value="Efectivo">Efectivo</option>
					<option value="Tarjeta">Tarjeta</option>
				</select>
			</div>
			{#if paymentType === 'Efectivo'}
				<div class="flex pl-4 justify-between items-center select-none">
					<p>Pago:</p>
					<input
						bind:value={payment}
						type="number"
						min="0"
						class="w-24 p-2 bg-stone-800 rounded-xl outline-pink"
					/>
				</div>
				<div class="flex pl-4 justify-between items-center">
					<p class="select-none">Cambio:</p>
					<p>$ {payment - cartTotal}</p>
				</div>
			{/if}
			<div class="flex justify-between">
				<p class="text-lg font-bold select-none">Total:</p>
				<p>$ {cartTotal}</p>
			</div>
		</div>
		<div class="flex flex-col space-y-2">
			<button
				on:click={registerSale}
				class="py-2 bg-green-700 hover:bg-green-600 active:bg-green-800 outline-none focus:outline-green-700 font-bold rounded-xl transition-all select-none"
			>
				Realizar venta
			</button>
			<label class="flex px-4 justify-between text-sm select-none">
				Generar comprobante
				<input
					type="checkbox"
					required
					bind:value={used}
					class="bg-stone-900 p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				/>
			</label>
		</div>
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
