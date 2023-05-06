<script lang="ts">
	import SectionTitle from '../titles/SectionTitle.svelte';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';
	import InputError from '../utils/InputError.svelte';
	import { SlideToggle } from '@skeletonlabs/skeleton';
	import Icon from '@iconify/svelte';
	import tagOutline from '@iconify/icons-solar/tag-outline';
	import gameboyOutline from '@iconify/icons-solar/gameboy-outline';
	import textCircleOutline from '@iconify/icons-solar/text-circle-outline';
	import tagPriceOutline from '@iconify/icons-solar/tag-price-outline';
	import boxOutline from '@iconify/icons-solar/box-outline';
	import archiveDownMinimlisticOutline from '@iconify/icons-solar/archive-down-minimlistic-outline';
	import { scale } from 'svelte/transition';

	export let editing = false;
	export let cancelHandler: () => void;
	export let confirmHandler: () => void;
	export let categories: any;
	export let platforms: any;
	export let categoryId: number;
	export let platformId: number;
	export let name: string;
	export let price: number | undefined;
	export let stock: number | undefined;
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
		} else if (!stock || stock < 1) {
			errorMessage = 'El stock del producto no es válido.';
			return false;
		} else if (!minimumStock || minimumStock < 1 || minimumStock >= stock) {
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
				confirmHandler();
			} else {
				inputError = true;
				toggleConfirmation();
			}
		}}
		title={editing ? 'Editar Registro' : 'Confirmar Registro'}
		text={editing
			? '¿Está seguro de que desea editar al producto?'
			: '¿Está seguro de que desea registrar el nuevo producto?'}
	/>
{:else}
	<div
		class="flex flex-col p-8 w-full max-w-md space-y-8 bg-stone-950 border border-stone-800 rounded-xl transition-all"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle centered={true} text={editing ? 'Editar Producto' : 'Registrar Producto'} />
		<div class="space-y-4">
			{#if !editing}
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={tagOutline} height={24} /></div>
					<select class="select" bind:value={categoryId}>
						{#each categories as category}
							<option value={category.categoria_id}>{category.categoria_nombre}</option>
						{/each}
					</select>
				</div>
			{/if}
			{#if categoryId === 1}
				<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
					<div class="input-group-shim"><Icon icon={gameboyOutline} height={24} /></div>
					<select class="select" bind:value={platformId}>
						{#each platforms as platform}
							<option value={platform.plataforma_id}>{platform.plataforma_nombre}</option>
						{/each}
					</select>
				</div>
			{/if}
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={textCircleOutline} height={24} /></div>
				<input type="text" bind:value={name} class="input" placeholder="Nombre" />
			</div>
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={tagPriceOutline} height={24} /></div>
				<input type="number" bind:value={price} class="input" placeholder="Precio" />
			</div>
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={boxOutline} height={24} /></div>
				<input type="number" bind:value={stock} class="input" placeholder="Stock" />
			</div>
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim">
					<Icon icon={archiveDownMinimlisticOutline} height={24} />
				</div>
				<input
					type="number"
					bind:value={minimumStock}
					class="input"
					placeholder="Mínimo de stock"
				/>
			</div>
			<SlideToggle bind:checked={used} name="slider-sm" active="bg-primary-500" size="sm">
				Producto usado
			</SlideToggle>
			{#if inputError}
				<InputError text={errorMessage} />
			{/if}
		</div>
		<div class="grid grid-cols-2 gap-4">
			<button class="btn variant-ringed-primary" on:click={cancelHandler}> Cancelar </button>
			<button class="btn variant-filled-primary font-bold" on:click={toggleConfirmation}>
				Confirmar
			</button>
		</div>
	</div>
{/if}
