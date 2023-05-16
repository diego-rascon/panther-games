<script lang="ts">
	import { scale } from 'svelte/transition';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import Icon from '@iconify/svelte';
	import userOutline from '@iconify/icons-solar/user-outline';
	import letterOutline from '@iconify/icons-solar/letter-outline';
	import phoneCallingRoundedOutline from '@iconify/icons-solar/phone-calling-rounded-outline';
	import userIdOutline from '@iconify/icons-solar/user-id-outline';
	import keyLinear from '@iconify/icons-solar/key-linear';
	import SectionSubtitle from '../titles/SectionSubtitle.svelte';
	import InputError from '../utils/InputError.svelte';
	import { RadioGroup, RadioItem } from '@skeletonlabs/skeleton';

	export let editing = false;
	export let cancelHandler: () => void;
	export let confirmHandler: () => void;
	export let name: string;
	export let email: string;
	export let phone: string;
	export let userName: string;
	export let password: string;
	let passwordConfirmation: string;
	let permissions = 1;
	export let reader: boolean;
	export let admin: boolean;

	$: {
		switch (permissions) {
			case 0:
				reader = true;
				admin = false;
				break;
			case 1:
				reader = false;
				admin = true;
		}
	}

	let inputError = false;
	let errorMessage: string;

	const namePattern = /^[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]*$/;
	const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	const phonePattern = /^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$/;
	const userNamePattern = /^[a-zA-Z0-9_-]{3,20}$/;
	const passwordPattern = /^[A-Za-z\d@$!%*?&]{4,}$/;

	const validInput = () => {
		if (!name || !namePattern.test(name)) {
			errorMessage = 'El nombre del usuario no es válido.';
			return false;
		} else if (!email || !emailPattern.test(email)) {
			errorMessage = 'El correo del usuario no es válido.';
			return false;
		} else if (!phone || !phonePattern.test(phone)) {
			errorMessage = 'El teléfono del usuario no es válido.';
			return false;
		} else if (!editing && (!userName || !userNamePattern.test(userName))) {
			errorMessage =
				'Los nombres de usuario tienen que ser de entre 3 y 20 carácteres y solo pueden contener carácteres alfanuméricos y guiones.';
			return false;
		} else if (!editing && (!password || !passwordPattern.test(password))) {
			errorMessage =
				'Las contraseñas tienen que ser de mínimo 4 carácteres y solo pueden tener letras, números, carácteres especiales.';
			return false;
		} else if (!editing && password !== passwordConfirmation) {
			errorMessage = 'Las contraseñas introducidas no coinciden.';
			return false;
		}
		return true;
	};

	const addUser = () => {
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
		confirmHandler={addUser}
		title={editing ? 'Confirmar Edición' : 'Confirmar Registro'}
		text={editing
			? '¿Está seguro de que desea editar al usuario?'
			: '¿Está seguro de que desea registrar al nuevo usuario?'}
	/>
{:else}
	<div
		class="flex flex-col p-8 w-full max-w-md max-h-[95%] space-y-8 bg-stone-950 border border-stone-800 rounded-xl transition-all overflow-y-auto"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle centered={true} text="{editing ? 'Editar' : 'Registrar'} Usuario" />
		<div class="flex flex-col space-y-4">
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
			{#if !editing}
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={userIdOutline} height={24} /></div>
					<input bind:value={userName} type="text" class="input" placeholder="Nombre de usuario" />
				</div>
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={keyLinear} height={24} /></div>
					<input bind:value={password} type="password" class="input" placeholder="Contraseña" />
				</div>
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={keyLinear} height={24} /></div>
					<input
						bind:value={passwordConfirmation}
						type="password"
						class="input"
						placeholder="Confirmar contraseña"
					/>
				</div>
				<SectionSubtitle text="Permisos" />
				<RadioGroup class="justify-center" active="variant-filled-primary">
					<RadioItem bind:group={permissions} name="justify" value={0}>Lector</RadioItem>
					<RadioItem bind:group={permissions} name="justify" value={1}>Administrador</RadioItem>
				</RadioGroup>
			{/if}
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
