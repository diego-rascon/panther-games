<script lang="ts">
	import AddButton from '../../../components/AddButton.svelte';
	import Category from '../../../components/Category.svelte';
	import Product from '../../../components/Product.svelte';
	import ShoppingCart from '../../../components/ShoppingCart.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';

	let cartVisible: boolean = false;

	export let data;
	$: ({ categories, products, platforms, productsPlatforms } = data);

	function setCartVisible() {
		cartVisible = !cartVisible;
	}
</script>

<div class="transition-all {cartVisible ? 'mr-64' : ''}">
	<SectionSubtitle text="Categorías" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each categories as category}
			<Category text={category.categoria_nombre} />
		{/each}
	</div>
	<SectionSubtitle text="Inventario" />
	<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 transition-all">
		{#each products as product}
			<Product text={product.producto_nombre} category={product.categoria_id} />
		{/each}
	</div>
	<ShoppingCart {cartVisible} />
	<AddButton {cartVisible} buttonHandler={setCartVisible} />
</div>
