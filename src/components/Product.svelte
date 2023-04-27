<script lang="ts">
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import boxLinear from '@iconify/icons-solar/box-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import DropdownItem from './Dropdown/DropdownItem.svelte';
	import Dropdown from './Dropdown/Dropdown.svelte';
	import { createEventDispatcher } from 'svelte';

	type UpdateProduct = (productId: number) => void;

	export let addToCart: UpdateProduct;
	export let editProduct: UpdateProduct;
	export let changeStock: UpdateProduct;
	export let deleteProduct: UpdateProduct;
	export let isGame: boolean;
	export let id: number;
	export let name: string;
	export let stock: number;
	export let price: number;
	export let platform: string;
	export let onCart: boolean;

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
		<p class="line-clamp-4 text-xl font-bold select-none">{name}</p>
		<button
			on:focusout={closeDropdown}
			on:click={toggleDropdown}
			class="ml-2 rounded-full p-1 hover:bg-stone-800 active:bg-stone-950 transition-all {dropdownVisible
				? 'bg-stone-800'
				: ''}"
		>
			<Icon icon={menuDotsBold} rotate={1} height={18} />
		</button>
		{#if dropdownVisible}
			<Dropdown>
				<DropdownItem
					text="Editar"
					icon={pen2Linear}
					on:click={() => {
						console.log('hehe');
						
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
		{/if}
	</div>
	<div class="flex flex-col mt-auto">
		<div class="py-4">
			{#if isGame}
				<p class="text-sm"><strong>Plataforma:</strong> {platform}</p>
			{/if}
			<p class="text-sm"><strong>Cantidad:</strong> {stock}</p>
			<p class="pt-2 text-xl font-bold">$ {price}</p>
		</div>
		<button
			class="py-2 border-2 outline-none rounded-xl transition-all select-none {onCart
				? 'border-stone-700 text-stone-300'
				: 'hover:bg-stone-800 active:bg-stone-950 border-pink-700 font-bold focus:outline-pink-700'}"
			on:click={() => {
				if (!onCart) {
					addToCart(id);
					onCart = true;
				}
			}}>Agregar</button
		>
	</div>
</div>
