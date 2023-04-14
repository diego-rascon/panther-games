<!-- import DatePicker y declaración de fecha-->
<script ts="lang">
	import { DateInput } from 'date-picker-svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	let dateFinal = new Date();
	let dateBegin = new Date(dateFinal.getFullYear(), dateFinal.getMonth(), 1);
</script>

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
			class="bottom-0 flex m-4 p-4 items-center space-x-2 btn-fill rounded-xl shadow-xl transition-all"
		>
			<p class="font-bold">Generar reporte</p>
		</button>
	</div>
</div>
