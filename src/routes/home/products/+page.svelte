<script>
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';

	export let data;
	let { countries } = data;
	$: ({ countries } = data);
</script>

<SectionSubtitle text="Categorías" />
<ul>
	{#each countries as country}
		<li>{country.name}</li>
	{/each}
</ul>
