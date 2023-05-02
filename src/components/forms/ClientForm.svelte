<script lang="ts">
	import { fade, scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import ConfirmDialog from '../modals/confirmDialog.svelte';
	import InputError from '../utils/InputError.svelte';

	export let cancelHandler: () => void;
	export let confirmHandler: () => void;
	export let name: string;
	export let email: string;
	export let phone: string;

	const animDuration = 150;

	let confirmationVisible = false;

	const toggleConfirmation = () => {
		confirmationVisible = !confirmationVisible;
	};

	const namePattern = /^[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]*$/;
	const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	const phonePattern = /^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$/;

	const validInput = (): boolean => {
		if (!name || !namePattern.test(name)) {
			errorMessage = 'El nombre del cliente no es válido';
			return false;
		} else if (!email || !emailPattern.test(email)) {
			errorMessage = 'El correo del cliente no es válido.';
			return false;
		} else if (!phone || !phonePattern.test(phone)) {
			errorMessage = 'El teléfono del cliente no es válido.';
			return false;
		} else {
			return true;
		}
	};

	const addProduct = () => {
		if (validInput()) {
			confirmHandler();
		} else {
			inputError = true;
			toggleConfirmation();
		}
	};

	let inputError = false;
	let errorMessage: string;
</script>

<div
	class="fixed inset-0 flex justify-center items-center bg-black transition-all bg-opacity-75"
	transition:fade={{ duration: animDuration }}
>
	<div
		class="flex flex-col p-8 space-y-8 bg-stone-950 border border-stone-700 rounded-xl transition-all"
		transition:scale={{ duration: animDuration }}
	>
		<SectionTitle text="Registrar Cliente" />
		<div class="flex flex-col space-y-4 transition-all">
			<input
				type="text"
				required
				bind:value={name}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Nombre"
			/>
			<input
				type="text"
				required
				bind:value={email}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Correo"
			/>
			<input
				type="text"
				required
				bind:value={phone}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Teléfono"
			/>
			{#if inputError}
				<InputError text={errorMessage} />
			{/if}
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
				on:click={toggleConfirmation}
			>
				Confirmar
			</button>
		</div>
	</div>
</div>
{#if confirmationVisible}
	<ConfirmDialog
		cancelHandler={toggleConfirmation}
		confirmHandler={addProduct}
		title="Confirmar Registro"
		text="¿Está seguro de que desea registrar el nuevo producto?"
	/>
{/if}
