<script lang="ts">
	import { cartStore, productsStore, readUser } from '$lib/stores';
	import Dropdown from '../dropdown/Dropdown.svelte';
	import DropdownItem from '../dropdown/DropdownItem.svelte';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import boxLinear from '@iconify/icons-solar/box-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import refreshCircleOutline from '@iconify/icons-solar/refresh-circle-outline';
	import restartLinear from '@iconify/icons-solar/restart-linear';

	export let addToCart: (productId: number) => void;
	export let editProduct: (productId: number) => void;
	export let changeStock: (productId: number, currentStock: number) => void;
	export let toggleProduct: (productId: number) => void;
	export let id: number;

	let loading = false;

	$: product = $productsStore.find((item: any) => item.producto_id === id);
	$: name = product?.producto_nombre;
	$: stock = Number(product?.producto_stock);
	$: soldOut = stock < 1;
	$: price = Number(product?.producto_precio);
	$: isGame = product?.categoria_id === 1;
	$: platform = product?.plataforma_nombre;
	$: isNew = product?.producto_nuevo;
	$: active = product?.producto_activo;
	$: onCart = $cartStore.some((item: any) => item.producto_id === id);
	$: loading = $cartStore.some((item: any) => item.producto_id === id);
	$: formattedPrice = price.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	let dropdownVisible = false;
	let container: HTMLElement;

	const toggleDropdown = () => {
		dropdownVisible = !dropdownVisible;
	};

	const windowHandler = (e: any) => {
		if (container.contains(e.target) == false) dropdownVisible = false;
	};
</script>

<svelte:window on:click={windowHandler} on:wheel={windowHandler} />
<div
	class="relative flex flex-col p-4 text-left bg-stone-900 rounded-xl transition-all {!active ||
	soldOut
		? ' text-stone-400'
		: ''}"
>
	<div class="flex items-start justify-between">
		<div class="flex flex-col items-start space-y-2">
			<p class="unstyled line-clamp-4 text-xl font-bold">{name}</p>
			{#if !isNew}
				<p class="unstyled px-2 p-1 variant-soft-warning rounded-full text-xs">Usado</p>
			{/if}
		</div>
		<div bind:this={container}>
			{#if !$readUser}
				<button
					on:click={toggleDropdown}
					class="btn p-1 rounded-full {dropdownVisible
						? 'variant-soft-primary'
						: 'hover:variant-filled-surface'}"
				>
					<Icon icon={menuDotsBold} rotate={1} height={20} />
				</button>
				{#if dropdownVisible}
					<div class="absolute right-4 -top-[132px]">
						<Dropdown>
							<DropdownItem
								text="Editar"
								icon={pen2Linear}
								on:click={() => {
									editProduct(id);
								}}
							/>
							<DropdownItem
								text="Editar stock"
								icon={boxLinear}
								on:click={() => {
									changeStock(id, stock);
								}}
							/>
							{#if active}
								<DropdownItem
									text="Eliminar"
									icon={trashBinMinimalisticLinear}
									on:click={() => {
										toggleProduct(id);
									}}
								/>
							{:else}
								<DropdownItem
									text="Activar"
									icon={restartLinear}
									flipIcon={true}
									on:click={() => {
										toggleProduct(id);
									}}
								/>
							{/if}
						</Dropdown>
					</div>
				{/if}
			{/if}
		</div>
	</div>
	<div class="flex flex-col mt-auto">
		<div class={!active || soldOut ? 'pt-4' : 'py-4'}>
			{#if isGame}
				<p class="unstyled text-sm"><strong>Plataforma:</strong> {platform}</p>
			{/if}
			{#if !soldOut}
				<p class="unstyled text-sm"><strong>Cantidad:</strong> {stock}</p>
			{/if}
			<p class="unstyled pt-2 text-xl font-bold">{formattedPrice}</p>
		</div>
		{#if active && !soldOut && !$readUser}
			<button
				class="btn {onCart || loading
					? 'text-stone-400 bg-surface-700 border-surface-400'
					: 'variant-ringed-primary font-bold'}"
				on:click={() => {
					if (!loading && !onCart) {
						loading = true;
						addToCart(id);
					}
				}}
			>
				{#if onCart}
					En el carrito
				{:else if loading}
					<Icon class="animate-spin" icon={refreshCircleOutline} height={24} hFlip={true} />
				{:else}
					Agregar
				{/if}
			</button>
		{/if}
	</div>
</div>
