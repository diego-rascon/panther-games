<script lang="ts">
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import Icon from '@iconify/svelte';
	import Dropdown from './Dropdown/Dropdown.svelte';

	type ClickHandler = (productId: number, productQuantity: number) => void;

	export let clickHandler: ClickHandler;
	export let isGame: boolean;
	export let id: number;
	export let name: string;
	export let stock: number;
	export let price: number;
	export let platform: string;

	let onCart: boolean = false;

	const addHandler = () => {
		clickHandler(id, 1);
	};

	let dropdownVisible = false;

	const toggleDropdown = () => {
		dropdownVisible = !dropdownVisible;
	};
</script>

<div class="relative flex flex-col p-4 text-left bg-stone-900 rounded-xl transition-all">
	<div class="flex items-start justify-between">
		<p class="text-xl font-bold select-none">{name}</p>
		<button
			on:click={toggleDropdown}
			class="ml-2 rounded-full p-1 hover:bg-stone-800 active:bg-stone-950 transition-all"
		>
			{#if dropdownVisible}
				<Dropdown />
			{/if}
			<Icon icon={menuDotsBold} rotate={1} height={18} />
		</button>
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
			on:click={addHandler}
		>
			<p class="font-bold">Agregar</p>
		</button>
	</div>
</div>
