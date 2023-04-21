<script lang="ts">
	import Icon from '@iconify/svelte';
	import magniferLinear from '@iconify/icons-solar/magnifer-linear';
	import closeCircleLinear from '@iconify/icons-solar/close-circle-linear';

	type SearchHandler = (search: string) => void;

	export let searchClient: SearchHandler;
	export let search: string;

	const iconHeight = 24;
	let searching: boolean = false;

	const searchHandler = () => {
		searchClient(search);
	};

	const searchFocusGain = () => {
		searching = true;
	};

	const searchFocusLoss = () => {
		searching = false;
	};

	const clearSearch = () => {
		search = '';
	};
</script>

<div
	class="flex items-center px-4 space-x-4 w-full rounded-xl outline-none active:outline-pink-700 shadow-2xl transition-all duration-300 {searching
		? 'max-w-lg bg-stone-900 outline-pink-700'
		: 'max-w-xs bg-stone-800 hover:bg-stone-700'}"
>
	<Icon icon={magniferLinear} height={iconHeight} />
	<input
		type="text"
		bind:value={search}
		on:input={searchHandler}
		on:focus={searchFocusGain}
		on:blur={searchFocusLoss}
		class="w-full bg-transparent outline-none"
		placeholder="Buscar..."
	/>
	<button
		on:click={clearSearch}
		class="p-1 rounded-full transition-all {searching
			? 'hover:bg-stone-700 active:bg-stone-900'
			: 'hover:bg-stone-600 active:bg-stone-800'}"
	>
		<Icon icon={closeCircleLinear} height={iconHeight} />
	</button>
</div>
