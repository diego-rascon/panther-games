<script lang="ts">
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';

	export let removeHandler: (cartId: number, productId: number) => void;
	export let quantityHandler: (cartId: number, quantity: number) => void;
	export let cartId: number;
	export let productId: number;
	export let name: string;
	export let price: number;
	export let stock: number;
	export let quantity: number;

	$: price *= quantity;
	$: formattedPrice = price.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
</script>

<div class="p-4 bg-stone-800 rounded-xl space-y-2">
	<div class="flex justify-between">
		<p class="line-clamp-2 w-32">{name}</p>
		<p class="mr-1 flex-shrink-0">{formattedPrice}</p>
	</div>
	<div class="flex justify-end space-x-2">
		<input
			type="number"
			class="input w-16"
			min="1"
			max={stock}
			bind:value={quantity}
			on:change={() => {
				if (quantity > stock) quantity = stock;
				quantityHandler(cartId, quantity);
			}}
		/>
		<button
			type="button"
			class="btn-icon hover:variant-soft"
			on:click={() => {
				removeHandler(cartId, productId);
			}}
		>
			<span>
				<Icon icon={trashBinMinimalisticLinear} height={20} />
			</span>
		</button>
	</div>
</div>
