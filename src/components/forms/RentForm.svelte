<script lang="ts">
	import Icon from '@iconify/svelte';
	import userOutline from '@iconify/icons-solar/user-outline';
	import wadOfMoneyOutline from '@iconify/icons-solar/wad-of-money-outline';
	import cashOutOutline from '@iconify/icons-solar/cash-out-outline';
	import { RadioGroup, RadioItem, SlideToggle } from '@skeletonlabs/skeleton';
	import SectionSubtitle from '../titles/SectionSubtitle.svelte';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import InputError from '../utils/InputError.svelte';
	import { scale } from 'svelte/transition';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';

	export let cancelHandler: () => void;
	export let confirmHandler: (clientId: number, saleCard: boolean) => void;
	export let clients: { [x: string]: any }[];
	export let cartQuantity: number;

	$: rentTotal = duration === 3 ? 100 * cartQuantity : 200 * cartQuantity;
	$: formattedPrice = rentTotal.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	let genericClient = true;
	let clientId: number;
	let duration: number = 3;
	let cashPayment = true;
	let payment: number;

	let inputError = false;
	let errorMessage: string;

	const validInput = (): boolean => {
		if ((cashPayment && !payment) || payment < rentTotal) {
			errorMessage = 'La cantidad de efectivo introducia no es válida';
			return false;
		} else {
			return true;
		}
	};

	const registerSale = () => {
		if (validInput()) {
			confirmHandler(genericClient ? 1 : clientId, cashPayment);
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
		confirmHandler={registerSale}
		title="Confirmar venta"
		text="¿Está seguro de que desea registrar la venta?"
	/>
{:else}
	<div
		class="flex flex-col p-8 w-full max-w-md max-h-[95%] space-y-8 bg-stone-950 border border-stone-800 rounded-xl overflow-y-auto"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle centered={true} text="Realizar Renta" />
		<div class="flex flex-col space-y-4">
			<SectionSubtitle text="Miembro" />
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={userOutline} height={24} /></div>
				<select class="select" bind:value={clientId}>
					{#each clients as client}
						<option value={client.cliente_id}>{client.cliente_nombre}</option>
					{/each}
				</select>
			</div>
			<SectionSubtitle text="Duración" />
			<RadioGroup class="justify-center" active="variant-filled-primary">
				<RadioItem bind:group={duration} name="justify" value={3}>3 días</RadioItem>
				<RadioItem bind:group={duration} name="justify" value={7}>7 días</RadioItem>
			</RadioGroup>
			<SectionSubtitle text="Pago" />
			<RadioGroup class="justify-center" active="variant-filled-primary">
				<RadioItem bind:group={cashPayment} name="justify" value={true}>Efectivo</RadioItem>
				<RadioItem bind:group={cashPayment} name="justify" value={false}>Tarjeta</RadioItem>
			</RadioGroup>
			{#if cashPayment}
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={wadOfMoneyOutline} height={24} /></div>
					<input bind:value={payment} type="number" min="0" class="input" placeholder="Cantidad" />
				</div>
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={cashOutOutline} height={24} /></div>
					<input
						class="input"
						type="number"
						placeholder="Cambio"
						value={payment - rentTotal < 0 ? null : payment - rentTotal}
						readonly
					/>
				</div>
			{/if}
			<div class="flex justify-between text-lg">
				<p class="unstyled font-bold">Total ({cartQuantity})</p>
				<p class="unstyled">{formattedPrice}</p>
			</div>
			<SlideToggle name="slider-sm" checked active="bg-primary-500" size="sm">
				Generar comprobante
			</SlideToggle>
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
