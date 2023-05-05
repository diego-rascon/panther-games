<script lang="ts">
	import { scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';
	import InputError from '../utils/InputError.svelte';
	import { SlideToggle } from '@skeletonlabs/skeleton';
	import textCircleOutline from '@iconify/icons-solar/text-circle-outline';
	import dollarMinimalisticLinear from '@iconify/icons-solar/dollar-minimalistic-linear';
	import archiveDownMinimlisticOutline from '@iconify/icons-solar/archive-down-minimlistic-outline';
	import Icon from '@iconify/svelte';

	export let cancelHandler: () => void;
	export let confirmHandler: (productId: number) => void;
	export let productId: number;
	export let categoryId: number;
	export let platformId: number;
	export let platforms: any;
	export let name: string;
	export let price: number | undefined;
	export let minimumStock: number | undefined;
	export let used: boolean;

	let inputError = false;
	let errorMessage: string;

	const validInput = (): boolean => {
		if (!name) {
			errorMessage = 'El nombre del producto no es válido.';
			return false;
		} else if (!price || price < 1) {
			errorMessage = 'El precio del producto no es válido.';
			return false;
		} else if (!minimumStock || minimumStock < 1) {
			errorMessage = 'El stock mínimo del producto no es válido.';
			return false;
		} else {
			return true;
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
		confirmHandler={() => {
			if (validInput()) {
				confirmHandler(productId);
			} else {
				inputError = true;
				toggleConfirmation();
			}
		}}
		title="Confirmar Edición"
		text="¿Está seguro de que desea editar el producto?"
	/>
{:else}
	<div
		class="flex flex-col p-8 space-y-4 bg-stone-950 border border-stone-800 rounded-xl transition-all"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle text="Editar Producto" />
		{#if categoryId === 1}
			<select class="input" bind:value={platformId}>
				{#each platforms as platform}
					<option value={platform.plataforma_id}>{platform.plataforma_nombre}</option>
				{/each}
			</select>
		{/if}
		<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
			<div class="input-group-shim"><Icon icon={textCircleOutline} height={24} /></div>
			<input type="text" bind:value={name} class="input" placeholder="Nombre" />
		</div>
		<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
			<div class="input-group-shim"><Icon icon={dollarMinimalisticLinear} height={24} /></div>
			<input type="number" bind:value={price} class="input" placeholder="Precio" />
		</div>
		<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
			<div class="input-group-shim"><Icon icon={archiveDownMinimlisticOutline} height={24} /></div>
			<input type="number" bind:value={minimumStock} class="input" placeholder="Mínimo de stock" />
		</div>
		<SlideToggle bind:checked={used} name="slider-sm" active="bg-primary-500" size="sm">
			Producto usado
		</SlideToggle>
		{#if inputError}
			<InputError text={errorMessage} />
		{/if}
		<div class="grid grid-cols-2 gap-4">
			<button class="btn variant-ringed-primary" on:click={cancelHandler}> Cancelar </button>
			<button class="btn variant-filled-primary font-bold" on:click={toggleConfirmation}>
				Confirmar
			</button>
		</div>
	</div>
{/if}
