<script lang="ts">
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';

	export let removeHandler: (cartId: number, productId: number) => void;
	export let quantityHandler: (cartId: number, quantity: number) => void;
	export let rent: boolean;
	export let cartId: number;
	export let productId: number;
	export let categoryId: number;
	export let categoryName: string;
	export let platformName: string;
	export let name: string;
	export let newProduct: boolean;
	export let price: number;
	export let stock: number;
	export let quantity: number;

	$: quantity = rent ? 1 : quantity;
	$: formattedPrice = (price * quantity).toLocaleString('en-US', {
		style: 'currency',
		currency: 'USD'
	});
</script>

<div class="p-4 bg-stone-800 rounded-xl space-y-2">
	<div class="flex justify-between">
		<p class="line-clamp-2">{name}</p>
		{#if !rent}
			<p class="mr-2 flex-shrink-0">{formattedPrice}</p>
		{/if}
	</div>
	<div class="flex flex-col space-y-1 items-start">
		<div class="flex space-x-2">
			{#if !rent || categoryId !== 1}
				<p class="unstyled px-2 p-1 variant-soft-primary rounded-full text-xs">{categoryName}</p>
			{/if}
			{#if !newProduct}
				<p class="unstyled px-2 p-1 variant-soft-warning rounded-full text-xs">Usado</p>
			{/if}
		</div>
		{#if (!rent && categoryId === 1) || (rent && categoryId === 1 && platformName !== 'Switch')}
			<p class="unstyled flex px-2 p-1 variant-soft-success rounded-full text-xs">{platformName}</p>
		{/if}
	</div>
	<div class="flex justify-end space-x-2">
		{#if !rent}
			<input
				type="number"
				class="input h-9 text-sm w-16 variant-filled-surface"
				min="1"
				max={stock}
				bind:value={quantity}
				on:change={() => {
					if (quantity > stock) quantity = stock;
					quantityHandler(cartId, quantity);
				}}
			/>
		{/if}
		<button
			type="button"
			class="btn variant-filled-surface p-2 rounded-full"
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
