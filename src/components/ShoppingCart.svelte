<script lang="ts">
	import CartProduct from './CartProduct.svelte';
import SectionTitle from './titles/SectionTitle.svelte';

	export let cartVisible: boolean;
	export let cart: any;
</script>

<div
	class="fixed inset-y-0 right-0 w-64 p-4 bg-stone-900 border-l border-stone-800 transition ease-in-out {!cartVisible
		? 'translate-x-full'
		: ''}"
>
	<SectionTitle text="Carrito" />
	{#each cart as product}
		<CartProduct name={product.producto_nombre} />
	{/each}
</div>
