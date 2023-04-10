<script>
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';

	export let data;
	let { categories } = data;
	$: ({ categories } = data);
</script>

<SectionSubtitle text="Categorías" />
<ul>
	{#each categories as category}
		<li>{category.name}</li>
	{/each}
</ul>
