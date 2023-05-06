<script lang="ts">
	import { scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import ConfirmDialog from '../modals/ConfirmDialog.svelte';
	import { RadioGroup, RadioItem } from '@skeletonlabs/skeleton';
	import Icon from '@iconify/svelte';
	import arrowUpOutline from '@iconify/icons-solar/arrow-up-outline';
	import arrowDownOutline from '@iconify/icons-solar/arrow-down-outline';

	export let cancelHandler: () => void;
	export let confirmHandler: (stock: number) => void;
	export let currentStock: number;

	const iconSize = 24;

	let changeType = 1;
	let stockChange = 0;
	let newStock: number;

	const calculateNewStock = () => {
		if (changeType === 0) newStock = currentStock - stockChange;
		else newStock = currentStock + stockChange;
	};

	calculateNewStock();

	let confirmationVisible = false;

	const toggleConfirmation = () => {
		confirmationVisible = !confirmationVisible;
	};
</script>

{#if confirmationVisible}
	<ConfirmDialog
		cancelHandler={toggleConfirmation}
		confirmHandler={() => {
			confirmHandler(newStock);
		}}
		title="Confirmar Cambio"
		text="¿Está seguro de que desea cambiar el stock del producto de {currentStock} a {newStock}?"
	/>
{:else}
	<div
		class="flex flex-col p-8 w-full max-w-md space-y-8 bg-stone-950 border border-stone-800 rounded-xl transition-all"
		in:scale={{ duration: 150 }}
	>
		<SectionTitle centered={true} text="Cambiar Stock" />
		<div class="flex flex-col space-y-4">
			<RadioGroup class="justify-center" active="variant-filled-primary">
				<RadioItem on:change={calculateNewStock} bind:group={changeType} name="justify" value={0}
					>Reducir</RadioItem
				>
				<RadioItem on:change={calculateNewStock} bind:group={changeType} name="justify" value={1}
					>Aumentar</RadioItem
				>
			</RadioGroup>
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim">
					{#if changeType === 1}
						<Icon icon={arrowUpOutline} height={iconSize} />
					{:else}
						<Icon icon={arrowDownOutline} height={iconSize} />
					{/if}
				</div>
				<input
					bind:value={stockChange}
					type="number"
					min="0"
					class="input"
					placeholder="Cantidad"
					on:input={calculateNewStock}
				/>
			</div>
			<div class="flex justify-between items-center">
				<p class="unstyled text-lg">Stock actual</p>
				<input bind:value={currentStock} type="number" class="input w-24" readonly />
			</div>
			<div class="flex justify-between items-center">
				<p class="unstyled text-lg">Nuevo stock</p>
				<input bind:value={newStock} type="number" class="input w-24" readonly />
			</div>
		</div>
		<div class="grid grid-cols-2 gap-4">
			<button class="btn variant-ringed-primary" on:click={cancelHandler}>Cancelar</button>
			<button class="btn variant-filled-primary font-bold" on:click={toggleConfirmation}>
				Confirmar
			</button>
		</div>
	</div>
{/if}
