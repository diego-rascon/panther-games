<script lang="ts">
	import { scale } from 'svelte/transition';
	import { supabase } from '$lib/db';
	import SectionTitle from '../titles/SectionTitle.svelte';

	export let closeHandler: () => void;
	export let clientId: number;
	export let saleId: number;
	export let date: string;
	export let total: number;
	export let paymentType: string;
	export let quantity: number;

	$: formattedTotal = total.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	const fetchSaleDetails = async () => {
		const { data } = await supabase.rpc('get_sale_details', { input_id: saleId });
		return data ?? [];
	};

	const fetchClient = async () => {
		const { data } = await supabase
			.from('cliente')
			.select('cliente_nombre')
			.eq('cliente_id', clientId)
			.single();
		return data;
	};

	const saleDetailsPromise = fetchSaleDetails();
	const clientPromise = fetchClient();
</script>

<div
	class="flex flex-col p-8 w-full max-w-md max-h-[95%] space-y-8 bg-stone-950 border border-stone-800 rounded-xl"
	in:scale={{ duration: 150 }}
>
	<SectionTitle centered={true} text="Detalles de Venta #{saleId}" />
	<div class="flex flex-col space-y-4 overflow-y-auto">
		<div class="flex flex-col space-y-2">
			<div class="flex justify-between">
				<strong>Cliente</strong>
				{#await clientPromise}
					<p>...</p>
				{:then client}
					<p>{client?.cliente_nombre}</p>
				{/await}
			</div>
			<div class="flex justify-between">
				<strong>Fecha</strong>
				<p>{date}</p>
			</div>
		</div>
		<div class="flex flex-col space-y-4 overflow-y-auto">
			{#await saleDetailsPromise}
				<div class="placeholder animate-pulse p-11" />
			{:then saleDetails}
				{#each saleDetails as saleProduct}
					<div class="flex justify-between bg-stone-900 rounded-xl p-4 items-top">
						<div class="flex flex-col items-start space-y-2">
							<p class="">
								<strong>{saleProduct.producto_nombre}</strong>
								({saleProduct.venta_detalle_cantidad})
							</p>
							<div class="flex flex-row space-x-2">
								<p class="unstyled px-2 p-1 variant-soft-primary rounded-full text-xs">
									{saleProduct.categoria_nombre}
								</p>
								{#if saleProduct.categoria_nombre === 'Juego'}
									<p class="unstyled px-2 p-1 variant-soft-success rounded-full text-xs">
										{saleProduct.plataforma_nombre}
									</p>
								{/if}
							</div>
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
		<div class="flex flex-col space-y-2">
			<div class="flex justify-between">
				<strong>Método de pago</strong>
				<p>{paymentType}</p>
			</div>
			<div class="flex justify-between text-lg">
				<p class="unstyled font-bold">Total ({quantity})</p>
				<p class="unstyled">{formattedTotal}</p>
			</div>
		</div>
	</div>
	<button class="btn variant-ringed-primary" on:click={closeHandler}>Cerrar</button>
</div>
