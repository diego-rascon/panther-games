<!-- import DatePicker y declaración de fecha-->
<script lang="ts">
	import * as XLSX from 'xlsx';
	import moment from 'moment';
	import { DateInput } from 'date-picker-svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	let dateBeginMoment: string;
	let dateFinalMoment: string;
	let dateFinal = new Date();
	let dateBegin = new Date(dateFinal.getFullYear(), dateFinal.getMonth(), 1);
	let reporteGenerado: boolean = false;

	const getReport = () => {
		reporteGenerado = true;
		dateBeginMoment = moment(dateBegin).format('DD/MM/YYYY');
		dateFinalMoment = moment(dateFinal).format('DD/MM/YYYY');
	};

	const getExcel = () => {
		const tables = document.querySelectorAll('table');
		const wb = XLSX.utils.book_new();
		tables.forEach((table, index) => {
			const ws = XLSX.utils.table_to_sheet(table);
			XLSX.utils.book_append_sheet(wb, ws, index + 1 + '');
		});
		XLSX.writeFile(wb, 'export.xlsx');
	};

	export let data;
	let { games } = data;
	$: ({ games } = data);

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
</script>

{#if reporteGenerado}
	<!-- Panel gris claro -->
	<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
		<div class="m-2">
			<SectionSubtitle text="Reporte del periodo {dateBeginMoment} - {dateFinalMoment}" />
			<button
				on:click={getExcel}
				class="bottom-0 flex m-4 p-4 items-center space-x-2 btn-fill rounded-lg shadow-lg transition-all"
			>
				<p class="font-bold">Exportar en .xlsx</p>
			</button>
		</div>
		<!-- División de 2 columnas -->
		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-4 transition-all">
			<!-- Izquierda -->
			<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
				<table id="TableToExport" class="table">
					<thead class="border-b border-stone-700">
						<tr>
							<th class="p-2 text-left">Ventas totales</th>
							<th class="p-2 text-left">Total por Ventas</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="p-2 text-left">126</td>
							<td class="p-2 text-left">84 520</td>
						</tr>
					</tbody>
				</table>
			</div>

			<!-- Derecha -->
			<div>
				<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
					<table id="TableToExport" class="table">
						<thead class="border-b border-stone-700">
							<tr>
								<th class="p-2 text-left">Rentas completadas</th>
								<th class="p-2 text-left">Total por rentas</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="p-2 text-left">8</td>
								<td class="p-2 text-left">1300</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
					<table id="TableToExport" class="table">
						<thead class="border-b border-stone-700">
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
					<thead class="border-b border-stone-700">
						<tr>
							<th class="p-2 text-left">Nombre</th>
							<th class="p-2 text-left">Stock</th>
							<th class="p-2 text-left">Precio venta</th>
							<th class="p-2 text-left">Vendidos</th>
						</tr>
					</thead>
					<tbody>
						{#each games as game}
							<tr class={getColor(game.plataforma_id)}>
								<td class="p-2 text-left">{game.producto_nombre}</td>
								<td class="p-2 text-left">{game.producto_stock}</td>
								<td class="p-2 text-left">{game.producto_precio}</td>
								<td class="p-2 text-left">{game.cantidad_vendida}</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		</div>
		<div>
			<div class="m-2">
				<SectionSubtitle text="Consolas" />
			</div>
			<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
				<table id="TableToExport" class="table">
					<thead class="border-b border-stone-700">
						<tr>
							<th class="p-2 text-left">Nombre</th>
							<th class="p-2 text-left">Stock</th>
							<th class="p-2 text-left">Precio venta</th>
							<th class="p-2 text-left">Vendidos</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="p-2 text-left">PS4</td>
							<td class="p-2 text-left">0</td>
							<td class="p-2 text-left">8500</td>
							<td class="p-2 text-left">1</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
{:else}
	<!-- Panel gris claro -->
	<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
		<!-- División de 2 columnas -->
		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-4 transition-all">
			<!-- Izquierda -->
			<div class="m-2">
				<SectionSubtitle text="Fecha inicial" />
				<DateInput format="yyyy/MM/dd" max={dateFinal} bind:value={dateBegin} />
			</div>
			<!-- Derecha -->
			<div class="m-2">
				<SectionSubtitle text="Fecha final" />
				<DateInput format="yyyy/MM/dd" max={dateFinal} bind:value={dateFinal} />
			</div>
		</div>
		<div>
			<button
				on:click={getReport}
				class="bottom-0 flex m-4 p-4 items-center space-x-2 btn-fill rounded-xl shadow-xl transition-all"
			>
				<p class="font-bold">Generar reporte</p>
			</button>
		</div>
	</div>
{/if}
