<script lang="ts">
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticOutline from '@iconify/icons-solar/trash-bin-minimalistic-outline';

	type RemoveHandler = (cartId: number) => void;
	type QuantityHandler = (cartId: number, quantity: number) => void;

	const removeFromCart = () => {
		removeHandler(id);
	};

	const updateQuantity = () => {
		quantityHandler(id, quantity);
	}

	export let removeHandler: RemoveHandler;
	export let quantityHandler: QuantityHandler;
	export let id: number;
	export let name: string;
	export let price: number;
	export let quantity: number;
	export let stock: number;
</script>

<div class="p-4 bg-stone-800 rounded-xl space-y-2">
	<div class="flex justify-between">
		<p>{name}</p>
		<p>$ {price}</p>
	</div>
	<div class="flex justify-between">
		<select on:change={updateQuantity} class="p-1 bg-stone-900 rounded-xl select-none">
			{#each Array(stock) as _, index (index)}
				<option>{quantity}</option>
			{/each}
		</select>
		<button
			on:click={removeFromCart}
			class="p-1 bg-stone-900 hover:bg-stone-700 active:bg-stone-950 rounded-xl"
		>
			<Icon icon={trashBinMinimalisticOutline} height={20} />
		</button>
	</div>
</div>
