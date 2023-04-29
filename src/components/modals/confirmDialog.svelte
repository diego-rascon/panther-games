<script lang="ts">
	import { fade, scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';

	export let cancelHandler: () => void;
	export let confirmHandler: () => void;
	export let title: string;
	export let text: string;

	const animDuration = 150;
</script>

<div
	class="fixed inset-0 flex justify-center items-center bg-black transition-all bg-opacity-75"
	transition:fade={{ duration: animDuration }}
>
	<div
		class="flex flex-col p-8 space-y-8 bg-stone-950 border border-stone-700 rounded-xl"
		transition:scale={{ duration: animDuration }}
	>
		<SectionTitle centered={true} text={title} />
		<p>{text}</p>
		<div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
			<button
				class="py-2 border-2 border-pink-600 hover:bg-stone-900 active:bg-black outline-none focus:outline-pink-600 rounded-xl transition-all select-none"
				on:click={cancelHandler}
			>
				Cancelar
			</button>
			<button
				class="py-2 btn-fill font-bold rounded-xl transition-all select-none"
				on:click={confirmHandler}
			>
				Confirmar
			</button>
		</div>
	</div>
</div>
