<script lang="ts">
	import * as XLSX from 'xlsx';
	import moment from 'moment';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import { supabase } from '$lib/db';

	let dateBeginMoment: string;
	let dateFinalMoment: string;
	let dateFinal = new Date();
	let dateBegin = new Date(dateFinal.getFullYear(), dateFinal.getMonth(), 1);
	let reporteGenerado: boolean = false;

	let gameReport: {
		venta_id: number;
		producto_id: number;
		producto_nombre: string;
		plataforma_nombre: string;
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

	let saleCardReport: {
		cantidad_ventas: number;
		total_ventas: number;
	}[] = [];

	let saleReport: {
		cantidad_ventas: number;
		total_ventas: number;
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

	const dateFinalConst = dateFinal;

	const getGamesReport = async (dateStart: string, dateEnd: string) => {
		try {
			const { data } = await supabase.rpc('generalreportgamesdate', {
				start_date: dateStart,
				end_date: dateEnd
			});
			console.log(data);
			gameReport = data;
		} catch (error) {
			console.error(error);
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

	const getConsolesReport = async (dateStart: string, dateEnd: string) => {
		try {
			const { data } = await supabase.rpc('generalreportconsolasdate', {
				start_date: dateStart,
				end_date: dateEnd
			});
			console.log(data);
			consoleReport = data;
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

	const getSalesReport = async (dateStart: string, dateEnd: string) => {
		try {
			const { data } = await supabase.rpc('generalreportventadate', {
				start_date: dateStart,
				end_date: dateEnd
			});
			console.log(data);
			saleReport = data;
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

	const getAccesoriesReport = async (dateStart: string, dateEnd: string) => {
		try {
			const { data } = await supabase.rpc('generalreportaccesoriosdate', {
				start_date: dateStart,
				end_date: dateEnd
			});
			console.log(data);
			accesoriesReport = data;
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

	const getVentaTarjetaDate = async (dateStart: string, dateEnd: string) => {
		try {
			const { data } = await supabase.rpc('ventatarjetadate', {
				start_date: dateStart,
				end_date: dateEnd
			});
			saleCardReport = data;
		} catch (error) {
			console.error(error);
		}
	};


	const getVentaTarjetaOneDate = async (date: string) => {
		try {
			const { data } = await supabase.rpc('ventatarjetaonedate', {
				start_date: date
			});
			saleCardReport = data;
		} catch (error) {
			console.error(error);
		}
	};

	const reporteGeneradoHandler = () => {
		reporteGenerado = !reporteGenerado;
	};

	const getReport = () => {
		reporteGenerado = true;
		dateBeginMoment = moment(dateBegin).format('MM-DD-YYYY');
		dateFinalMoment = moment(dateFinal).format('MM-DD-YYYY');
		if (dateBeginMoment === dateFinalMoment) {
			getGamesReportOneDate(dateBeginMoment);
			getConsolesReportOneDate(dateBeginMoment);
			getSalesReportOneDate(dateBeginMoment);
			getAccesoriesReportOneDate(dateBeginMoment);
			getVentaTarjetaOneDate(dateBeginMoment);
		} else {
			getGamesReport(dateBeginMoment, dateFinalMoment);
			getConsolesReport(dateBeginMoment, dateFinalMoment);
			getSalesReport(dateBeginMoment, dateFinalMoment);
			getAccesoriesReport(dateBeginMoment, dateFinalMoment);
			getVentaTarjetaDate(dateBeginMoment, dateFinalMoment);
		}
	};

	let arreglo: string[] = ["Ventas", "Juegos", "Consolas", "Accesorios" ];

	const getExcel = () => {
		try {
			const tables = document.querySelectorAll('table');
			const wb = XLSX.utils.book_new();

			tables.forEach((table, index) => {
				const ws = XLSX.utils.table_to_sheet(table);
				XLSX.utils.book_append_sheet(wb, ws, arreglo[index]);
			});
			XLSX.writeFile(wb, 'Reporte ' + dateBeginMoment+' a '+dateFinalMoment+'.xlsx');
		} catch (error) {
			console.error(error);
		}
	};

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

	const calendarTheme = {
		calendar: {
			width: '300px',
			maxWidth: '100vw',
			legend: {
				height: '32px'
			},
			shadow: '0px 10px 26px rgba(0, 0, 0, 0.25)',
			colors: {
				text: {
					primary: 'white',
					highlight: 'white'
				},
				background: {
					primary: '#1c1917',
					highlight: '#8f1246',
					hover: '#32302b'
				},
				border: '#291D24'
			},
			font: {
				regular: '0.875em',
				large: '0.875em'
			}
		}
	};

	const tableStyle = {
		header: {
			fill: { patternType: 'solid', fgColor: { rgb: 'FF000000' } },
			font: { color: { rgb: 'FFFFFFFF' }, sz: 14, bold: true }
		},
		cell: {
			fill: { patternType: 'solid', fgColor: { rgb: 'FFFFFF00' } },
			font: { color: { rgb: 'FF000000' }, sz: 12, bold: false }
		}
	};
</script>

<SectionTitle text="Reportes" />
{#if reporteGenerado}
	<!-- Panel gris claro -->
	<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
		<div class="m-2">
			<SectionSubtitle text="Reporte del periodo {dateBeginMoment} a {dateFinalMoment}" />
			<button on:click={getExcel} class="btn variant-filled-primary min-w-max max-w-md m-4 p-4">
				<p class="font-bold">Exportar en .xlsx</p>
			</button>
			<button
				on:click={reporteGeneradoHandler}
				class="btn variant-ringed-primary min-w-max max-w-md m-4 p-4"
			>
				<p class="font-bold">Volver</p>
			</button>
		</div>
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
									<td class="p-2 text-left">{venta.total_ventas - tarjetaVenta.total_ventas}</td>
									<td class="p-2 text-left">{venta.cantidad_ventas}</td>
									<td class="p-2 text-left">{venta.total_ventas}</td>
								</tr>
							{/each}
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
							<th class="p-2 text-left">Plataforma</th>
							<th class="p-2 text-left">Stock Actual</th>
							<th class="p-2 text-left">Precio venta</th>
							<th class="p-2 text-left">Vendidos</th>
							<th class="p-2 text-left">Total</th>
						</tr>
					</thead>
					{#each gameReport as game}
						<tr class={getColor(game.plataforma_id)}>
							<td class="p-2 text-left">{game.venta_id}</td>
							<td class="p-2 text-left">{game.producto_nombre}</td>
							<td class="p-2 text-left">{game.plataforma_nombre}</td>
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
			<button on:click={getExcel} class="btn variant-filled-primary min-w-max max-w-md m-4 p-4">
				<p class="font-bold">Exportar en .xlsx</p>
			</button>
			<button
				on:click={reporteGeneradoHandler}
				class="btn variant-ringed-primary min-w-max max-w-md m-4 p-4"
			>
				<p class="font-bold">Volver</p>
			</button>
		</div>
	</div>
{:else}
	<!-- Panel gris claro -->
	<div class="flex flex-col w-full mt-4 p-4 space-y-4 bg-stone-900 rounded-xl items-end">
		<div class="grid grid-cols-2 gap-4 w-full">
			<div class="space-y-2">
				<SectionSubtitle text="Fecha Inicial" />
				<input type="date" class="input" bind:value={dateBegin} />
			</div>
			<div class="space-y-2">
				<SectionSubtitle text="Fecha Final" />
				<input type="date" class="input" bind:value={dateFinal} />
			</div>
		</div>
		<button on:click={getReport} class="btn variant-filled-primary min-w-max max-w-md"
			>Generar reporte</button
		>
	</div>
{/if}
