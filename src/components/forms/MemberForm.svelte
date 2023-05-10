<script lang="ts">
	import { scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import SectionSubtitle from '../titles/SectionSubtitle.svelte';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';
	import InputError from '../utils/InputError.svelte';
	import Icon from '@iconify/svelte';
	import userOutline from '@iconify/icons-solar/user-outline';
	import letterOutline from '@iconify/icons-solar/letter-outline';
	import phoneCallingRoundedOutline from '@iconify/icons-solar/phone-calling-rounded-outline';
	import calendarOutline from '@iconify/icons-solar/calendar-outline';
	import wadOfMoneyOutline from '@iconify/icons-solar/wad-of-money-outline';
	import cashOutOutline from '@iconify/icons-solar/cash-out-outline';
	import { RadioGroup, RadioItem } from '@skeletonlabs/skeleton';

	export let editing = false;
	export let cancelHandler: () => void;
	export let confirmHandler: () => void;
	export let clients: { [x: string]: any }[];
	export let newClient: boolean;
	export let clientId: number | undefined;
	export let name: string;
	export let email: string;
	export let phone: string;
	export let date: string;
	export let startDate: string;

	date = startDate;

	let cashPayment = true;
	let payment: number;
	let total = 300;
	let inputError = false;
	let errorMessage: string;

	const namePattern = /^[a-zA-ZáéíóúñÁÉÍÓÚÑ\s]*$/;
	const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	const phonePattern = /^\(?([0-9]{3})\)?[-.●]?([0-9]{3})[-.●]?([0-9]{4})$/;

	$: formattedTotal = total.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	const validInput = (): boolean => {
		if ((!editing && cashPayment && !payment) || payment < total) {
			errorMessage = 'La cantidad de efectivo introducia no es válida';
			return false;
		}
		if (newClient) {
			if (!name || !namePattern.test(name)) {
				errorMessage = 'El nombre del miembro no es válido';
				return false;
			} else if (!email || !emailPattern.test(email)) {
				errorMessage = 'El correo del miembro no es válido.';
				return false;
			} else if (!phone || !phonePattern.test(phone)) {
				errorMessage = 'El teléfono del miembro no es válido.';
				return false;
			}
		}
		return true;
	};

	const addMember = () => {
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
		confirmHandler={addMember}
		title={editing ? 'Confirmar Edición' : 'Confirmar Registro'}
		text={editing
			? '¿Está seguro de que desea editar al miembro?'
			: '¿Está seguro de que desea registrar al nuevo miembro?'}
	/>
{:else}
	<div
		class="flex flex-col p-8 w-full max-w-md max-h-[95%] space-y-8 bg-stone-950 border border-stone-800 rounded-xl transition-all overflow-y-auto"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle centered={true} text={editing ? 'Editar Miembro' : 'Registrar Miembro'} />
		<div class="flex flex-col space-y-4">
			{#if !editing}
				<RadioGroup class="justify-center" active="variant-filled-primary">
					<RadioItem bind:group={newClient} name="justify" value={true}>Nuevo cliente</RadioItem>
					<RadioItem bind:group={newClient} name="justify" value={false}
						>Cliente existente</RadioItem
					>
				</RadioGroup>
			{/if}
			{#if newClient || editing}
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
			{:else}
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={userOutline} height={24} /></div>
					<select class="select" bind:value={clientId}>
						{#each clients as client}
							<option value={client.cliente_id}>{client.cliente_nombre}</option>
						{/each}
					</select>
				</div>
			{/if}
			{#if !editing}
				<SectionSubtitle text="Fecha inicial" />
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={calendarOutline} height={24} /></div>
					<input bind:value={date} type="date" class="input" placeholder="Fecha inicial" />
				</div>
			{/if}
			{#if !editing}
				<SectionSubtitle text="Pago" />
				<RadioGroup class="justify-center" active="variant-filled-primary">
					<RadioItem bind:group={cashPayment} name="justify" value={true}>Efectivo</RadioItem>
					<RadioItem bind:group={cashPayment} name="justify" value={false}>Tarjeta</RadioItem>
				</RadioGroup>
				{#if cashPayment}
					<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
						<div class="input-group-shim"><Icon icon={wadOfMoneyOutline} height={24} /></div>
						<input
							bind:value={payment}
							type="number"
							min="0"
							class="input"
							placeholder="Cantidad"
						/>
					</div>
					<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
						<div class="input-group-shim"><Icon icon={cashOutOutline} height={24} /></div>
						<input
							class="input"
							type="number"
							placeholder="Cambio"
							value={payment - total < 0 ? null : payment - total}
							readonly
						/>
					</div>
				{/if}
				<div class="flex justify-between text-lg">
					<p class="unstyled font-bold">Total</p>
					<p class="unstyled">{formattedTotal}</p>
				</div>
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
