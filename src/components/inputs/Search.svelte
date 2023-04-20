<script lang="ts">
	import Icon from '@iconify/svelte';
	import magniferLinear from '@iconify/icons-solar/magnifer-linear';

	type SearchHandler = (search: string) => void;

	export let searchClient: SearchHandler;
	export let search: string;

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
</script>

<div
	class="flex items-center px-4 space-x-4 w-full rounded-xl outline-none active:outline-pink-700 shadow-2xl transition-all {searching
		? 'max-w-lg bg-stone-900 outline-pink-700'
		: 'max-w-xs bg-stone-800'}"
>
	<Icon icon={magniferLinear} height={20} />
	<input
		type="text"
		bind:value={search}
		on:input={searchHandler}
		on:focus={searchFocusGain}
		on:blur={searchFocusLoss}
		class="w-full bg-transparent outline-none"
		placeholder="Buscar..."
	/>
</div>
