<script lang="ts">
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import Search from '../../../components/inputs/Search.svelte';
	import SaleRow from '../../../components/SaleRow.svelte';

	export let data;
	let { sales } = data;
	$: ({ sales } = data);

	let search: string;

	const searchSale = (search: string) => {
		console.log(search);
	};
</script>

<div class="flex justify-between space-x-8">
	<SectionTitle text="Clientes" />
	<Search searchHandler={searchSale} bind:search />
</div>
<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl overflow-x-auto">
	<table>
		<thead class="border-b border-stone-700">
			<tr>
				<th class="p-2 text-left">Folio</th>
				<th class="p-2 text-left">Monto</th>
				<th class="p-2 text-left">Descuento</th>
				<th class="p-2 text-left">Fecha</th>
				<th class="py-2" />
				<th class="py-2" />
			</tr>
		</thead>
		<tbody>
			{#each sales as sale}
				<SaleRow
					id={sale.venta_id}
					total={sale.venta_monto}
					discount={sale.venta_descuento}
					date={sale.venta_fecha}
				/>
			{/each}
		</tbody>
	</table>
</div>
