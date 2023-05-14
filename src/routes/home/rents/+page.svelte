<script lang="ts">
	import { rentsStore } from '$lib/stores';
	import { supabase } from '$lib/db';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import Search from '../../../components/utils/Search.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import NoResultsMessage from '../../../components/utils/NoResultsMessage.svelte';
	import SaleRow from '../../../components/data/SaleRow.svelte';
	import SaleDetail from '../../../components/data/SaleDetail.svelte';
	import RentRow from '../../../components/data/RentRow.svelte';

	export let data;
	let { rents } = data;
	$: ({ rents } = data);

	$: rentsStore.set(rents);
	$: activeRents = rents.filter((rent: any) => rent.renta_activa);
	$: unactiveRents = rents.filter((rent: any) => !rent.renta_activa);
	$: filteredActiveRents = activeRents;
	$: filteredUnactiveRents = unactiveRents;

	let showingDetail = false;

	const toggleShowDetail = () => {
		showingDetail = !showingDetail;
	};

	let tempRentId: number;
	let tempRentTotal: number;
	let tempRentQuantity: number;

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteRent = async () => {
		toggleDeleteConfirmation();
		const { error } = await supabase
			.from('venta')
			.update({ venta_activa: false })
			.eq('venta_id', tempRentId);
		if (error) console.log(error.message);
		const removedSale = rents.find((sale: any) => sale.cliente_id === tempRentId);
		if (removedSale) removedSale.venta_activo = false;
		rents = rents;
		toastStore.trigger(saleDeleted);
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateRent = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('cliente')
			.update({ cliente_activo: true })
			.eq('cliente_id', tempRentId);
		if (error) console.log(error.message);
		const activatedClient = rents.find((client: any) => client.cliente_id === tempRentId);
		if (activatedClient) activatedClient.cliente_activo = true;
		rents = rents;
		toastStore.trigger(saleActivated);
	};

	let search: string;

	const searchSale = (search: string) => {
		const searchWords = search.split(' ');

		filteredActiveRents = activeRents.filter((sale: any) =>
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

		filteredUnactiveRents = unactiveRents.filter((sale: any) =>
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

	$: console.log(unactiveRents);
</script>

<div
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Rentas" />
	<Search searchHandler={searchSale} bind:search />
</div>
<div class="mt-[60px] flex-col space-y-4">
	{#if filteredActiveRents.length === 0 && filteredUnactiveRents.length === 0}
		<NoResultsMessage search={search !== ''} />
	{:else}
		{#if filteredActiveRents.length > 0}
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table>
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Fecha de renta</th>
							<th class="text-left">Fecha de entrega</th>
							<th class="text-left">Total</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Pago</th>
							<th class="" />
						</tr>
					</thead>
					<tbody>
						{#each filteredActiveRents as activeRent (activeRent.renta_id)}
							<RentRow
								toggleDetail={(rentId, saleTotal, saleQuantity) => {
									toggleShowDetail();
									tempRentId = rentId;
									tempRentTotal = saleTotal;
									tempRentQuantity = saleQuantity;
								}}
								toggleRent={(saleId) => {
									toggleDeleteConfirmation();
									tempRentId = saleId;
								}}
								rentId={activeRent.renta_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class="h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredUnactiveRents.length > 0}
			<SectionSubtitle text="Ventas Desactivadas" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table>
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
						{#each filteredUnactiveRents as deactivatedSale (deactivatedSale.venta_id)}
							<SaleRow
								toggleDetail={(saleID, saleTotal, saleQuantity) => {
									toggleShowDetail();
									tempRentId = saleID;
									tempRentTotal = saleTotal;
									tempRentQuantity = saleQuantity;
									console.log(saleQuantity);
								}}
								toggleSale={(saleId) => {
									toggleActivateConfirmation();
									tempRentId = saleId;
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
			saleId={tempRentId}
			total={tempRentTotal}
			quantity={tempRentQuantity}
		/>
	</DarkenSreen>
{/if}
{#if deleteConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleDeleteConfirmation}
			confirmHandler={deleteRent}
			title="Eliminar Venta"
			text="¿Seguro de que desea eliminar la venta?"
		/>
	</DarkenSreen>
{/if}
{#if activateConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleActivateConfirmation}
			confirmHandler={activateRent}
			title="Activar Venta"
			text="¿Seguro de que desea activar la venta?"
		/>
	</DarkenSreen>
{/if}
