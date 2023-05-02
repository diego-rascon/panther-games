<script lang="ts">
	import { fade, scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';

	export let cancelHandler: () => void;
	export let confirmHandler: () => void;
	export let title: string;
	export let text: string;
</script>

<div
	class="flex flex-col p-8 space-y-4 bg-stone-950 border border-stone-800 rounded-xl"
	in:scale={{ duration: 150 }}
>
	<SectionTitle centered={true} text={title} />
	<p>{text}</p>
	<div class="grid grid-cols-2 gap-4">
		<button class="btn variant-ringed-primary" on:click={cancelHandler}> Cancelar </button>
		<button class="btn variant-filled-primary font-bold" on:click={confirmHandler}>
			Confirmar
		</button>
	</div>
</div>
