<script lang="ts">
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';

	type RemoveHandler = (cartId: number) => void;
	type QuantityHandler = (cartId: number, quantity: number) => void;

	export let removeHandler: RemoveHandler;
	export let quantityHandler: QuantityHandler;
	export let id: number;
	export let name: string;
	export let price: number;
	export let stock: number;
	export let quantity: number;
</script>

<div class="p-4 bg-stone-800 rounded-xl space-y-2">
	<div class="flex justify-between">
		<p class="line-clamp-4 w-32">{name}</p>
		<p>$ {quantity * price}</p>
	</div>
	<div class="flex justify-end space-x-2">
		<input
			type="number"
			min="1"
			max={stock}
			bind:value={quantity}
			on:change={() => {
				quantityHandler(id, quantity);
			}}
			class="w-12 px-2 py-1 bg-stone-900 outline-pink rounded-xl select-none"
		/>
		<button
			on:click={() => {
				removeHandler(id);
			}}
			class="px-2 py-1 bg-stone-900 hover:bg-stone-700 active:bg-stone-950 outline-pink rounded-xl"
		>
			<Icon icon={trashBinMinimalisticLinear} height={20} />
		</button>
	</div>
</div>
