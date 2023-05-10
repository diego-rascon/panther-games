<script lang="ts">
	import { salesStore } from '$lib/stores';
	import { supabase } from '$lib/db';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import SaleRow from '../../../components/SaleRow.svelte';
	import Search from '../../../components/utils/Search.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import NoResultsMessage from '../../../components/utils/NoResultsMessage.svelte';
	import SaleDetail from '../../../components/SaleDetail.svelte';

	export let data;
	let { sales } = data;
	$: ({ sales } = data);

	$: salesStore.set(sales);
	$: activeSales = sales.filter((sale: any) => sale.venta_activa);
	$: deactivatedSales = sales.filter((sale: any) => !sale.venta_activa);
	$: filteredActiveSales = activeSales;
	$: filteredDeactivatedSales = deactivatedSales;

	let showingDetail = false;

	const toggleShowDetail = () => {
		showingDetail = !showingDetail;
	};

	let tempSaleId: number;
	let tempSaleTotal: number;
	let tempSaleQuantity: number;

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteClient = async () => {
		toggleDeleteConfirmation();
		const { error } = await supabase
			.from('cliente')
			.update({ cliente_activo: false })
			.eq('cliente_id', tempSaleId);
		if (error) console.log(error.message);
		const removedClient = sales.find((sale: any) => sale.cliente_id === tempSaleId);
		if (removedClient) removedClient.cliente_activo = false;
		sales = sales;
		toastStore.trigger(saleDeleted);
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateClient = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('cliente')
			.update({ cliente_activo: true })
			.eq('cliente_id', tempSaleId);
		if (error) console.log(error.message);
		const activatedClient = sales.find((client: any) => client.cliente_id === tempSaleId);
		if (activatedClient) activatedClient.cliente_activo = true;
		sales = sales;
		toastStore.trigger(saleActivated);
	};

	let search: string;

	const searchSale = (search: string) => {
		const searchWords = search.split(' ');

		filteredActiveSales = activeSales.filter((sale: any) =>
			searchWords.every(
				(word: string) =>
					sale.venta_id.toString().includes(word) ||
					new Date(String(sale.venta_fecha)).toLocaleDateString('en-GB').includes(word) ||
					sale.venta_monto.toString().includes(word) ||
					sale.venta_cantidad.toString().includes(word) ||
					sale.venta_descuento.toString().includes(word) ||
					sale.cliente_id.toString().includes(word)
			)
		);

		filteredDeactivatedSales = deactivatedSales.filter((sale: any) =>
			searchWords.every(
				(word: string) =>
					sale.venta_id.toString().includes(word) ||
					new Date(String(sale.venta_fecha)).toLocaleDateString('en-GB').includes(word) ||
					sale.venta_monto.toString().includes(word) ||
					sale.venta_cantidad.toString().includes(word) ||
					sale.venta_descuento.toString().includes(word) ||
					sale.cliente_id.toString().includes(word)
			)
		);
	};

	const saleDeleted: ToastSettings = {
		message: 'Se eliminó la venta exitosamente',
		background: 'variant-filled-primary'
	};

	const saleActivated: ToastSettings = {
		message: 'Se activó la venta exitosamente',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Ventas" />
	<Search searchHandler={searchSale} bind:search />
</div>
<div class="mt-[60px] flex-col space-y-4">
	{#if filteredActiveSales.length === 0 && filteredDeactivatedSales.length === 0}
		<NoResultsMessage search={search !== ''} />
	{:else}
		{#if filteredActiveSales.length !== 0}
			<div class="flex flex-col min-w-full rounded-xl overflow-x-auto">
				<table class="bg-stone-900">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Folio</th>
							<th class="text-left">Fecha</th>
							<th class="text-left">Monto</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Pago</th>
							<th class="text-left">Cliente</th>
							<th class="" />
						</tr>
					</thead>
					<tbody>
						{#each filteredActiveSales as sale (sale.venta_id)}
							<SaleRow
								toggleDetail={(clientId, saleTotal, saleQuantity) => {
									toggleShowDetail();
									tempSaleId = clientId;
									tempSaleTotal = saleTotal;
									tempSaleQuantity = saleQuantity;
								}}
								toggleSale={(saleId) => {
									toggleDeleteConfirmation();
									tempSaleId = saleId;
								}}
								id={sale.venta_id}
							/>
						{/each}
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredDeactivatedSales.length !== 0}
			<SectionSubtitle text="Ventas Desactivados" />
			<div class="flex flex-col min-w-full rounded-xl overflow-x-auto">
				<table class="bg-stone-900">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Folio</th>
							<th class="text-left">Fecha</th>
							<th class="text-left">Monto</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Pago</th>
							<th class="text-left">Cliente</th>
							<th class="" />
						</tr>
					</thead>
					<tbody>
						{#each filteredDeactivatedSales as sale (sale.venta_id)}
							<SaleRow
								toggleDetail={(saleID, saleTotal, saleQuantity) => {
									toggleShowDetail();
									tempSaleId = saleID;
									tempSaleTotal = saleTotal;
									tempSaleQuantity = saleQuantity;
									console.log(saleQuantity);
								}}
								toggleSale={(clientId) => {
									toggleActivateConfirmation();
									tempSaleId = clientId;
								}}
								id={sale.venta_id}
							/>
						{/each}
					</tbody>
				</table>
			</div>
		{/if}
	{/if}
</div>
{#if showingDetail}
	<DarkenSreen>
		<SaleDetail
			closeHandler={toggleShowDetail}
			saleId={tempSaleId}
			total={tempSaleTotal}
			quantity={tempSaleQuantity}
		/>
	</DarkenSreen>
{/if}
{#if deleteConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleDeleteConfirmation}
			confirmHandler={deleteClient}
			title="Eliminar Venta"
			text="¿Seguro de que desea eliminar la venta?"
		/>
	</DarkenSreen>
{/if}
{#if activateConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleActivateConfirmation}
			confirmHandler={activateClient}
			title="Activar Venta"
			text="¿Seguro de que desea activar la venta?"
		/>
	</DarkenSreen>
{/if}
