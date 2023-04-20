<script lang="ts">
	import Icon from '@iconify/svelte';
	import magniferLinear from '@iconify/icons-solar/magnifer-linear';

	type SearchHandler = (search: string) => void;

	export let searchClient: SearchHandler;
	export let search: string;

	const searchHandler = () => {
		searchClient(search);
	};
</script>

<div
	class="flex items-center px-4 w-full max-w-md bg-stone-900 rounded-xl outline-none active:outline-pink-700 transition-all"
>
	<input
		type="text"
		bind:value={search}
		on:input={searchHandler}
		class="w-full bg-transparent outline-none"
		placeholder="Buscar..."
	/>
	<Icon icon={magniferLinear} height={20} />
</div>
