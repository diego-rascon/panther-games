<script lang="ts">
	import * as XLSX from 'xlsx';
	import moment from 'moment';
	import { Datepicker } from 'svelte-calendar';
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
		} else {
			getGamesReport(dateBeginMoment, dateFinalMoment);
			getConsolesReport(dateBeginMoment, dateFinalMoment);
			getSalesReport(dateBeginMoment, dateFinalMoment);
		}
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
								<th class="p-2 text-left">Nuevos miembros</th>
								<th class="p-2 text-left">Miembros activos</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="p-2 text-left">3</td>
								<td class="p-2 text-left">27</td>
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
				<!--<DateInput format="yyyy/MM/dd" max={dateFinal} bind:value={dateBegin} />-->
			</div>
			<div class="space-y-2">
				<SectionSubtitle text="Fecha Final" />
				<input type="date" class="input" bind:value={dateFinal} />
				<!--<DateInput format="yyyy/MM/dd" max={dateFinal} bind:value={dateFinal} />-->
			</div>
		</div>
		<button on:click={getReport} class="btn variant-filled-primary min-w-max max-w-md"
			>Generar reporte</button
		>
	</div>
{/if}
