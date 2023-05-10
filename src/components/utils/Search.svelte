<script lang="ts">
	import Icon from '@iconify/svelte';
	import magniferLinear from '@iconify/icons-solar/magnifer-linear';
	import closeCircleLinear from '@iconify/icons-solar/close-circle-linear';

	export let searchHandler: (search: string) => void;
	export let search: string;

	const iconHeight = 20;
	let searching: boolean = false;

	const searchFocusGain = () => {
		searching = true;
	};

	const searchFocusLoss = () => {
		searching = false;
	};

	const clearSearch = () => {
		search = '';
		searchHandler(search.trim().toLowerCase());
	};
</script>

<div
	class="input-group grid-cols-[auto_1fr_auto] transition-all {searching ? 'max-w-lg' : 'max-w-xs'}"
>
	<div><Icon icon={magniferLinear} height={iconHeight} /></div>
	<input
		class="input"
		type="text"
		placeholder="Search..."
		bind:value={search}
		on:focus={searchFocusGain}
		on:blur={searchFocusLoss}
		on:input={() => {
			searchHandler(search.trim().toLowerCase());
		}}
	/>
	<button on:click={clearSearch} class="btn hover:variant-soft">
		<Icon icon={closeCircleLinear} height={iconHeight} />
	</button>
</div>
