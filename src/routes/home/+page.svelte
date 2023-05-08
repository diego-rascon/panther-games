<script lang="ts">
	import { supabase } from '$lib/db';
	import { productsStore, cartStore } from '$lib/stores';
	import { RadioGroup, RadioItem, type ToastSettings } from '@skeletonlabs/skeleton';
	import { toastStore } from '@skeletonlabs/skeleton';
	import { fade } from 'svelte/transition';
	import Icon from '@iconify/svelte';
	import cartCrossOutline from '@iconify/icons-solar/cart-cross-outline';
	import SectionTitle from '../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/Category.svelte';
	import Product from '../../components/Product.svelte';
	import CartProduct from '../../components/CartProduct.svelte';
	import ProductForm from '../../components/forms/ProductForm.svelte';
	import SaleForm from '../../components/forms/SaleForm.svelte';
	import AddButton from '../../components/AddButton.svelte';
	import Search from '../../components/inputs/Search.svelte';
	import ChangeStock from '../../components/forms/ChangeStock.svelte';
	import ConfirmDialog from '../../components/modals/ConfirmDialog.svelte';
	import DarkenSreen from '../../components/modals/DarkenSreen.svelte';
	import NoResultsMessage from '../../components/utils/NoResultsMessage.svelte';
	import { nfc, nfd } from 'unorm';

	export let data;
	let { categories, products, platforms, cart, clients } = data;
	$: ({ categories, products, platforms, cart, clients } = data);

	$: cartStore.set(cart);
	$: productsStore.set(products);
	$: activeProducts = products.filter((product: any) => product.producto_activo);
	$: deactivatedProducts = products.filter((product: any) => !product.producto_activo);
	$: filteredActiveProducts = activeProducts;
	$: filteredDeactivatedProducts = deactivatedProducts;

	enum Filter {
		None,
		Game = 'Juegos',
		Console = 'Consola',
		Accesory = 'Accesorio',
		Other = 'Otro'
	}

	let currentFilter = Filter.None;

	const filter = () => {
		console.log(currentFilter.toString());
	};

	let categoryId: number;
	let platformId: number;
	let name: string;
	let price: number | undefined;
	let stock: number | undefined;
	let minimumStock: number | undefined;
	let used: boolean = false;

	const clearForm = () => {
		categoryId = 1;
		platformId = 1;
		name = '';
		price = undefined;
		stock = undefined;
		minimumStock = undefined;
		used = false;
	};

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
		clearForm();
	};

	const addProductPlatform = async (productId: number) => {
		await supabase
			.from('producto_plataforma')
			.insert({ producto_id: productId, plataforma_id: platformId });
	};

	let tempProductId: number;
	let editingProduct: boolean;

	const toggleEditingProduct = () => {
		editingProduct = !editingProduct;
	};

	const bindValues = () => {
		const editedProduct = products.find((item: any) => item.producto_id === tempProductId);
		categoryId = editedProduct.categoria_id;
		platformId = editedProduct.plataforma_id;
		name = editedProduct.producto_nombre;
		price = editedProduct.producto_precio;
		minimumStock = editedProduct.producto_minimo;
		used = !editedProduct.producto_nuevo;
	};

	const editProduct = async () => {
		toggleEditingProduct();
		const { error } = await supabase
			.from('producto')
			.update({
				producto_nombre: name,
				producto_precio: price,
				producto_stock: stock,
				producto_minimo: minimumStock,
				producto_nuevo: !used
			})
			.eq('producto_id', tempProductId);
		if (error) console.log(error.message);
		const editedProduct = products.find((item: any) => item.producto_id === tempProductId);
		editedProduct.producto_nombre = name;
		editedProduct.producto_precio = price;
		editedProduct.producto_minimo = minimumStock;
		editedProduct.producto_nuevo = !used;
		if (categoryId === 1) {
			const { error: categoryError } = await supabase
				.from('producto_plataforma')
				.update({ plataforma_id: platformId })
				.eq('producto_id', tempProductId);
			if (categoryError) console.log(categoryError.message);
			const { data: platformName, error: platformError } = await supabase
				.from('plataforma')
				.select('plataforma_nombre')
				.eq('plataforma_id', platformId)
				.single();
			if (platformError) console.log(platformError.message);
			editedProduct.plataforma_id = platformId;
			editedProduct.plataforma_nombre = platformName?.plataforma_nombre;
		}
		products = products;
		toastStore.trigger(productEdited);
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
		const changedProduct = products.find((item: any) => item.producto_id === tempProductId);
		changedProduct.producto_stock = newStock;
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
		products = products.filter((product: any) => product.producto_id !== tempProductId);
		toastStore.trigger(productDeleted);
	};

	let rent = false;
	let doingSale = false;

	const toggleSale = () => {
		doingSale = !doingSale;
	};

	const registerSale = async (clientId: number, cashPayment: boolean) => {
		toggleSale();
		const { error } = await supabase.rpc('register_sale', {
			input_cliente_id: clientId,
			input_descuento: 0,
			input_venta_tarjeta: !cashPayment
		});
		if (error) console.log(error.message);
		else toastStore.trigger(saleAdded);
		emptyCart();
	};

	$: cartVisible = cart.length > 0;

	let cartTotal: number = 0;
	let cartQuantity: number = 0;

	$: formattedPrice = cartTotal?.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

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
		await supabase.from('carrito').delete().eq('carrito_id', cartId);
		cart = cart.filter((item: any) => item.carrito_id !== cartId);
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
		const searchWords = search.split(' ');

		filteredActiveProducts = activeProducts.filter((product: any) =>
			searchWords.every(
				(word: string) =>
					product.producto_id.toString().includes(word) ||
					product.producto_nombre.toLowerCase().includes(word) ||
					nfd(product.producto_nombre.toLowerCase()).includes(word) ||
					nfc(product.producto_nombre.toLowerCase()).includes(word) ||
					product.producto_stock.toString().includes(word) ||
					product.producto_minimo.toString().includes(word) ||
					product.producto_precio.toString().includes(word)
			)
		);

		filteredDeactivatedProducts = deactivatedProducts.filter((product: any) =>
			searchWords.every(
				(word: string) =>
					product.producto_id.toString().includes(word) ||
					product.producto_nombre.toLowerCase().includes(word) ||
					nfd(product.producto_nombre.toLowerCase()).includes(word) ||
					nfc(product.producto_nombre.toLowerCase()).includes(word) ||
					product.producto_stock.toString().includes(word) ||
					product.producto_minimo.toString().includes(word) ||
					product.producto_precio.toString().includes(word)
			)
		);
	};

	const productAdded: ToastSettings = {
		message: 'Un nuevo producto fue registrado exitosamente.',
		background: 'variant-filled-primary'
	};

	const productEdited: ToastSettings = {
		message: 'Se actualizaron los datos del producto exitosamente.',
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
			<Category on:click={filter} text={category.categoria_nombre} />
		{/each}
	</div>
	{#if filteredActiveProducts.length === 0 && filteredDeactivatedProducts.length === 0}
		<NoResultsMessage />
	{:else}
		{#if filteredActiveProducts.length !== 0}
			<SectionSubtitle text="Inventario" />
			<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
				{#each filteredActiveProducts as activeProduct}
					<Product
						{addToCart}
						editProduct={(productId) => {
							toggleEditingProduct();
							tempProductId = productId;
							bindValues();
						}}
						changeStock={(productId, currentStock) => {
							toggleChangingStock();
							tempProductId = productId;
							tempProductStock = currentStock;
						}}
						deleteProduct={(productId) => {
							toggleDeleteConfirmation();
							tempProductId = productId;
						}}
						id={activeProduct.producto_id}
					/>
				{/each}
			</div>
		{/if}
		{#if filteredDeactivatedProducts.length !== 0}
			<SectionSubtitle text="Inventario Desactivado" />
			<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
				{#each filteredDeactivatedProducts as deactivatedProduct}
					<Product
						{addToCart}
						editProduct={(productId) => {
							toggleEditingProduct();
							tempProductId = productId;
							bindValues();
						}}
						changeStock={(productId, currentStock) => {
							toggleChangingStock();
							tempProductId = productId;
							tempProductStock = currentStock;
						}}
						deleteProduct={(productId) => {
							toggleDeleteConfirmation();
							tempProductId = productId;
						}}
						id={deactivatedProduct.producto_id}
					/>
				{/each}
			</div>
		{/if}
	{/if}
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
	<div class="flex flex-col mt-auto space-y-4">
		<div class="flex justify-between text-lg">
			<p class="unstyled font-bold">Total ({cartQuantity})</p>
			<p class="unstyled">{formattedPrice}</p>
		</div>
		<RadioGroup class="justify-center" active="variant-filled-success">
			<RadioItem bind:group={rent} name="justify" value={false}>Venta</RadioItem>
			<RadioItem bind:group={rent} name="justify" value={true}>Renta</RadioItem>
		</RadioGroup>
		<button class="btn variant-filled-success font-bold" on:click={toggleSale}>
			Realizar {rent ? 'renta' : 'venta'}
		</button>
	</div>
</div>
<div class="fixed bottom-0 transition-all {cartVisible ? 'right-64' : 'right-0'}">
	<AddButton on:click={toggleAddingProduct} />
</div>
{#if addingProduct}
	<DarkenSreen>
		<ProductForm
			cancelHandler={() => {
				toggleAddingProduct();
				clearForm();
			}}
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
{#if editingProduct}
	<DarkenSreen>
		<ProductForm
			editing={true}
			cancelHandler={() => {
				toggleEditingProduct();
				clearForm();
			}}
			confirmHandler={editProduct}
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
