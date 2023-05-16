<script lang="ts">
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
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import * as XLSX from 'xlsx';
	import CashAction from '../../../components/data/CashAction.svelte';
	import CashRow from '../../../components/data/CashRow.svelte';
	import dialog2Linear from '@iconify/icons-solar/dialog-2-linear';

	export let data;
	let { caja } = data;
	$: ({ caja } = data);

	let cajaInicialExist = false;

	let cajaTotal: number;
	let cajaInicial: number;
	let fechaActual = new Date();
	let fechaActualFormat = moment(fechaActual).format('MM-DD-YYYY');
	let visualizarCorte = false;
	let retiroMotivo: string;
	let ingresoMotivo: string;

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

	let saleCardReport: {
		cantidad_ventas: number;
		total_ventas: number;
	}[] = [];

	let rentReport: {
		cantidad_rentas: number;
		total_rentas: number;
	}[] = [];

	let rentCardReport: {
		cantidad_rentas: number;
		total_rentas: number;
	}[] = [];

	let accesoriesReport: {
		venta_id: number;
		producto_id: number;
		producto_nombre: string;
		producto_stock: number;
		producto_precio: number;
		cantidad_vendida: number;
		total_producto: number;
	}[] = [];

	let retirosDetalle: {
		retiro_cantidad: number;
		retiro_motivo: string;
	}[] = [];

	let ingresosDetalle: {
		ingreso_cantidad: number;
		ingreso_motivo: string;
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
		dineroEntrada = 0;
	};

	let tempCajaId: number;
	let deleteConfirmation = false;
	let corteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const toggleCorteConfirmation = () => {
		corteConfirmation = !corteConfirmation;
	};

	// Movimientos en caja

	const deleteCaja = async () => {
		toggleDeleteConfirmation();
		const { data, error } = await supabase
			.from('caja')
			.delete()
			.eq('caja_id', tempCajaId)
			.select()
			.maybeSingle();
		if (error) console.log(error.message);
		if (data) caja = caja.filter((cajaEntry: any) => cajaEntry.caja_id != tempCajaId);
		if (caja.length > 0) cajaTotal = caja[0].caja_total;

		toastStore.trigger(cajaDeleted);
		cajaInicialExist = false;
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
			if (await insertarIngresoDetalle()) {
				//Ingreso
				dineroEntrada = 0;
				toastStore.trigger(depositMoneySuccess);
				cajaTotal = data.caja_total;
			} else {
				toastStore.trigger(depositMoneyError);
			}
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
			if (await insertarRetiroDetalle()) {
				//Retiro
				dineroEntrada = 0;
				toastStore.trigger(withdrawMoneySuccess);
				cajaTotal = data.caja_total;
			} else {
				toastStore.trigger(withdrawMoneyError);
			}
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

	let tempCajaInicial: number;

	const getCajaInicialFromDate = async () => {
		const { data, error } = await supabase
			.from('caja')
			.select('caja_fondo_inicio')
			.eq('caja_fecha', fechaActualFormat)
			.limit(1);

		if (data && data.length > 0) {
			tempCajaInicial = data[0].caja_fondo_inicio;
			cajaInicialExist = true;
		} else {
			tempCajaInicial = 0;
		}
	};

	getCajaInicialFromDate();

	// -----------------------------------------------

	//Retiros funcionamiento.

	let retirosCount = 0;
	let sumRetiros = 0; // variable que almacena la sumatoria de retiro_cantidad

	async function insertarRetiroDetalle() {
		const nuevaFila = {
			retiro_cantidad: dineroEntrada,
			retiro_motivo: retiroMotivo,
			caja_id: caja[0].caja_id
		};

		const { data, error } = await supabase.from('retiros_detalle').insert(nuevaFila);

		if (error) {
			console.log(error.message);
			return false;
		} else {
			console.log('Nueva fila insertada correctamente:', data);
			retiroMotivo = '';
			return true;
		}
	}

	const deleteCajaRetiroDetalle = async () => {
		const { data, error } = await supabase
			.from('retiros_detalle')
			.delete()
			.eq('caja_id', tempCajaId)
			.select();
	};

	const getRetirosInfo = async () => {
		const { data, error } = await supabase
			.from('retiros_detalle')
			.select()
			.eq('caja_id', caja[0].caja_id);

		if (data && data.length > 0) {
			for (const retiro of data) {
				sumRetiros += retiro.retiro_cantidad;
			}
			retirosDetalle = data.map(({ retiro_cantidad, retiro_motivo }) => ({
				retiro_cantidad,
				retiro_motivo
			}));
		} else {
			console.log(error);
		}
	};

	const getRetirosCount = async () => {
		const { data, error } = await supabase
			.from('retiros_detalle')
			.select('*')
			.eq('caja_id', caja[0].caja_id);
		if (data) {
			retirosCount = data.length;
		} else {
			console.log(error);
		}
	};

	if (cajaInicialExist) {
		getRetirosCount();
	}

	// ---------------------------------

	//Ingresos funcionamiento

	let ingresosCount = 0;
	let sumIngresos = 0; // variable que almacena la sumatoria de ingresos_cantidad

	async function insertarIngresoDetalle() {
		const nuevaFila = {
			ingreso_cantidad: dineroEntrada,
			ingreso_motivo: ingresoMotivo,
			caja_id: caja[0].caja_id
		};

		const { data, error } = await supabase.from('ingresos_detalle').insert(nuevaFila);

		if (error) {
			console.log(error.message);
			return false;
		} else {
			console.log('Nueva fila insertada correctamente:', data);
			ingresoMotivo = '';
			return true;
		}
	}

	const deleteCajaIngresoDetalle = async () => {
		const { data, error } = await supabase
			.from('ingresos_detalle')
			.delete()
			.eq('caja_id', tempCajaId)
			.select();
	};

	const getIngresosInfo = async () => {
		const { data, error } = await supabase
			.from('ingresos_detalle')
			.select()
			.eq('caja_id', caja[0].caja_id);

		if (data && data.length > 0) {
			for (const ingreso of data) {
				sumIngresos += ingreso.ingreso_cantidad;
			}
			ingresosDetalle = data.map(({ ingreso_cantidad, ingreso_motivo }) => ({
				ingreso_cantidad,
				ingreso_motivo
			}));
		} else {
			console.log(error);
		}
	};

	const getIngresoCount = async () => {
		const { data, error } = await supabase
			.from('ingresos_detalle')
			.select('*')
			.eq('caja_id', caja[0].caja_id);
		if (data) {
			ingresosCount = data.length;
		} else {
			console.log(error);
		}
	};

	if (cajaInicialExist) {
		getIngresoCount();
	}

	// ---------------------------------

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
		message: 'Hubo un error retirando dinero.',
		background: 'variant-filled-primary'
	};

	const withdrawMoneySuccess: ToastSettings = {
		message: 'Se retiro dinero correctamente.',
		background: 'variant-filled-primary'
	};

	//Metodos que llaman al reporte

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

	const getAccesoriesReportOneDate = async (date: string) => {
		try {
			const { data } = await supabase.rpc('generalreportaccesoriosonedate', {
				start_date: date
			});
			console.log(data);
			accesoriesReport = data;
		} catch (error) {
			console.error(error);
		}
	};

	const getVentaTarjetaOneDate = async (date: string) => {
		try {
			const { data } = await supabase.rpc('ventatarjetaonedate', {
				start_date: date
			});
			console.log('venta tarjeta', data);
			saleCardReport = data;
		} catch (error) {
			console.error(error);
		}
	};

	const getReport = () => {
		sumIngresos = 0;
		sumRetiros = 0;
		getCajaInicialFromDate();
		getRetirosInfo();
		getIngresosInfo();
		getVentaTarjetaOneDate(fechaActualFormat);
		getGamesReportOneDate(fechaActualFormat);
		getConsolesReportOneDate(fechaActualFormat);
		getSalesReportOneDate(fechaActualFormat);
		getAccesoriesReportOneDate(fechaActualFormat);
		getRentsReportOneDate(fechaActualFormat);
		getRentsReportTarjetaOneDate(fechaActualFormat);
	};

	const toggleVisualizarCorte = async () => {
		visualizarCorte = !visualizarCorte;
		if (visualizarCorte) {
			getReport();
		}
	};

	//Reporte rentas.

	const getRentsReportOneDate = async (date: string) => {
		try {
			const { data } = await supabase.rpc('generalreportrentsonedate', {
				start_date: date
			});
			console.log(data);
			rentReport = data;
		} catch (error) {
			console.error(error);
		}
	};

	const getRentsReportTarjetaOneDate = async (date: string) => {
		try {
			const { data } = await supabase.rpc('generalreportrentscardonedate', {
				start_date: date
			});
			console.log(data);
			rentCardReport = data;
		} catch (error) {
			console.error(error);
		}
	};

	//Hacer corte de caja

	const hacerCorte = async () => {
		toggleCorteConfirmation();
		const { data, error } = await supabase
			.from('caja')
			.delete()
			.eq('caja_id', caja[0].caja_id)
			.select()
			.single();
		if (error) console.log(error.message);

		getExcel();

		toggleVisualizarCorte();
	};

	let arreglo: string[] = [
		'Ventas',
		'Caja',
		'Ingresos y Retiros',
		'Rentas',
		'Ingresos Detalles',
		'Retiros Detalles',
		'Juegos',
		'Consolas',
		'Accesorios'
	];

	const getExcel = () => {
		try {
			const tables = document.querySelectorAll('table');
			const wb = XLSX.utils.book_new();

			tables.forEach((table, index) => {
				const ws = XLSX.utils.table_to_sheet(table);
				XLSX.utils.book_append_sheet(wb, ws, arreglo[index]);
			});
			XLSX.writeFile(wb, 'Corte Caja ' + fechaActualFormat + '.xlsx');
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
			{#if cajaInicialExist}
				<button
					on:click={toggleVisualizarCorte}
					class="btn variant-filled-primary min-w-max max-w-md text-xl"
					>Previsualizar Corte de Caja Actual</button
				>
			{:else}
				<div class="text-xl">No existe una caja establecida para el dia de hoy.</div>
			{/if}
		</div>

		{#if !visualizarCorte}
			{#if cajaInicialExist}
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
			{/if}
		{:else}
			<!-- Panel gris claro -->
			<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
				<div class="m-2">
					<SectionSubtitle text="Corte de caja {fechaActualFormat}" />
				</div>
				<!-- División de 2 columnas -->
				<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-4 transition-all">
					<!-- Izquierda -->
					<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
						<table id="TableToExport" class="table">
							<thead class="border-b border-stone-800">
								<tr>
									<th class="p-2 text-left">Cantidad de ventas tarjeta</th>
									<th class="p-2 text-left">Total ventas tarjeta</th>
									<th class="p-2 text-left">Cantidad de ventas efectivo</th>
									<th class="p-2 text-left">Total ventas efectivo</th>
									<th class="p-2 text-left">Cantidad de ventas totales</th>
									<th class="p-2 text-left">Total ventas</th>
								</tr>
							</thead>
							<tbody>
								{#each saleReport as venta}
									{#each saleCardReport as tarjetaVenta}
										<tr>
											<td class="p-2 text-left">{tarjetaVenta.cantidad_ventas}</td>
											<td class="p-2 text-left">{tarjetaVenta.total_ventas}</td>
											<td class="p-2 text-left"
												>{venta.cantidad_ventas - tarjetaVenta.cantidad_ventas}</td
											>
											<td class="p-2 text-left">{venta.total_ventas - tarjetaVenta.total_ventas}</td
											>
											<td class="p-2 text-left">{venta.cantidad_ventas}</td>
											<td class="p-2 text-left">{venta.total_ventas}</td>
										</tr>
									{/each}
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
										<th class="p-2 text-left">Cantidad Rentas Tarjeta</th>
										<th class="p-2 text-left">Total Rentas Tarjeta</th>
										<th class="p-2 text-left">Cantidad Rentas Efectivo</th>
										<th class="p-2 text-left">Total Rentas Efectivo</th>
										<th class="p-2 text-left">Cantidad Rentas Totales</th>
										<th class="p-2 text-left">Total Rentas</th>
									</tr>
								</thead>
								<tbody>
									{#each rentReport as renta}
										{#each rentCardReport as tarjetaRenta}
											<tr>
												<td class="p-2 text-left">{tarjetaRenta.cantidad_rentas}</td>
												<td class="p-2 text-left">{tarjetaRenta.total_rentas}</td>
												<td class="p-2 text-left"
													>{renta.cantidad_rentas - tarjetaRenta.cantidad_rentas}</td
												>
												<td class="p-2 text-left"
													>{renta.total_rentas - tarjetaRenta.total_rentas}</td
												>
												<td class="p-2 text-left">{renta.cantidad_rentas}</td>
												<td class="p-2 text-left">{renta.total_rentas}</td>
											</tr>
										{/each}
									{/each}
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-4 transition-all">
					<!-- Izquierda -->
					<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
						<table id="TableToExport" class="table">
							<thead class="border-b border-stone-800">
								<tr>
									<th class="p-2 text-left">Fondo Inicial</th>
									<th class="p-2 text-left">Retiros Realizados</th>
									<th class="p-2 text-left">Total dinero por retiros</th>
									<th class="p-2 text-left">Ingresos Realizados</th>
									<th class="p-2 text-left">Total dinero por ingresos</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="p-2 text-left">{tempCajaInicial} </td>
									<td class="p-2 text-left">{retirosCount} </td>
									<td class="p-2 text-left">{sumRetiros} </td>
									<td class="p-2 text-left">{ingresosCount}</td>
									<td class="p-2 text-left">{sumIngresos}</td>
								</tr>
							</tbody>
						</table>
					</div>
					<!-- Derecha -->

					<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
						<table id="TableToExport" class="table">
							<thead class="border-b border-stone-800">
								<tr>
									<th class="p-2 text-left">Cantidad en Caja</th>
									<th class="p-2 text-left">Total esperado en caja</th>
									<th class="p-2 text-left">Diferencia</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									{#each saleReport as venta}
										{#each saleCardReport as ventaTarjeta}
											<td class="p-2 text-left">{cajaTotal}</td>
											<td class="p-2 text-left">
												{venta.total_ventas +
													tempCajaInicial +
													sumIngresos -
													sumRetiros -
													ventaTarjeta.total_ventas}</td
											>
											<td class="p-2 text-left"
												>{cajaTotal -
													(venta.total_ventas +
														tempCajaInicial +
														sumIngresos -
														sumRetiros -
														ventaTarjeta.total_ventas)}
											</td>
										{/each}
									{/each}
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-4 transition-all">
					<!-- Izquierda -->
					<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
						<div class="m-2">
							<SectionSubtitle text="Retiros" />
						</div>
						<table id="TableToExport" class="table">
							<thead class="border-b border-stone-800">
								<tr>
									<th class="p-2 text-left">Cantidad</th>
									<th class="p-2 text-left">Detalle</th>
								</tr>
							</thead>
							<tbody>
								{#each retirosDetalle as retiro}
									<tr>
										<td class="p-2 text-left">{retiro.retiro_cantidad} </td>
										<td class="p-2 text-left">{retiro.retiro_motivo} </td>
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
					<!-- Derecha -->
					<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
						<div class="m-2">
							<SectionSubtitle text="Ingresos" />
						</div>
						<table id="TableToExport" class="table">
							<thead class="border-b border-stone-800">
								<tr>
									<th class="p-2 text-left">Cantidad</th>
									<th class="p-2 text-left">Detalle</th>
								</tr>
							</thead>
							<tbody>
								{#each ingresosDetalle as ingreso}
									<tr>
										<td class="p-2 text-left">{ingreso.ingreso_cantidad} </td>
										<td class="p-2 text-left">{ingreso.ingreso_motivo} </td>
									</tr>
								{/each}
							</tbody>
						</table>
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
				<div>
					<div class="m-2">
						<SectionSubtitle text="Accesorios" />
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
								{#each accesoriesReport as accesorio}
									<tr>
										<td class="p-2 text-left">{accesorio.venta_id}</td>
										<td class="p-2 text-left">{accesorio.producto_nombre}</td>
										<td class="p-2 text-left">{accesorio.producto_stock}</td>
										<td class="p-2 text-left">{accesorio.producto_precio}</td>
										<td class="p-2 text-left">{accesorio.cantidad_vendida}</td>
										<td class="p-2 text-left">{accesorio.total_producto}</td>
									</tr>
								{/each}
							</tbody>
						</table>
					</div>
				</div>
				<div class="text-center">
					<button
						on:click={toggleCorteConfirmation}
						class="btn variant-filled-primary min-w-max max-w-md m-4 p-4"
					>
						<p class="font-bold">Hacer Corte</p>
					</button>
				</div>
			</div>
		{/if}
	{:else if currentAction === Action.Fondo}
		{#if !cajaInicialExist}
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
		{:else}
			<div class="text-xl">Ya existe una caja para el dia de hoy.</div>
		{/if}
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
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={dialog2Linear} height={24} /></div>
				<input type="text" class="input" placeholder="Motivo" bind:value={retiroMotivo} />
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
			<div class="input-group input-group-divider grid-cols-[auto_1fr_auto]">
				<div class="input-group-shim"><Icon icon={dialog2Linear} height={24} /></div>
				<input type="text" class="input" placeholder="Motivo" bind:value={ingresoMotivo} />
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

{#if corteConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleCorteConfirmation}
			confirmHandler={hacerCorte}
			title="Hacer corte"
			text="¿Seguro de que desea hacer corte?"
		/>
	</DarkenSreen>
{/if}
