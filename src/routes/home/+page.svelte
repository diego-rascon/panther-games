<script lang="ts">
	import { supabase } from '$lib/db';
	import { productsStore, cartStore, readUser } from '$lib/stores';
	import { RadioGroup, RadioItem, type ToastSettings } from '@skeletonlabs/skeleton';
	import { toastStore } from '@skeletonlabs/skeleton';
	import { fade } from 'svelte/transition';
	import Icon from '@iconify/svelte';
	import cartCrossOutline from '@iconify/icons-solar/cart-cross-outline';
	import SectionTitle from '../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../components/titles/SectionSubtitle.svelte';
	import Category from '../../components/data/Category.svelte';
	import Product from '../../components/data/Product.svelte';
	import CartProduct from '../../components/data/CartProduct.svelte';
	import ProductForm from '../../components/forms/ProductForm.svelte';
	import SaleForm from '../../components/forms/SaleForm.svelte';
	import AddButton from '../../components/utils/AddButton.svelte';
	import Search from '../../components/utils/Search.svelte';
	import ChangeStock from '../../components/forms/ChangeStock.svelte';
	import ConfirmDialog from '../../components/modals/ConfirmDialog.svelte';
	import DarkenSreen from '../../components/modals/DarkenSreen.svelte';
	import NoResultsMessage from '../../components/utils/NoResultsMessage.svelte';
	import { nfc, nfd } from 'unorm';
	import RentForm from '../../components/forms/RentForm.svelte';
	import moment from 'moment';
	import dayjs from 'dayjs';

	export let data;
	let { categories, products, platforms, cart, clients, members } = data;
	$: ({ categories, products, platforms, cart, clients, members } = data);

	$: cartStore.set(cart);
	$: productsStore.set(products);
	$: activeProducts = products.filter(
		(product: any) => product.producto_activo && product.producto_stock > 0
	);
	$: deactivatedProducts = products.filter((product: any) => !product.producto_activo);
	$: soldOutProducts = products.filter(
		(product: any) => product.producto_activo && product.producto_stock < 1
	);
	$: filteredActiveProducts = activeProducts;
	$: filteredDeactivatedProducts = deactivatedProducts;
	$: filteredSoldOutProducts = soldOutProducts;

	enum Filter {
		None,
		Game,
		Console,
		Accesory,
		Other
	}

	let currentFilter = Filter.None;

	const changeFilter = (newAction: Filter) => {
		currentFilter = currentFilter === newAction ? Filter.None : newAction;
	};

	$: {
		switch (currentFilter) {
			case Filter.None:
				filteredActiveProducts = activeProducts;
				filteredDeactivatedProducts = deactivatedProducts;
				filteredSoldOutProducts = soldOutProducts;
				break;
			case Filter.Game:
				filteredActiveProducts = activeProducts.filter(
					(product: any) => product.categoria_id === 1
				);
				filteredDeactivatedProducts = deactivatedProducts.filter(
					(product: any) => product.categoria_id === 1
				);
				filteredSoldOutProducts = soldOutProducts.filter(
					(product: any) => product.categoria_id === 1
				);
				break;
			case Filter.Console:
				filteredActiveProducts = activeProducts.filter(
					(product: any) => product.categoria_id === 2
				);
				filteredDeactivatedProducts = deactivatedProducts.filter(
					(product: any) => product.categoria_id === 2
				);
				filteredSoldOutProducts = soldOutProducts.filter(
					(product: any) => product.categoria_id === 2
				);
				break;
			case Filter.Accesory:
				filteredActiveProducts = activeProducts.filter(
					(product: any) => product.categoria_id === 3
				);
				filteredDeactivatedProducts = deactivatedProducts.filter(
					(product: any) => product.categoria_id === 3
				);
				filteredSoldOutProducts = soldOutProducts.filter(
					(product: any) => product.categoria_id === 3
				);
				break;
			case Filter.Other:
				filteredActiveProducts = activeProducts.filter(
					(product: any) => product.categoria_id === 4
				);
				filteredDeactivatedProducts = deactivatedProducts.filter(
					(product: any) => product.categoria_id === 4
				);
				filteredSoldOutProducts = soldOutProducts.filter(
					(product: any) => product.categoria_id === 4
				);
				break;
		}
	}

	let search = '';

	const searchProduct = (search: string) => {
		currentFilter = Filter.None;
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

		filteredSoldOutProducts = soldOutProducts.filter((product: any) =>
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
		if (product && categoryId === 1) {
			addProductPlatform(product.producto_id);
			const { data } = await supabase
				.from('plataforma')
				.select()
				.eq('plataforma_id', platformId)
				.single();
			if (data) product.plataforma_nombre = data.plataforma_nombre;
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
		if (editedProduct) {
			categoryId = editedProduct.categoria_id;
			platformId = editedProduct.plataforma_id;
			name = editedProduct.producto_nombre;
			price = editedProduct.producto_precio;
			minimumStock = editedProduct.producto_minimo;
			used = !editedProduct.producto_nuevo;
		}
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
		const editedProduct = products.findIndex((item: any) => item.producto_id === tempProductId);
		products[editedProduct].producto_nombre = name;
		products[editedProduct].producto_precio = price;
		products[editedProduct].producto_minimo = minimumStock;
		products[editedProduct].producto_nuevo = !used;
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
			if (platformName) {
				products[editedProduct].plataforma_id = platformId;
				products[editedProduct].plataforma_nombre = platformName.plataforma_nombre;
				toastStore.trigger(productEdited);
			}
		}
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
		const changedProduct = products.findIndex((item: any) => item.producto_id === tempProductId);
		products[changedProduct].producto_stock = newStock;
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
			.eq('producto_id', tempProductId);
		if (error) console.log(error.message);
		const removedProduct = products.findIndex(
			(product: any) => product.producto_id === tempProductId
		);
		products[removedProduct].producto_activo = false;
		toastStore.trigger(productDeleted);
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateProduct = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('producto')
			.update({ producto_activo: true })
			.eq('producto_id', tempProductId);
		if (error) console.log(error.message);
		const activatedProduct = products.findIndex(
			(product: any) => product.producto_id === tempProductId
		);
		products[activatedProduct].producto_activo = true;
		toastStore.trigger(productActivated);
	};

	let doingSale = false;

	const toggleSale = () => {
		doingSale = !doingSale;
	};

	let fechaActual = new Date();
	let fechaActualFormat = moment(fechaActual).format('MM-DD-YYYY');

	const updateCaja = async (cashPayment: boolean) => {
		if (cashPayment) {
			const newTotal = (await getCajaValue()) + cartTotal;
			const { error } = await supabase
				.from('caja')
				.update({ caja_total: newTotal })
				.eq('caja_fecha', fechaActualFormat);
			if (error) {
				console.log(error.message);
				console.log('no hubo caja');
				return false;
			}
			console.log('si hubo caja');
			return true;
		} else {
			const { error } = await supabase
				.from('caja')
				.update({ caja_total: await getCajaValue() })
				.eq('caja_fecha', fechaActualFormat);
			if (error) {
				console.log(error.message);
				console.log('no hubo caja');
				return false;
			}
			console.log('si hubo caja');
			return true;
		}
	};

	const getCajaValue = async () => {
		const { data, error } = await supabase
			.from('caja')
			.select('caja_total')
			.eq('caja_fecha', fechaActualFormat)
			.select()
			.maybeSingle();
		if (error) {
			toastStore.trigger(cajaNotFound);
		}
		if (data) return Number(data.caja_total);
		else toastStore.trigger(cajaNotFound);
		return -1;
	};

	const registerSale = async (clientId: number, cashPayment: boolean) => {
		toggleSale();
		if (await updateCaja(cashPayment)) {
			console.log('REGISTER SALE');
			lowerStock();
			const { error } = await supabase.rpc('register_sale', {
				input_cliente_id: clientId,
				input_descuento: 0,
				input_venta_tarjeta: !cashPayment
			});
			if (error) console.log(error.message);
			else toastStore.trigger(saleAdded);
			const isMember = members.find((member: any) => member.cliente_id === clientId);
			if (isMember) updateMemberCounter(false, clientId, cart.length);
			emptyCart();
		}
	};

	const updateMemberCounter = async (rent: boolean, id: number, quantity: number) => {
		const { data: counter, error: counterError }: any = await supabase
			.from('miembro')
			.select(rent ? 'miembro_rentas' : 'miembro_compras')
			.eq(rent ? 'miembro_id' : 'cliente_id', id)
			.single();
		if (counterError) console.log(counterError.message);
		if (counter) {
			if (rent) {
				const newQuantity = counter.miembro_rentas + quantity;
				const { error } = await supabase
					.from('miembro')
					.update({ miembro_rentas: newQuantity })
					.eq('miembro_id', id);
				if (error) console.log(error.message);
			} else {
				const newQuantity = counter.miembro_compras + quantity;
				const { error } = await supabase
					.from('miembro')
					.update({ miembro_compras: newQuantity })
					.eq('cliente_id', id);
				if (error) console.log(error.message);
			}
		}
	};

	const lowerStock = () => {
		for (const cartProduct of cart) {
			const boughtProduct = products.findIndex(
				(product: any) => product.producto_id === cartProduct.producto_id
			);
			products[boughtProduct].producto_stock -= rent ? 1 : cartProduct.producto_cantidad;
		}
	};

	let doingRent = false;
	let rent = false;
	$: validRent = validRentProducts && validRentQuantity;
	$: validRentProducts = rent && cart.every((cartProduct: any) => cartProduct.plataforma_id === 3);
	$: validRentQuantity = cart.length <= 3;

	const toggleRent = () => {
		doingRent = !doingRent;
	};

	const updateCajaRent = async (rentTotal: number, cashPayment: boolean) => {
		if (cashPayment) {
			const currentTotal = await getCajaValue();
			const newTotal = currentTotal + rentTotal;
			const { data, error } = await supabase
				.from('caja')
				.update({ caja_total: newTotal })
				.eq('caja_fecha', fechaActualFormat);
			if (error) {
				console.log(error.message);
				console.log('no hubo caja');
				return false;
			}
			console.log('si hubo caja');
			return true;
		} else {
			const { data, error } = await supabase
				.from('caja')
				.update({
					caja_total: await getCajaValue()
				})
				.eq('caja_fecha', fechaActualFormat);
			if (error) {
				console.log(error.message);
				console.log('no hubo caja');
				return false;
			}
			console.log('si hubo caja');
			return true;
		}
	};

	const registerRent = async (memberId: number, duration: number, cashPayment: boolean) => {
		toggleRent();

		const rentTotal = duration === 3 ? 100 * cart.length : 200 * cart.length;

		if (await updateCajaRent(rentTotal, cashPayment)) {
			const startDate = new Date();
			const endDate = new Date();

			endDate.setDate(startDate.getDate() + duration);

			const formattedStartDate = dayjs(startDate).format('YYYY-MM-DD');
			const formattedEndDate = dayjs(endDate).format('YYYY-MM-DD');

			const { data: rent, error: rentError } = await supabase
				.from('renta')
				.insert({
					miembro_id: memberId,
					renta_duracion: duration,
					renta_monto: rentTotal,
					renta_descuento: 0,
					renta_tarjeta: !cashPayment,
					renta_cantidad: cart.length,
					renta_fecha_inicio: formattedStartDate,
					renta_fecha_final: formattedEndDate
				})
				.select()
				.single();
			if (rentError) console.log(rentError.message);
			if (rent) {
				for (const cartProduct of cart) {
					const productId = cartProduct.producto_id;
					const { error: detailError } = await supabase
						.from('renta_detalle')
						.insert({ renta_id: rent.renta_id, producto_id: productId });
					if (detailError) console.log(detailError.message);
					const { data: product, error: productError } = await supabase
						.from('producto')
						.select('producto_stock')
						.eq('producto_id', productId)
						.single();
					if (productError) console.log(productError.message);
					if (product) {
						const newStock = product.producto_stock - 1;
						const { error } = await supabase
							.from('producto')
							.update({ producto_stock: newStock })
							.eq('producto_id', productId);
						if (error) console.log(error.message);
					}
				}
				updateMemberCounter(true, memberId, cart.length);
				lowerStock();
				toastStore.trigger(rentAdded);
				emptyCart();
			}
		}
	};

	let cartVisible = cart.length > 0 && !$readUser;
	$: cartVisible = cart.length > 0 && !$readUser;

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
		const removedItem = products.findIndex((item: any) => item.producto_id === productId);
		products[removedItem].on_cart = false;
		fetchTotal();
	};

	const emptyCart = async () => {
		rent = false;
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
		const updatedItem = cart.findIndex((item: any) => item.carrito_id === cartId);
		cart[updatedItem].producto_cantidad = quantity;
		fetchTotal();
	};

	const productAdded: ToastSettings = {
		message: 'Un nuevo producto fue registrado exitosamente.',
		background: 'variant-filled-primary'
	};

	const productEdited: ToastSettings = {
		message: 'Se actualizaron los datos del producto exitosamente.',
		background: 'variant-filled-primary'
	};

	const productDeleted: ToastSettings = {
		message: 'Un producto fue eliminado exitosamente.',
		background: 'variant-filled-primary'
	};

	const productActivated: ToastSettings = {
		message: 'Un producto fue activado exitosamente.',
		background: 'variant-filled-primary'
	};

	const stockChanged: ToastSettings = {
		message: 'Se actualizó el stock del producto exitosamente.',
		background: 'variant-filled-primary'
	};

	const saleAdded: ToastSettings = {
		message: 'Una nueva venta fue registrada exitosamente.',
		background: 'variant-filled-primary'
	};

	const saleMode: ToastSettings = {
		message: 'Ahora se está registrando una venta.',
		background: 'variant-filled-primary'
	};

	const rentAdded: ToastSettings = {
		message: 'Una nueva renta fue registrada exitosamente.',
		background: 'variant-filled-primary'
	};

	const rentMode: ToastSettings = {
		message: 'Ahora se está registrando una renta.',
		background: 'variant-filled-primary'
	};

	const cajaNotFound: ToastSettings = {
		message: 'No existe una caja establecida para el dia de hoy',
		background: 'variant-filled-primary'
	};
</script>

<div class="mt-[60px] mb-20 space-y-4 transition-all {cartVisible ? 'mr-64' : ''}">
	<SectionSubtitle text="Categorías" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each categories as category}
			<Category
				on:click={() => {
					switch (category.categoria_id) {
						case 1:
							changeFilter(Filter.Game);
							break;
						case 2:
							changeFilter(Filter.Console);
							break;
						case 3:
							changeFilter(Filter.Accesory);
							break;
						case 4:
							changeFilter(Filter.Other);
					}
				}}
				active={currentFilter === category.categoria_id}
				text={category.categoria_nombre}
			/>
		{/each}
	</div>
	{#if filteredActiveProducts.length === 0 && filteredDeactivatedProducts.length === 0}
		<NoResultsMessage search={search !== ''} />
	{:else}
		{#if filteredActiveProducts.length > 0}
			<SectionSubtitle text="Inventario" />
			<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
				{#each filteredActiveProducts as activeProduct (activeProduct.producto_id)}
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
						toggleProduct={(productId) => {
							toggleDeleteConfirmation();
							tempProductId = productId;
						}}
						id={activeProduct.producto_id}
					/>
				{/each}
			</div>
		{/if}
		{#if filteredSoldOutProducts.length > 0}
			<SectionSubtitle text="Inventario Agotado" />
			<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
				{#each filteredSoldOutProducts as soldOutProduct (soldOutProduct.producto_id)}
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
						toggleProduct={(productId) => {
							toggleActivateConfirmation();
							tempProductId = productId;
						}}
						id={soldOutProduct.producto_id}
					/>
				{/each}
			</div>
		{/if}
		{#if filteredDeactivatedProducts.length > 0}
			<SectionSubtitle text="Inventario no Activo" />
			<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
				{#each filteredDeactivatedProducts as deactivatedProduct (deactivatedProduct.producto_id)}
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
						toggleProduct={(productId) => {
							toggleActivateConfirmation();
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
		{#each cart as cartProduct}
			<div transition:fade={{ duration: 150 }}>
				<CartProduct
					removeHandler={removeFromCart}
					quantityHandler={updateQuantity}
					bind:rent
					cartId={cartProduct.carrito_id}
					productId={cartProduct.producto_id}
					categoryId={cartProduct.categoria_id}
					categoryName={cartProduct.categoria_nombre}
					platformName={cartProduct.plataforma_nombre}
					name={cartProduct.producto_nombre}
					newProduct={cartProduct.producto_nuevo}
					price={cartProduct.producto_precio}
					stock={cartProduct.producto_stock}
					quantity={cartProduct.producto_cantidad}
				/>
			</div>
		{/each}
	</div>
	<!--Buttons-->
	<div class="flex flex-col mt-auto space-y-4">
		{#if rent}
			{#if !validRentProducts}
				<p class="unstyled text-sm text-warning-700">
					Solo juegos para Switch pueden participar en una renta.
				</p>
			{/if}
			{#if !validRentQuantity}
				<p class="unstyled text-sm text-warning-700">Solo se puede rentar un máximo de 3 juegos.</p>
			{/if}
		{:else}
			<div class="flex justify-between text-lg">
				<p class="unstyled font-bold">Total ({cartQuantity})</p>
				<p class="unstyled">{formattedPrice}</p>
			</div>
		{/if}
		<RadioGroup class="justify-center" active="variant-filled-success">
			<RadioItem
				bind:group={rent}
				name="justify"
				value={false}
				on:click={() => {
					if (rent) toastStore.trigger(saleMode);
				}}>Venta</RadioItem
			>
			<RadioItem
				bind:group={rent}
				name="justify"
				value={true}
				on:click={() => {
					if (!rent) toastStore.trigger(rentMode);
				}}>Renta</RadioItem
			>
		</RadioGroup>
		{#if rent}
			<button
				class="btn font-bold {validRent
					? 'variant-filled-success'
					: 'text-stone-400 bg-surface-700 border-surface-400'}"
				on:click={() => {
					if (validRent) toggleRent();
				}}
			>
				Realizar renta
			</button>
		{:else}
			<button class="btn font-bold variant-filled-success" on:click={toggleSale}>
				Realizar venta
			</button>
		{/if}
	</div>
</div>
{#if !$readUser}
	<div class="fixed bottom-0 transition-all {cartVisible ? 'right-64' : 'right-0'}">
		<AddButton on:click={toggleAddingProduct} />
	</div>
{/if}
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
{#if activateConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleActivateConfirmation}
			confirmHandler={activateProduct}
			title="Activar Producto"
			text="¿Seguro de que desea activar el producto?"
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
{#if doingRent}
	<DarkenSreen>
		<RentForm cancelHandler={toggleRent} confirmHandler={registerRent} {members} {cartQuantity} />
	</DarkenSreen>
{/if}
