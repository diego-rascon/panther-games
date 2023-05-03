<script lang="ts">
	import { supabase } from '$lib/db';
	import { productsStore, cartStore } from '$lib/stores';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import { fade } from 'svelte/transition';
	import Icon from '@iconify/svelte';
	import cartCrossOutline from '@iconify/icons-solar/cart-cross-outline';
	import SectionTitle from '../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/Category.svelte';
	import Product from '../../components/Product.svelte';
	import AddButton from '../../components/AddButton.svelte';
	import AddProduct from '../../components/forms/ProductForm.svelte';
	import CartProduct from '../../components/CartProduct.svelte';
	import Search from '../../components/inputs/Search.svelte';
	import DarkenSreen from '../../components/modals/DarkenSreen.svelte';
	import SaleForm from '../../components/forms/SaleForm.svelte';
	import ConfirmDialog from '../../components/modals/ConfirmDialog.svelte';
	import ChangeStock from '../../components/forms/ChangeStock.svelte';

	export let data;
	$: ({ categories, products, platforms, cart, clients } = data);

	$: filteredProducts = products;

	$: productsStore.set(products);
	$: cartStore.set(cart);

	let categoryId: number;
	let platformId: number;
	let name: string;
	let price: number;
	let stock: number;
	let minimumStock: number;
	let used: boolean = false;

	let addingProduct = false;

	const toggleAddingProduct = () => {
		addingProduct = !addingProduct;
	};

	const addProduct = async () => {
		toggleAddingProduct();
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
			toastStore.trigger(productAdded);
		}
	};

	const addProductPlatform = async (productId: number) => {
		await supabase
			.from('producto_plataforma')
			.insert({ producto_id: productId, plataforma_id: platformId });
	};

	let tempProductId: number;

	const editProduct = (productId: number) => {
		console.log('Editar producto');
	};

	let tempProductStock: number;
	let changingStock = false;

	const toggleChangingStock = () => {
		changingStock = !changingStock;
	};

	const changeStock = async (newStock: number) => {
		toggleChangingStock();
		const { error } = await supabase
			.from('producto')
			.update({ producto_stock: newStock })
			.eq('producto_id', tempProductId);
		if (error) console.log(error.message);
		const changedItem = products.find((item: any) => item.producto_id === tempProductId);
		changedItem.producto_stock = newStock;
		products = products;
		toastStore.trigger(stockChanged);
	};

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteProduct = async () => {
		toggleDeleteConfirmation();
		const { error } = await supabase
			.from('producto')
			.update({ producto_activo: false })
			.eq('producto_id', tempProductId)
			.select()
			.single();
		if (error) console.log(error.message);
		products = products.filter((product: any) => product.producto_id != tempProductId);
		toastStore.trigger(productDeleted);
	};

	let doingSale = false;

	const toggleSale = () => {
		doingSale = !doingSale;
	};

	const registerSale = async () => {
		toggleSale();
		const { error } = await supabase.rpc('register_sale', { cliente_id: 1 });
		if (error) console.log(error);
		else toastStore.trigger(saleAdded);
		emptyCart();
	};

	$: cartVisible = cart.length > 0;

	let cartTotal: number = 0;
	let cartQuantity: number = 0;

	const fetchTotal = async () => {
		const { data: total }: any = await supabase.rpc('get_total').single();
		cartTotal = total.total;
		cartQuantity = total.quantity;
	};

	fetchTotal();

	const addToCart = async (productId: number) => {
		await supabase.from('carrito').insert({ producto_id: productId, producto_cantidad: 1 });
		const { data: cartItem } = await supabase
			.rpc('products_cart')
			.eq('producto_id', productId)
			.single();
		cart = [cartItem, ...cart];
		fetchTotal();
	};

	const removeFromCart = async (cartId: number, productId: number) => {
		console.log('hehehe');
		
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

	let search: string;

	const searchProduct = (search: string) => {
		filteredProducts = products.filter((product: any) =>
			product.producto_nombre.toLowerCase().includes(search.toLowerCase())
		);
	};

	const productAdded: ToastSettings = {
		message: 'Un nuevo producto fue registrado exitosamente.',
		background: 'variant-filled-primary'
	};

	const stockChanged: ToastSettings = {
		message: 'Se actualizó el stock del producto exitosamente.',
		background: 'variant-filled-primary'
	};

	const productDeleted: ToastSettings = {
		message: 'Un producto fue eliminado exitosamente.',
		background: 'variant-filled-primary'
	};

	const saleAdded: ToastSettings = {
		message: 'Una nueva venta fue registrada exitosamente.',
		background: 'variant-filled-primary'
	};
</script>

<div class="mt-[60px] mb-20 space-y-4 transition-all {cartVisible ? 'mr-64' : ''}">
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
				changeStock={(productId, currentStock) => {
					toggleChangingStock();
					tempProductId = productId;
					tempProductStock = currentStock;
				}}
				deleteProduct={(productId) => {
					toggleDeleteConfirmation();
					tempProductId = productId;
				}}
				id={product.producto_id}
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
		<button on:click={emptyCart} class="btn variant-filled-surface p-2 rounded-full">
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
		<div class="flex justify-between text-lg">
			<p class="unstyled font-bold select-none">Total ({cartQuantity})</p>
			<p class="unstyled">$ {cartTotal}</p>
		</div>
		<div class="flex flex-col space-y-4">
			<button class="btn variant-filled-success font-bold" on:click={toggleSale}>
				Realizar venta
			</button>
		</div>
	</div>
</div>
<div class="fixed bottom-0 transition-all {cartVisible ? 'right-64' : 'right-0'}">
	<AddButton on:click={toggleAddingProduct} />
</div>
{#if addingProduct}
	<DarkenSreen>
		<AddProduct
			cancelHandler={toggleAddingProduct}
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
	</DarkenSreen>
{/if}
{#if doingSale}
	<DarkenSreen>
		<SaleForm
			cancelHandler={toggleSale}
			confirmHandler={registerSale}
			{clients}
			{cartTotal}
			{cartQuantity}
		/>
	</DarkenSreen>
{/if}
{#if changingStock}
	<DarkenSreen>
		<ChangeStock
			cancelHandler={toggleChangingStock}
			confirmHandler={changeStock}
			currentStock={tempProductStock}
		/>
	</DarkenSreen>
{/if}
{#if deleteConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleDeleteConfirmation}
			confirmHandler={deleteProduct}
			title="Eliminar Producto"
			text="¿Seguro de que desea eliminar el producto?"
		/>
	</DarkenSreen>
{/if}
