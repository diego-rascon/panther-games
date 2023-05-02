<script lang="ts">
	import { fade, scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';
	import InputError from '../utils/InputError.svelte';

	export let cancelHandler: () => void;
	export let confirmHandler: () => void;
	export let name: string;
	export let email: string;
	export let phone: string;

	let inputError = false;
	let errorMessage: string;

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

	let confirmationVisible = false;

	const toggleConfirmation = () => {
		confirmationVisible = !confirmationVisible;
	};
</script>

{#if confirmationVisible}
	<ConfirmDialog
		cancelHandler={toggleConfirmation}
		confirmHandler={addProduct}
		title="Confirmar Registro"
		text="¿Está seguro de que desea registrar al nuevo cliente?"
	/>
{:else}
	<div
		class="flex flex-col p-8 space-y-4 bg-stone-950 border border-stone-800 rounded-xl transition-all"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle text="Registrar Cliente" />
		<input bind:value={name} type="text" class="input" placeholder="Nombre" />
		<input bind:value={email} type="text" class="input" placeholder="Correo" />
		<input bind:value={phone} type="text" class="input" placeholder="Teléfono" />
		{#if inputError}
			<InputError text={errorMessage} />
		{/if}
		<div class="grid grid-cols-2 gap-4">
			<button class="btn variant-ringed-primary" on:click={cancelHandler}>Cancelar</button>
			<button class="btn variant-filled-primary font-bold" on:click={toggleConfirmation}>
				Confirmar
			</button>
		</div>
	</div>
{/if}
