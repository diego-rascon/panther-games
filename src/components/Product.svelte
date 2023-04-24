<script lang="ts">
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import boxLinear from '@iconify/icons-solar/box-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import DropdownItem from './Dropdown/DropdownItem.svelte';
	import Dropdown from './Dropdown/Dropdown.svelte';

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

	let dropdownVisible = false;

	const toggleDropdown = () => {
		dropdownVisible = !dropdownVisible;
	};
</script>

<div class="relative flex flex-col p-4 text-left bg-stone-900 rounded-xl transition-all">
	<div class="flex items-start justify-between">
		<p class="line-clamp-4 text-xl font-bold select-none">{name}</p>
		<button
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
						editProduct(id);
						toggleDropdown();
					}}
				/>
				<DropdownItem
					text="Cambiar stock"
					icon={boxLinear}
					on:click={() => {
						changeStock(id);
						toggleDropdown();
					}}
				/>
				<DropdownItem
					text="Eliminar"
					icon={trashBinMinimalisticLinear}
					on:click={() => {
						deleteProduct(id);
						toggleDropdown();
					}}
				/>
			</Dropdown>
		{/if}
	</div>
	<div class="mt-auto">
		<div class="py-4">
			{#if isGame}
				<p class="text-sm"><strong>Plataforma:</strong> {platform}</p>
			{/if}
			<p class="text-sm"><strong>Cantidad:</strong> {stock}</p>
			<p class="pt-2 text-xl font-bold">$ {price}</p>
		</div>
		<button
			class=" w-full py-2 hover:bg-stone-800 active:bg-stone-950 outline-none focus:outline-pink-700 border-2 border-pink-700 transition-all rounded-xl select-none"
			on:click={() => {
				addToCart(id);
			}}
		>
			<p class="font-bold">Agregar</p>
		</button>
	</div>
</div>
