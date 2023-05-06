<script lang="ts">
	import { fade, scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';
	import InputError from '../utils/InputError.svelte';
	import Icon from '@iconify/svelte';
	import userOutline from '@iconify/icons-solar/user-outline';
	import letterOutline from '@iconify/icons-solar/letter-outline';
	import phoneCallingRoundedOutline from '@iconify/icons-solar/phone-calling-rounded-outline';
	export let editing = false;
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
		title={editing ? 'Confirmar Edición' : 'Confirmar Registro'}
		text={editing
			? '¿Está seguro de que desea editar al cliente?'
			: '¿Está seguro de que desea registrar al nuevo cliente?'}
	/>
{:else}
	<div
		class="flex flex-col p-8 w-full max-w-md space-y-8 bg-stone-950 border border-stone-800 rounded-xl transition-all"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle centered={true} text={editing ? 'Editar Cliente' : 'Registrar Cliente'} />
		<div class="space-y-4">
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={userOutline} height={24} /></div>
				<input bind:value={name} type="text" class="input" placeholder="Nombre" />
			</div>
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={letterOutline} height={24} /></div>
				<input bind:value={email} type="text" class="input" placeholder="Correo" />
			</div>
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={phoneCallingRoundedOutline} height={24} /></div>
				<input bind:value={phone} type="text" class="input" placeholder="Teléfono" />
			</div>
			{#if inputError}
				<InputError text={errorMessage} />
			{/if}
		</div>
		<div class="grid grid-cols-2 gap-4">
			<button class="btn variant-ringed-primary" on:click={cancelHandler}>Cancelar</button>
			<button class="btn variant-filled-primary font-bold" on:click={toggleConfirmation}>
				Confirmar
			</button>
		</div>
	</div>
{/if}
