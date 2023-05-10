<script lang="ts">
	import CashAction from '../../../components/CashAction.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import Icon from '@iconify/svelte';
	import dollarOutline from '@iconify/icons-solar/dollar-outline';
	import walletOutline from '@iconify/icons-solar/wallet-outline';
	import cashOutOutline from '@iconify/icons-solar/cash-out-outline';
	import wadOfMoneyOutline from '@iconify/icons-solar/wad-of-money-outline';
	import handMoneyOutline from '@iconify/icons-solar/hand-money-outline';

	enum Action {
		None,
		Retirar,
		Ingresar,
		Corte,
		Fondo
	}

	let currentAction = Action.None;

	const changeAction = (newAction: Action) => {
		currentAction = currentAction === newAction ? Action.None : newAction;
	};
</script>

<div class="fixed top-0 inset-x-0 p-4 ml-64 bg-gradient-to-b from-stone-950">
	<SectionTitle text="Caja" />
</div>
<div class="flex flex-col space-y-4">
	<div class="mt-[60px] grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
		<CashAction
			icon={dollarOutline}
			text="Corte de Caja"
			active={currentAction === Action.Corte}
			on:click={() => changeAction(Action.Corte)}
		/>
		<CashAction
			icon={walletOutline}
			text="Fondo Inicial"
			active={currentAction === Action.Fondo}
			on:click={() => changeAction(Action.Fondo)}
		/>
		<CashAction
			icon={cashOutOutline}
			text="Retirar Dinero"
			active={currentAction === Action.Retirar}
			on:click={() => changeAction(Action.Retirar)}
		/>
		<CashAction
			icon={handMoneyOutline}
			text="Ingresar Dinero"
			active={currentAction === Action.Ingresar}
			on:click={() => changeAction(Action.Ingresar)}
		/>
	</div>
	<div>
		<SectionSubtitle text="Cantidad: $420.69" />
	</div>
	{#if currentAction === Action.None}
		<p>Por favor seleccione una acción primero</p>
	{:else if currentAction === Action.Corte}
		<p>Corte de caja</p>
	{:else if currentAction === Action.Fondo}
		<p>Fondo inicial</p>
	{:else if currentAction === Action.Retirar}
		<div class="flex flex-col space-y-4 items-end">
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={wadOfMoneyOutline} height={24} /></div>
				<input type="number" class="input" placeholder="Cantidad a retirar" />
			</div>
			<button class="btn variant-filled-primary">Retirar</button>
		</div>
	{:else if currentAction === Action.Ingresar}
		<div class="flex flex-col space-y-4 items-end">
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={wadOfMoneyOutline} height={24} /></div>
				<input type="number" class="input" placeholder="Cantidad a ingresar" />
			</div>
			<button class="btn variant-filled-primary">Ingresar</button>
		</div>
	{/if}
</div>