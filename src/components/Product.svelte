<script lang="ts">
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import Icon from '@iconify/svelte';

	export let name: string;
	export let stock: number;
	export let price: number;
	export let platform: string;
	export let isGame: boolean;

	let isDropdownOpen = false; // default state (dropdown close)

	const handleDropdownClick = () => {
		isDropdownOpen = !isDropdownOpen; // toggle state on click
	};

	const handleDropdownFocusLoss = () => {
		// use "blur" event to ensure that we can close the dropdown when clicking outside or when we leave the dropdown with the "Tab" button
		isDropdownOpen = false;
	};
</script>

<div class="relative flex flex-col p-4 text-left bg-stone-900 rounded-xl transition-all">
	<button
		on:click={handleDropdownClick}
		class="ml-auto rounded-full hover:bg-stone-800 active:bg-stone-950 transition-all"
		on:blur={handleDropdownFocusLoss}
	>
		<Icon icon={menuDotsBold} rotate={1} height={24} />
	</button>
	<div
		class="dropdown-content bg-stone-950 border border-stone-700 rounded-md text-center w-25 transition-all"
		style:visibility={isDropdownOpen ? 'visible' : 'hidden'}
		style="position: absolute; left: 70%; top: 0; margin-top: 2.8rem;"
	>
		<ul class="w-auto">
			<li><button class="w-full py-2 hover:bg-stone-800 active:bg-stone-950">Editar</button></li>
			<li>
				<button class="w-full py-2 hover:bg-stone-800 active:bg-stone-950">Cambio Stock</button>
			</li>
			<li><button class="w-full py-2 hover:bg-stone-800 active:bg-stone-950">Eliminar</button></li>
		</ul>
	</div>

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

<style>
	.dropdown-content {
		position: absolute;

		z-index: 9999; /* Establecer un valor alto para el z-index para que el menú aparezca por encima de todo en la página */
		/* Otros estilos del menú desplegable */
	}
</style>
