<script lang="ts">
	import { fade, scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';

	type ClickHandler = () => void;

	export let cancelHandler: ClickHandler;
	export let confirmHandler: ClickHandler;
	export let name: string;
	export let email: string;
	export let phone: string;

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
		<SectionTitle text="Registrar Cliente" />
		<div class="flex flex-col space-y-4">
			<input
				type="text"
				required
				bind:value={name}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Nombre"
			/>
			<input
				type="email"
				required
				bind:value={email}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Correo"
			/>
			<input
				type="tel"
				required
				bind:value={phone}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Teléfono"
			/>
		</div>
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
