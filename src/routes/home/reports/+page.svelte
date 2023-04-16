<!-- import DatePicker y declaración de fecha-->
<script lang="ts">
	import { DateInput } from 'date-picker-svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	let dateFinal = new Date();
	let dateBegin = new Date(dateFinal.getFullYear(), dateFinal.getMonth(), 1);
	let reporteGenerado: boolean = false;

	const getReport = () => {
		reporteGenerado = true;
	};
</script>

{#if reporteGenerado}
	<!-- Panel gris claro -->
	<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
		<div class="m-2">
			<SectionSubtitle
				text="Reporte del periodo {dateBegin.getDay()}/{dateBegin.getMonth()}/{dateBegin.getFullYear()} - {dateFinal.getDay()}/{dateFinal.getMonth()}/{dateFinal.getFullYear()}"
			/>
		</div>
		<!-- División de 2 columnas -->
		<div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-2 gap-4 transition-all">
			<!-- Izquierda -->
			<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
				<table class="table">
					<thead class="border-b border-stone-700">
						<th class="p-2 text-left">Ventas totales</th>
						<th class="p-2 text-left">Costos</th>
						<th class="p-2 text-left">Total por Ventas</th>
						<th class="p-2 text-left">Ganancia</th>
					</thead>

					<tr>
						<td class="p-2 text-left">126</td>
						<td class="p-2 text-left">63 873.50</td>
						<td class="p-2 text-left">84 520</td>
						<td class="p-2 text-left">20 625.50</td>
					</tr>
				</table>
			</div>

			<!-- Derecha -->
			<div>
				<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
					<table class="table">
						<thead class="border-b border-stone-700">
							<th class="p-2 text-left">Rentas completadas</th>
							<th class="p-2 text-left">Total por rentas</th>
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
					<table class="table">
						<thead class="border-b border-stone-700">
							<th class="p-2 text-left">Nuevos miembros</th>
							<th class="p-2 text-left">Miembros activos</th>
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
				<SectionSubtitle text="Consolas" />
			</div>
			<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
				<table class="table">
					<thead class="border-b border-stone-700">
						<th class="p-2 text-left">Nombre</th>
						<th class="p-2 text-left">Stock</th>
						<th class="p-2 text-left">Precio venta</th>
						<th class="p-2 text-left">Vendidos</th>
						<th class="p-2 text-left">% de crecimiento</th>
						<th class="p-2 text-left">Previsto</th>
					</thead>
					<tbody>
						<tr>
							<td class="p-2 text-left">PS4</td>
							<td class="p-2 text-left">0</td>
							<td class="p-2 text-left">8500</td>
							<td class="p-2 text-left">1</td>
							<td class="p-2 text-left">50</td>
							<td class="p-2 text-left">2</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
		<div>
			<div class="m-2">
				<SectionSubtitle text="Videojuegos" />
			</div>
			<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
				<table class="table">
					<thead class="border-b border-stone-700">
						<th class="p-2 text-left">Nombre</th>
						<th class="p-2 text-left">Stock</th>
						<th class="p-2 text-left">Precio venta</th>
						<th class="p-2 text-left">Vendidos</th>
						<th class="p-2 text-left">% de crecimiento</th>
						<th class="p-2 text-left">Previsto</th>
					</thead>
					<tbody>
						<tr class="bg-blue-500">
							<td class="p-2 text-left">Super Mario 64 PS5</td>
							<td class="p-2 text-left">2</td>
							<td class="p-2 text-left">1000</td>
							<td class="p-2 text-left">1</td>
							<td class="p-2 text-left">100</td>
							<td class="p-2 text-left">0</td>
						</tr>
						<tr class=" bg-red-500">
							<td class="p-2 text-left">Super Mario Galaxy</td>
							<td class="p-2 text-left">3</td>
							<td class="p-2 text-left">300</td>
							<td class="p-2 text-left">6</td>
							<td class="p-2 text-left">15</td>
							<td class="p-2 text-left">4</td>
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
