<script lang="ts">
	import { activeProducts } from '$lib/stores';
	import { popup } from '@skeletonlabs/skeleton';
	import type { PopupSettings } from '@skeletonlabs/skeleton';
	import Dropdown from './dropdown/Dropdown.svelte';
	import DropdownItem from './dropdown/DropdownItem.svelte';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import boxLinear from '@iconify/icons-solar/box-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';

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

	let dropdown: any = {
		placement: 'bottom-end',
		event: 'focus-click'
	};
</script>

<div class="flex flex-col p-4 text-left bg-stone-900 rounded-xl transition-all">
	<div class="flex items-start justify-between">
		<div class="flex flex-col items-start space-y-2">
			<p class="unstyled line-clamp-4 text-xl font-bold select-none">{name}</p>
			<p class="unstyled px-2 p-1 variant-soft-primary rounded-full text-xs">Usado</p>
		</div>
		<button
			on:click
			use:popup={{ ...dropdown, target: `dropdown-${id}` }}
			class="btn variant-filled-surface p-1 rounded-full"
		>
			<Icon icon={menuDotsBold} rotate={1} height={20} />
		</button>
		<div data-popup={`dropdown-${id}`}>
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
		</div>
		<!--
			
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
