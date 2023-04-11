<script lang="ts">
	import { getContext } from 'svelte';
	import AddButton from '../../../components/AddButton.svelte';
	import Category from '../../../components/Category.svelte';
	import ShoppingCart from '../../../components/ShoppingCart.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';

	let cartVisible: boolean = false;

	export let data;
	let { categories } = data;
	$: ({ categories } = data);

	function setCartVisible() {
		cartVisible = !cartVisible;
	}
</script>

<div class="transition-all {cartVisible ? 'mr-64' : ''}">
	<SectionSubtitle text="Categorías" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each data.categories as category}
			<Category text={category.name} />
		{/each}
	</div>
	<SectionSubtitle text="Inventario" />
	<p>hashdas</p>
	<ShoppingCart {cartVisible} />
	<AddButton {cartVisible} buttonHandler={setCartVisible} />
</div>
