<script lang="ts">
	import { fade } from 'svelte/transition';
	import CartProduct from './CartProduct.svelte';
	import SectionTitle from './titles/SectionTitle.svelte';

	type ClickHandler = (carritoId: number) => void;
	type QuantityHandler = (cartId: number, quantity: number) => void;

	export let removeHandler: ClickHandler;
	export let quantityHandler: QuantityHandler;
	export let cartVisible: boolean;
	export let cart: any;
	export let total: any;
</script>

<div
	class="fixed inset-y-0 right-0 w-64 p-4 bg-stone-900 border-l border-stone-800 transition ease-in-out {!cartVisible
		? 'translate-x-full'
		: ''}"
>
	<div class="flex flex-col space-y-4">
		<SectionTitle text="Carrito" />
		<div class="grid grid-cols-1 gap-4 transition-all overflow-auto">
			{#each cart as product}
				<div transition:fade={{ duration: 150 }}>
					<CartProduct
						{removeHandler}
						{quantityHandler}
						id={product.carrito_id}
						name={product.producto_nombre}
						price={product.producto_precio}
						quantity={product.producto_cantidad}
						stock={product.producto_stock}
					/>
				</div>
			{/each}
		</div>
		<div class="flex text-xl px-4 justify-between">
			<p class="font-bold">Total:</p>
			<p>$ total</p>
		</div>
		<button
			class="py-4 bg-green-700 hover:bg-green-600 active:bg-green-800 outline-none focus:outline-green-700 font-bold rounded-xl transition-all"
		>
			Realizar venta
		</button>
	</div>
</div>
