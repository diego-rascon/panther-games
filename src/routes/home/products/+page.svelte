<script lang="ts">
	import AddButton from '../../../components/AddButton.svelte';
	import Category from '../../../components/Category.svelte';
	import ShoppingCart from '../../../components/ShoppingCart.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';

	export let data;
	let { categories } = data;
	$: ({ categories } = data);

	let cartVisible: boolean = true;

	function setCartVisible() {
		cartVisible = !cartVisible;
	}
</script>

<div class="transition-all {cartVisible ? 'mr-64' : ''}">
	<SectionSubtitle text="Categorías" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each categories as category}
			<Category text={category.name} />
		{/each}
	</div>
	<SectionSubtitle text="Inventario" />
	<p>hashdas</p>
	{#if cartVisible}
		<ShoppingCart />
	{/if}
	<AddButton {cartVisible} buttonHandler={setCartVisible} />
</div>
