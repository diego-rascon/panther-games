<script lang="ts">
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticOutline from '@iconify/icons-solar/trash-bin-minimalistic-outline';
	import { supabase } from '$lib/db';

	type TotalHandler = () => void;
	type RemoveHandler = (cartId: number) => void;

	const removeFromCart = () => {
		removeHandler(id);
	};

	const updateQuantity = async (productId: number, quantity: number) => {
		await supabase
			.from('carrito')
			.update({ producto_cantidad: quantity })
			.eq('carrito_id', productId);
	};

	const quantityHandler = () => {
		updateQuantity(id, quantity);
		totalHandler();
	};

	export let totalHandler: TotalHandler;
	export let removeHandler: RemoveHandler;
	export let id: number;
	export let name: string;
	export let price: number;
	export let stock: number;

	let quantity: number;
</script>

<div class="p-4 bg-stone-800 rounded-xl space-y-2">
	<div class="flex justify-between">
		<p>{name}</p>
		<p>$ {price}</p>
	</div>
	<div class="flex justify-between">
		<select
			bind:value={quantity}
			on:change={quantityHandler}
			class="p-1 bg-stone-900 rounded-xl select-none"
		>
			{#each Array(stock) as _, index (index)}
				<option>{index + 1}</option>
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
