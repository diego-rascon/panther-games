<script lang="ts">
	import dollarMinimalisticLinear from '@iconify/icons-solar/dollar-minimalistic-linear';
	import refreshCircleOutline from '@iconify/icons-solar/refresh-circle-outline';
	import Icon from '@iconify/svelte';

	import { SlideToggle } from '@skeletonlabs/skeleton';
	import SectionSubtitle from '../titles/SectionSubtitle.svelte';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import { scale } from 'svelte/transition';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';

	export let cancelHandler: () => void;
	export let confirmHandler: () => void;
	export let clients: { [x: string]: any }[];
	export let cartTotal: number;
	export let cartQuantity: number;

	let genericClient = true;
	let paymentType: string;
	let payment: number;

	let confirmationVisible = false;

	const toggleConfirmation = () => {
		confirmationVisible = !confirmationVisible;
	};
</script>

{#if confirmationVisible}
	<ConfirmDialog
		cancelHandler={toggleConfirmation}
		{confirmHandler}
		title="Confirmar venta"
		text="¿Está seguro de que desea registrar la venta?"
	/>
{:else}
	<div
		class="flex flex-col p-8 w-full max-w-md space-y-8 bg-stone-950 border border-stone-800 rounded-xl"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle centered={true} text="Realizar Venta" />
		<div class="space-y-4">
			<SectionSubtitle text="Cliente" />
			<SlideToggle bind:checked={genericClient} name="slider-sm" active="bg-primary-500" size="sm">
				Cliente genérico
			</SlideToggle>
			{#if !genericClient}
				<select class="select">
					{#each clients as client}
						<option value={client.cliente_id}>{client.cliente_nombre}</option>
					{/each}
				</select>
			{/if}
			<SectionSubtitle text="Pago" />
			<select bind:value={paymentType} class="select">
				<option value="Efectivo">Efectivo</option>
				<option value="Tarjeta">Tarjeta</option>
			</select>
			{#if paymentType === 'Efectivo'}
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={dollarMinimalisticLinear} height={24} /></div>
					<input bind:value={payment} type="number" min="0" class="input" placeholder="Cantidad" />
				</div>
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={refreshCircleOutline} height={24} /></div>
					<input
						class="input"
						type="number"
						placeholder="Cambio"
						value={payment - cartTotal < 0 ? null : payment - cartTotal}
						readonly
					/>
				</div>
			{/if}
			<div class="flex justify-between text-lg">
				<p class="unstyled font-bold">Total ({cartQuantity})</p>
				<p class="unstyled">$ {cartTotal}</p>
			</div>
			<SlideToggle name="slider-sm" checked active="bg-primary-500" size="sm">
				Generar comprobante
			</SlideToggle>
		</div>
		<div class="grid grid-cols-2 gap-4">
			<button class="btn variant-ringed-primary" on:click={cancelHandler}> Cancelar </button>
			<button class="btn variant-filled-primary font-bold" on:click={toggleConfirmation}>
				Confirmar
			</button>
		</div>
	</div>
{/if}
