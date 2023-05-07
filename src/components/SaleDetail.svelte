<script lang="ts">
	import { scale } from 'svelte/transition';
	import SectionTitle from './titles/SectionTitle.svelte';
	import { supabase } from '$lib/db';

	export let closeHandler: () => void;
	export let saleId: number;
	export let total: number;
	export let quantity: number;

	$: formattedTotal = total.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	const fetchSaleDetails = async () => {
		const { data } = await supabase.rpc('get_sale_details', { input_id: saleId });
		return data ?? [];
	};

	let saleDetailsPromise = fetchSaleDetails();
</script>

<div
	class="flex flex-col p-8 w-full max-w-md max-h-[90%] space-y-4 bg-stone-950 border border-stone-800 rounded-xl"
	in:scale={{ duration: 150 }}
>
	<SectionTitle centered={true} text="Detalles de Venta" />
	<div class="pt-4 flex flex-col space-y-4 overflow-y-auto">
		{#await saleDetailsPromise}
			<p>Loading...</p>
		{:then saleDetails}
			{#each saleDetails as saleProduct}
				<div class="flex justify-between bg-stone-900 rounded-xl p-4 items-top">
					<div class="flex flex-col items-start space-y-2">
						<p class="">
							<strong>{saleProduct.producto_nombre}</strong>
							({saleProduct.venta_detalle_cantidad})
						</p>
						{#if saleProduct.categoria_nombre === 'Juego'}
							<p class="unstyled px-2 p-1 variant-soft-success rounded-full text-xs">
								{saleProduct.plataforma_nombre}
							</p>
						{/if}
						<p class="unstyled px-2 p-1 variant-soft-primary rounded-full text-xs">
							{saleProduct.categoria_nombre}
						</p>
					</div>
					<p class=" flex-shrink-0">
						{saleProduct.producto_precio.toLocaleString('en-US', {
							style: 'currency',
							currency: 'USD'
						})}
					</p>
				</div>
			{/each}
		{/await}
	</div>
	<div class="flex justify-between text-lg pb-4">
		<p class="unstyled font-bold">Total ({quantity})</p>
		<p class="unstyled">{formattedTotal}</p>
	</div>
	<button class="btn variant-ringed-primary" on:click={closeHandler}>Cerrar</button>
</div>
