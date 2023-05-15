<script lang="ts">
	import { salesStore } from '$lib/stores';
	import { supabase } from '$lib/db';
	import { Paginator, toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import Search from '../../../components/utils/Search.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import NoResultsMessage from '../../../components/utils/NoResultsMessage.svelte';
	import SaleRow from '../../../components/data/SaleRow.svelte';
	import SaleDetail from '../../../components/data/SaleDetail.svelte';
	import type { PaginationSettings } from '@skeletonlabs/skeleton/dist/components/Paginator/types';
	import dayjs from 'dayjs';

	export let data;
	let { sales } = data;
	$: ({ sales } = data);

	$: salesStore.set(sales);
	$: activeSales = sales.filter((sale: any) => sale.venta_activa);
	$: deactivatedSales = sales.filter((sale: any) => !sale.venta_activa);
	$: filteredActiveSales = activeSales;
	$: filteredDeactivatedSales = deactivatedSales;

	let pageSettings = {
		offset: 0,
		limit: 10,
		size: sales.filter((sale: any) => sale.venta_activa).length,
		amounts: [10, 15, 20, 25]
	} as PaginationSettings;

	$: pageSettings.size = filteredActiveSales.length;

	$: paginatedActiveSales = filteredActiveSales.slice(
		pageSettings.offset * pageSettings.limit,
		pageSettings.offset * pageSettings.limit + pageSettings.limit
	);

	let showingDetail = false;

	const toggleShowDetail = () => {
		showingDetail = !showingDetail;
	};

	let tempClientId: number;
	let tempSaleId: number;
	let tempSaleTotal: number;
	let tempSaleQuantity: number;

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteSale = async () => {
		toggleDeleteConfirmation();
		const { error } = await supabase
			.from('venta')
			.update({ venta_activa: false })
			.eq('venta_id', tempSaleId);
		if (error) console.log(error.message);
		const removedSale = sales.findIndex((sale: any) => sale.venta_id === tempSaleId);
		sales[removedSale].venta_activa = false;
		toastStore.trigger(saleDeleted);
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateSale = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('venta')
			.update({ venta_activa: true })
			.eq('venta_id', tempSaleId);
		if (error) console.log(error.message);
		const removedSale = sales.findIndex((sale: any) => sale.venta_id === tempSaleId);
		sales[removedSale].venta_activa = true;
		toastStore.trigger(saleActivated);
	};

	let search: string;

	const searchSale = (search: string) => {
		const searchWords = search.split(' ');

		filteredActiveSales = activeSales.filter((sale: any) => {
			const date = dayjs(String(sale.venta_fecha));
			const formattedDate = date.format('DD/MM/YYYY');

			return searchWords.every(
				(word: string) =>
					sale.venta_id.toString().includes(word) ||
					formattedDate.includes(word) ||
					sale.venta_cantidad.toString().includes(word) ||
					sale.venta_descuento.toString().includes(word) ||
					sale.venta_monto.toString().includes(word)
			);
		});

		filteredDeactivatedSales = deactivatedSales.filter((sale: any) => {
			const date = dayjs(String(sale.venta_fecha));
			const formattedDate = date.format('DD/MM/YYYY');

			return searchWords.every(
				(word: string) =>
					sale.venta_id.toString().includes(word) ||
					formattedDate.includes(word) ||
					sale.venta_cantidad.toString().includes(word) ||
					sale.venta_descuento.toString().includes(word) ||
					sale.venta_monto.toString().includes(word)
			);
		});
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
		{#if filteredActiveSales.length > 0}
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table>
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Folio</th>
							<th class="text-left">Fecha</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Pago</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Total</th>
						</tr>
					</thead>
					<tbody>
						{#each paginatedActiveSales as activeSale (activeSale.venta_id)}
							<SaleRow
								toggleDetail={(clientId, saleId, saleTotal, saleQuantity) => {
									toggleShowDetail();
									tempClientId = clientId;
									tempSaleId = saleId;
									tempSaleTotal = saleTotal;
									tempSaleQuantity = saleQuantity;
								}}
								toggleSale={(saleId) => {
									toggleDeleteConfirmation();
									tempSaleId = saleId;
								}}
								id={activeSale.venta_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class="h-7" />
						</tr>
					</tbody>
				</table>
			</div>
			<Paginator bind:settings={pageSettings} />
		{/if}
		{#if filteredDeactivatedSales.length > 0}
			<SectionSubtitle text="Ventas Desactivadas" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table class="text-stone-400">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Folio</th>
							<th class="text-left">Fecha</th>
							<th class="text-left">Monto</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Pago</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredDeactivatedSales as deactivatedSale (deactivatedSale.venta_id)}
							<SaleRow
								toggleDetail={(clientId, saleId, saleTotal, saleQuantity) => {
									toggleShowDetail();
									tempClientId = clientId;
									tempSaleId = saleId;
									tempSaleTotal = saleTotal;
									tempSaleQuantity = saleQuantity;
								}}
								toggleSale={(saleId) => {
									toggleActivateConfirmation();
									tempSaleId = saleId;
								}}
								id={deactivatedSale.venta_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class="h-7" />
						</tr>
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
			clientId={tempClientId}
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
			confirmHandler={deleteSale}
			title="Eliminar Venta"
			text="¿Seguro de que desea eliminar la venta?"
		/>
	</DarkenSreen>
{/if}
{#if activateConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleActivateConfirmation}
			confirmHandler={activateSale}
			title="Activar Venta"
			text="¿Seguro de que desea activar la venta?"
		/>
	</DarkenSreen>
{/if}
