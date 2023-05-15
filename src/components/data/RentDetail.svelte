<script lang="ts">
	import { scale } from 'svelte/transition';
	import { supabase } from '$lib/db';
	import SectionTitle from '../titles/SectionTitle.svelte';

	export let closeHandler: () => void;
	export let rentId: number;
	export let memberId: number;
	export let startDate: string;
	export let endDate: string;
	export let total: number;
	export let paymentType: string;
	export let quantity: number;

	$: formattedTotal = total.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	const fetchRentDetails = async () => {
		const { data } = await supabase.rpc('get_rent_details', { input_id: rentId });
		return data ?? [];
	};

	const fetchMembers = async () => {
		const { data } = await supabase.rpc('get_clients_members').eq('miembro_id', memberId).single();
		return data;
	};

	const rentDetailsPromise = fetchRentDetails();
	const memberPromise: any = fetchMembers();
</script>

<div
	class="flex flex-col p-8 w-full max-w-md max-h-[95%] space-y-8 bg-stone-950 border border-stone-800 rounded-xl"
	in:scale={{ duration: 150 }}
>
	<SectionTitle centered={true} text="Detalles de Renta #{rentId}" />
	<div class="flex flex-col space-y-4 overflow-y-auto">
		<div class="flex flex-col space-y-2">
			<div class="flex justify-between">
				<strong>Miembro</strong>
				{#await memberPromise}
					<p>...</p>
				{:then member}
					<p>{member?.cliente_nombre}</p>
				{/await}
			</div>
			<div class="flex justify-between">
				<strong>Fecha de inicio</strong>
				<p>{startDate}</p>
			</div>
			<div class="flex justify-between">
				<strong>Fecha de entrega</strong>
				<p>{endDate}</p>
			</div>
		</div>
		<div class="flex flex-col space-y-4 overflow-y-auto">
			{#await rentDetailsPromise}
				<div class="placeholder animate-pulse p-7" />
			{:then rentDetails}
				{#each rentDetails as rentDetail}
					<strong class="flex justify-between bg-stone-900 rounded-xl p-4 items-top">
						{rentDetail.producto_nombre}
					</strong>
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
