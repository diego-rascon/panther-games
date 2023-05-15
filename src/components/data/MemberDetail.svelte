<script lang="ts">
	import { scale } from 'svelte/transition';
	import { supabase } from '$lib/db';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import dayjs from 'dayjs';

	export let closeHandler: () => void;
	export let memberId: number;

	const fetchMemberDetails = async () => {
		const { data } = await supabase.from('miembro').select().eq('miembro_id', memberId).single();
		return data;
	};

	let memberDetailesPromise = fetchMemberDetails();
</script>

<div
	class="flex flex-col p-8 w-full max-w-md max-h-[95%] space-y-8 bg-stone-950 border border-stone-800 rounded-xl"
	in:scale={{ duration: 150 }}
>
	<SectionTitle centered={true} text="Detalles del Miembro" />
	<div class="flex flex-col space-y-2 overflow-y-auto">
		{#await memberDetailesPromise}
			<p class="text-center text-xl">Miembro desde --/--/----</p>
			<div class="flex justify-between text-lg">
				<p class="unstyled font-bold">Compras</p>
				<p>...</p>
			</div>
			<div class="flex justify-between text-lg">
				<p class="unstyled font-bold">Rentas</p>
				<p>...</p>
			</div>
		{:then memberDetails}
			<p class="text-center text-xl">
				Miembro desde {dayjs(memberDetails?.miembro_fecha_original).format('DD/MM/YYYY')}
			</p>
			<div class="flex justify-between text-lg">
				<p class="unstyled font-bold">Compras</p>
				<p class="unstyled">{memberDetails?.miembro_compras}</p>
			</div>
			<div class="flex justify-between text-lg">
				<p class="unstyled font-bold">Rentas</p>
				<p class="unstyled">{memberDetails?.miembro_rentas}</p>
			</div>
		{/await}
	</div>
	<button class="btn variant-ringed-primary" on:click={closeHandler}>Cerrar</button>
</div>
