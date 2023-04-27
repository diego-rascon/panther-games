<script lang="ts">
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';

	type RemoveHandler = (cartId: number, productId: number) => void;
	type QuantityHandler = (cartId: number, quantity: number) => void;

	export let removeHandler: RemoveHandler;
	export let quantityHandler: QuantityHandler;
	export let cartId: number;
	export let productId: number;
	export let name: string;
	export let price: number;
	export let stock: number;
	export let quantity: number;
</script>

<div class="p-4 bg-stone-800 rounded-xl space-y-2">
	<div class="flex justify-between">
		<p class="line-clamp-2 w-32">{name}</p>
		<p>$ {quantity * price}</p>
	</div>
	<div class="flex justify-end space-x-2">
		<input
			type="number"
			min="1"
			max={stock}
			bind:value={quantity}
			on:change={() => {
				quantityHandler(cartId, quantity);
			}}
			class="w-12 p-2 bg-stone-900 outline-pink rounded-xl select-none"
		/>
		<button
			on:click={() => {
				removeHandler(cartId, productId);
			}}
			class="p-2 bg-stone-900 hover:bg-stone-700 active:bg-stone-950 outline-pink rounded-xl"
		>
			<Icon icon={trashBinMinimalisticLinear} height={20} />
		</button>
	</div>
</div>
