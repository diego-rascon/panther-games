<script lang="ts">
	import { popup } from '@skeletonlabs/skeleton';
	import type { PopupSettings } from '@skeletonlabs/skeleton';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import boxLinear from '@iconify/icons-solar/box-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import { activeProducts } from '$lib/stores';

	export let addToCart: (productId: number) => void;
	export let editProduct: (productId: number) => void;
	export let changeStock: (productId: number) => void;
	export let deleteProduct: (productId: number) => void;
	export let isGame: boolean;
	export let id: number;
	export let name: string;
	export let stock: number;
	export let price: number;
	export let platform: string;

	$: onCart = $activeProducts.some((item: any) => item.productId == id);

	let dropdownVisible = false;

	const toggleDropdown = () => {
		dropdownVisible = !dropdownVisible;
	};

	const closeDropdown = () => {
		dropdownVisible = false;
	};
</script>

<div class="relative flex flex-col p-4 text-left bg-stone-900 rounded-xl transition-all">
	<div class="flex items-start justify-between">
		<p class="unstyled line-clamp-4 text-xl font-bold select-none">{name}</p>
		<button
			class="ml-2 rounded-full p-1 hover:bg-stone-800 active:bg-stone-950 transition-all {dropdownVisible
				? 'bg-stone-800'
				: ''}"
		>
			<Icon icon={menuDotsBold} rotate={1} height={18} />
		</button>
		<!--
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
						changeStock(id);
					}}
				/>
				<DropdownItem
					text="Eliminar"
					icon={trashBinMinimalisticLinear}
					on:click={() => {
						deleteProduct(id);
					}}
				/>
			</Dropdown>
			-->
	</div>
	<div class="flex flex-col mt-auto">
		<div class="py-4">
			{#if isGame}
				<p class="unstyled text-sm"><strong>Plataforma:</strong> {platform}</p>
			{/if}
			<p class="unstyled text-sm"><strong>Cantidad:</strong> {stock}</p>
			<p class="unstyled pt-2 text-xl font-bold">$ {price}</p>
		</div>
		<button
			class="btn {onCart
				? ' text-stone-400 bg-surface-700 border-surface-400'
				: 'variant-ringed-primary font-bold'}"
			on:click={() => {
				if (!onCart) addToCart(id);
			}}
		>
			Agregar
		</button>
	</div>
</div>
