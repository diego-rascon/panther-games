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
	import { cajaTotalStore } from '$lib/stores';
	import { supabase } from '$lib/db';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import moment from 'moment';
	import CashRow from '../../../components/CashRow.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';

	export let data;
	let { caja } = data;
	$: ({ caja } = data);

	let cajaTotal: number;
	let cajaInicial: number;
	let cajaFinal: number;
	let fechaActual = new Date();
	let fechaActualFormat = moment(fechaActual).format('MM-DD-YYYY');

	enum Action {
		None,
		Corte,
		Fondo,
		Retirar,
		Ingresar
	}

	let currentAction = Action.Corte;

	const changeAction = (newAction: Action) => {
		currentAction = currentAction === newAction ? Action.None : newAction;
	};

	let tempCajaId: number;
	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteCaja = async () => {
		toggleDeleteConfirmation();
		const { data, error } = await supabase
			.from('caja')
			.delete()
			.eq('caja_id', tempCajaId)
			.select()
			.single();
		if (error) console.log(error.message);
		if (data) caja = caja.filter((cajaEntry: any) => cajaEntry.caja_id != tempCajaId);
		cajaTotal = caja[0].caja_total;
		toastStore.trigger(cajaDeleted);
	};

	const setFondoInicial = async () => {
		const { data, error } = await supabase
			.from('caja')
			.insert({
				caja_fondo_inicio: cajaInicial,
				caja_total: cajaInicial,
				caja_fecha: fechaActualFormat
			})
			.select()
			.single();
		if (error) console.log(error.message);
		if (data) {
			cajaTotal = data.caja_total;
			caja = [data, ...caja];
		}
	};

	const depositMoney = async (dineroEntrada: number) => {
		const { data, error } = await supabase
			.from('caja')
			.update({ caja_total: dineroEntrada })
			.eq('fecha', fechaActualFormat);

		if (error) {
			console.error(error);
		} else {
			console.log('Se ha actualizado el registro correctamente');
		}
	};

	const getCajaTotalFromDate = async () => {
		const { data, error } = await supabase
			.from('caja')
			.select('caja_total')
			.eq('caja_fecha', fechaActualFormat)
			.limit(1);

		if (data && data.length > 0) {
			cajaTotal = data[0].caja_total;
		} else {
			cajaTotal = 0;
		}
	};

	getCajaTotalFromDate();

	const cajaDeleted: ToastSettings = {
		message: 'Se eliminó una entrada de la caja.',
		background: 'variant-filled-primary'
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
		<SectionSubtitle text="Cantidad: ${cajaTotal}" />
	</div>
	{#if currentAction === Action.None}
		<p>Por favor seleccione una acción primero</p>
	{:else if currentAction === Action.Corte}
		<div class="flex flex-col min-w-full rounded-xl overflow-x-auto">
			<table class="bg-stone-900">
				<thead>
					<tr class="text-lg">
						<th class="p-4 text-left">Fecha</th>
						<th class="text-left">Fondo inicial</th>
						<th class="text-left">Fonto total</th>
						<th class="" />
					</tr>
				</thead>
				<tbody>
					{#each caja as cajaEntry}
						<CashRow
							deleteCaja={(cajaId) => {
								toggleDeleteConfirmation();
								tempCajaId = cajaId;
							}}
							id={cajaEntry.caja_id}
							date={cajaEntry.caja_fecha}
							cajaStart={cajaEntry.caja_fondo_inicio}
							cajaTotal={cajaEntry.caja_total}
						/>
					{/each}
				</tbody>
			</table>
		</div>
	{:else if currentAction === Action.Fondo}
		<div class="flex flex-col space-y-4 items-end">
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={wadOfMoneyOutline} height={24} /></div>
				<input
					type="number"
					class="input"
					placeholder="Cantidad de fondo inicial"
					bind:value={cajaInicial}
				/>
			</div>
			<button on:click={setFondoInicial} class="btn variant-filled-primary">Establecer</button>
		</div>
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
{#if deleteConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleDeleteConfirmation}
			confirmHandler={deleteCaja}
			title="Eliminar de Caja"
			text="¿Seguro de que desea eliminar el registro de la caja?"
		/>
	</DarkenSreen>
{/if}
