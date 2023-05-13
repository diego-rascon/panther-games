<script lang="ts">
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import Icon from '@iconify/svelte';
	import dollarOutline from '@iconify/icons-solar/dollar-outline';
	import walletOutline from '@iconify/icons-solar/wallet-outline';
	import cashOutOutline from '@iconify/icons-solar/cash-out-outline';
	import wadOfMoneyOutline from '@iconify/icons-solar/wad-of-money-outline';
	import handMoneyOutline from '@iconify/icons-solar/hand-money-outline';
	import { supabase } from '$lib/db';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import moment from 'moment';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import * as XLSX from 'xlsx';
	import CashAction from '../../../components/data/CashAction.svelte';
	import CashRow from '../../../components/data/CashRow.svelte';

	export let data;
	let { caja } = data;
	$: ({ caja } = data);

	let cajaTotal: number;
	let cajaInicial: number;
	let cajaFinal: number;
	let fechaActual = new Date();
	let fechaActualFormat = moment(fechaActual).format('MM-DD-YYYY');
	let visualizarCorte = false;

	let gameReport: {
		venta_id: number;
		producto_id: number;
		producto_nombre: string;
		producto_stock: number;
		producto_precio: number;
		cantidad_vendida: number;
		total_producto: number;
		plataforma_id: number;
	}[] = [];

	let consoleReport: {
		venta_id: number;
		producto_id: number;
		producto_nombre: string;
		producto_stock: number;
		producto_precio: number;
		cantidad_vendida: number;
		total_producto: number;
	}[] = [];

	let saleReport: {
		cantidad_ventas: number;
		total_ventas: number;
	}[] = [];

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
		if (error) {
			console.log(error.message);
			cajaInicial = 0;
			toastStore.trigger(fondoInicialEstablishedError);
		} else {
			cajaInicial = 0;
			toastStore.trigger(fondoInicialEstablished);
		}
		if (data) {
			cajaTotal = data.caja_total;
			caja = [data, ...caja];
		}
	};

	let dineroEntrada: number;

	const depositMoney = async () => {
		const { data, error } = await supabase
			.from('caja')
			.update({ caja_total: cajaTotal + dineroEntrada })
			.eq('caja_fecha', fechaActualFormat)
			.select()
			.single();

		if (error) {
			console.error(error);
			toastStore.trigger(depositMoneyError);
			dineroEntrada = 0;
		} else {
			dineroEntrada = 0;
			toastStore.trigger(depositMoneySuccess);
			cajaTotal = data.caja_total;
		}
	};

	const withdrawMoney = async () => {
		const { data, error } = await supabase
			.from('caja')
			.update({ caja_total: cajaTotal - dineroEntrada })
			.eq('caja_fecha', fechaActualFormat)
			.select()
			.single();

		if (error) {
			console.error(error);
			toastStore.trigger(withdrawMoneyError);
			dineroEntrada = 0;
		} else {
			dineroEntrada = 0;
			toastStore.trigger(withdrawMoneySuccess);
			cajaTotal = data.caja_total;
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

	const fondoInicialEstablished: ToastSettings = {
		message: 'Se establecio el fondo inicial.',
		background: 'variant-filled-primary'
	};

	const fondoInicialEstablishedError: ToastSettings = {
		message: 'Hubo un error estableciendo el fondo inicial.',
		background: 'variant-filled-primary'
	};

	const depositMoneyError: ToastSettings = {
		message: 'Hubo un error depositando dinero.',
		background: 'variant-filled-primary'
	};

	const depositMoneySuccess: ToastSettings = {
		message: 'Se deposito dinero correctamente.',
		background: 'variant-filled-primary'
	};

	const withdrawMoneyError: ToastSettings = {
		message: 'Hubo un error retirando dinero,',
		background: 'variant-filled-primary'
	};

	const withdrawMoneySuccess: ToastSettings = {
		message: 'Se retiro dinero correctamente.',
		background: 'variant-filled-primary'
	};

	//Reporte del dia

	const getColor = (plataforma: number): string => {
		switch (plataforma) {
			case 1:
			case 2:
				return 'bg-blue-950';
			case 3:
				return 'bg-red-950';
			case 4:
			case 5:
				return 'bg-green-950';
			default:
				return 'bg-stone-900';
		}
	};

	const getGamesReportOneDate = async (date: string) => {
		try {
			const { data } = await supabase.rpc('generalreportgamesonedate', {
				start_date: date
			});
			console.log(data);
			gameReport = data;
		} catch (error) {
			console.error(error);
		}
	};

	const getConsolesReportOneDate = async (date: string) => {
		try {
			const { data } = await supabase.rpc('generalreportconsolasonedate', {
				start_date: date
			});
			console.log(data);
			consoleReport = data;
		} catch (error) {
			console.error(error);
		}
	};

	const getSalesReportOneDate = async (date: string) => {
		try {
			const { data } = await supabase.rpc('generalreportventaonedate', {
				start_date: date
			});
			console.log(data);
			saleReport = data;
		} catch (error) {
			console.error(error);
		}
	};

	const getReport = () => {
		getGamesReportOneDate(fechaActualFormat);
		getConsolesReportOneDate(fechaActualFormat);
		getSalesReportOneDate(fechaActualFormat);
	};

	const toggleVisualizarCorte = async () => {
		visualizarCorte = !visualizarCorte;
		if (visualizarCorte) {
			getReport();
		}
	};

	//Hacer corte de caja

	const hacerCorte = async () => {
		toggleVisualizarCorte();
		console.log('se hizo el corte');
	};

	const getExcel = () => {
		try {
			const tables = document.querySelectorAll('table');
			const wb = XLSX.utils.book_new();

			tables.forEach((table, index) => {
				const ws = XLSX.utils.table_to_sheet(table);
				XLSX.utils.book_append_sheet(wb, ws, index + 1 + '');
			});
			XLSX.writeFile(wb, 'reporte.xlsx');
		} catch (error) {
			console.error(error);
		}
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
		<SectionSubtitle text="Cantidad en caja: ${cajaTotal}" />
	</div>
	{#if currentAction === Action.None}
		<p>Por favor seleccione una acción primero</p>
	{:else if currentAction === Action.Corte}
		<div class="text-center">
			<button
				on:click={toggleVisualizarCorte}
				class="btn variant-filled-primary min-w-max max-w-md text-xl"
				>Previsualizar Corte de Caja Actual</button
			>
		</div>
		{#if !visualizarCorte}
			<div class="flex flex-col min-w-full rounded-xl overflow-x-auto">
				<table class="bg-stone-900">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Fecha</th>
							<th class="text-left">Fondo inicial</th>
							<th class="text-left">Fondo total</th>
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
		{:else}
			<!-- Panel gris claro -->
			<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
				<div class="m-2">
					<SectionSubtitle text="Reporte del periodo  a " />
				</div>
				<!-- División de 2 columnas -->
				<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-4 transition-all">
					<!-- Izquierda -->
					<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
						<table id="TableToExport" class="table">
							<thead class="border-b border-stone-800">
								<tr>
									<th class="p-2 text-left">Ventas totales</th>
									<th class="p-2 text-left">Total por Ventas</th>
								</tr>
							</thead>
							<tbody>
								{#each saleReport as venta}
									<tr>
										<td class="p-2 text-left">{venta.cantidad_ventas}</td>
										<td class="p-2 text-left">{venta.total_ventas}</td>
									</tr>
								{/each}
							</tbody>
						</table>
					</div>

					<!-- Derecha -->
					<div>
						<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
							<table id="TableToExport" class="table">
								<thead class="border-b border-stone-800">
									<tr>
										<th class="p-2 text-left">Cantidad en Caja</th>
										<th class="p-2 text-left">Diferencia</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										{#each saleReport as venta}
											<td class="p-2 text-left">{cajaTotal}</td>
											<td class="p-2 text-left">{cajaTotal - venta.total_ventas}</td>
										{/each}
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<!-- Parte inferior-->
				<div>
					<div class="m-2">
						<SectionSubtitle text="Videojuegos" />
					</div>
					<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
						<table id="TableToExport" class="table">
							<thead class="border-b border-stone-800">
								<tr>
									<th class="p-2 text-left">Folio</th>
									<th class="p-2 text-left">Nombre</th>
									<th class="p-2 text-left">Stock</th>
									<th class="p-2 text-left">Precio venta</th>
									<th class="p-2 text-left">Vendidos</th>
									<th class="p-2 text-left">Total</th>
								</tr>
							</thead>
							{#each gameReport as game}
								<tr class={getColor(game.plataforma_id)}>
									<td class="p-2 text-left">{game.venta_id}</td>
									<td class="p-2 text-left">{game.producto_nombre}</td>
									<td class="p-2 text-left">{game.producto_stock}</td>
									<td class="p-2 text-left">{game.producto_precio}</td>
									<td class="p-2 text-left">{game.cantidad_vendida}</td>
									<td class="p-2 text-left">{game.total_producto}</td>
								</tr>
							{/each}
						</table>
					</div>
				</div>
				<div>
					<div class="m-2">
						<SectionSubtitle text="Consolas" />
					</div>
					<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
						<table id="TableToExport" class="table">
							<thead class="border-b border-stone-800">
								<tr>
									<th class="p-2 text-left">Folio</th>
									<th class="p-2 text-left">Nombre</th>
									<th class="p-2 text-left">Stock</th>
									<th class="p-2 text-left">Precio venta</th>
									<th class="p-2 text-left">Vendidos</th>
									<th class="p-2 text-left">Total</th>
								</tr>
							</thead>
							<tbody>
								{#each consoleReport as consola}
									<tr>
										<td class="p-2 text-left">{consola.venta_id}</td>
										<td class="p-2 text-left">{consola.producto_nombre}</td>
										<td class="p-2 text-left">{consola.producto_stock}</td>
										<td class="p-2 text-left">{consola.producto_precio}</td>
										<td class="p-2 text-left">{consola.cantidad_vendida}</td>
										<td class="p-2 text-left">{consola.total_producto}</td>
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
				</div>
				<div class="text-center">
					<button on:click={getExcel} class="btn variant-filled-primary min-w-max max-w-md m-4 p-4">
						<p class="font-bold">Exportar en .xlsx</p>
					</button>
					<button
						on:click={hacerCorte}
						class="btn variant-filled-primary min-w-max max-w-md m-4 p-4"
					>
						<p class="font-bold">Hacer Corte</p>
					</button>
				</div>
			</div>
		{/if}
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
				<input
					type="number"
					class="input"
					placeholder="Cantidad a retirar"
					bind:value={dineroEntrada}
				/>
			</div>
			<button on:click={withdrawMoney} class="btn variant-filled-primary">Retirar</button>
		</div>
	{:else if currentAction === Action.Ingresar}
		<div class="flex flex-col space-y-4 items-end">
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={wadOfMoneyOutline} height={24} /></div>
				<input
					type="number"
					class="input"
					placeholder="Cantidad a ingresar"
					bind:value={dineroEntrada}
				/>
			</div>
			<button on:click={depositMoney} class="btn variant-filled-primary">Ingresar</button>
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
