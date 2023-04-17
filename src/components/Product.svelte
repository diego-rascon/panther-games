<script lang="ts">
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import Icon from '@iconify/svelte';
	import Dropdown from './Dropdown.svelte';

	export let name: string;
	export let stock: number;
	export let price: number;
	export let platform: string;
	export let isGame: boolean;

	let dropdownVisible = false;

	const togleDropdown = () => {
		dropdownVisible = !dropdownVisible;
	};

	const dropdownFocusLoss = () => {
		dropdownVisible = false;
	};
</script>

<div class="relative flex flex-col p-4 text-left bg-stone-900 rounded-xl transition-all">
	<button
		on:click={togleDropdown}
		class="ml-auto rounded-full hover:bg-stone-800 active:bg-stone-950 transition-all"
		on:blur={dropdownFocusLoss}
	>
		<Icon icon={menuDotsBold} rotate={1} height={24} />
	</button>
	<p class="text-xl font-lexend font-bold select-none">
		{name}
	</p>

	<div class="mt-auto">
		<div class="py-4">
			{#if isGame}
				<p class="text-sm"><strong>Plataforma:</strong> {platform}</p>
			{/if}
			<p class="text-sm"><strong>Cantidad:</strong> {stock}</p>
			<p class="pt-4 text-xl font-bold">$ {price}</p>
		</div>
		<button
			class=" w-full py-2 hover:bg-stone-800 active:bg-stone-950 outline-none focus:outline-pink-700 border-2 border-pink-700 transition-all rounded-xl select-none"
		>
			<p class="font-bold">Agregar</p>
		</button>
	</div>
</div>
{#if dropdownVisible}
	<Dropdown />
{/if}
