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
	import RentRow from '../../../components/data/RentRow.svelte';
	import RentDetail from '../../../components/data/RentDetail.svelte';

	export let data;
	let { rents } = data;
	$: ({ rents } = data);

	$: rentsStore.set(rents);
	$: pendingRents = rents.filter(
		(rent: any) =>
			rent.renta_activa && !rent.renta_completada && new Date(rent.renta_fecha_final) < new Date()
	);
	$: filteredPendingRents = pendingRents;
	$: activeRents = rents.filter(
		(rent: any) =>
			rent.renta_activa &&
			!rent.renta_completada &&
			new Date(rent.renta_fecha_inicio) <= new Date() &&
			new Date(rent.renta_fecha_final) >= new Date()
	);
	$: filteredActiveRents = activeRents;
	$: previousRents = rents.filter((rent: any) => rent.renta_activa && rent.renta_completada);
	$: filteredPreviousRents = previousRents;
	$: unactiveRents = rents.filter((rent: any) => !rent.renta_activa);
	$: filteredUnactiveRents = unactiveRents;

	let showingDetail = false;

	const toggleShowDetail = () => {
		showingDetail = !showingDetail;
	};

	let tempRentId: number;
	let tempMemberId: number;
	let tempRentTotal: number;
	let tempRentQuantity: number;

	let finishingRent = false;

	const toggleFinishRent = () => {
		finishingRent = !finishingRent;
	};

	const finishRent = async () => {
		toggleFinishRent();
		const { error: rentError } = await supabase
			.from('renta')
			.update({ renta_completada: true })
			.eq('renta_id', tempRentId);
		if (rentError) console.log(rentError.message);
		const { data: rentDetail, error: detailError } = await supabase
			.from('renta_detalle')
			.select('producto_id')
			.eq('renta_id', tempRentId);
		if (detailError) console.log(detailError.message);
		if (rentDetail) {
			for (const rentedProduct of rentDetail) {
				const productId = rentedProduct.producto_id;
				const { data: product, error: productError } = await supabase
					.from('producto')
					.select('producto_stock')
					.eq('producto_id', productId)
					.single();
				if (productError) console.log(productError.message);
				if (product) {
					const newStock = product.producto_stock + 1;
					const { data: stock, error: stockError } = await supabase
						.from('producto')
						.update({ producto_stock: newStock })
						.eq('producto_id', productId)
						.select();
					if (stockError) console.log(stockError.message);
					if (stock) {
						const finishedRent = rents.findIndex((rent: any) => rent.renta_id === tempRentId);
						rents[finishedRent].renta_completada = true;
						toastStore.trigger(rentFinished);
					}
				}
			}
		}
	};

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteRent = async () => {
		toggleDeleteConfirmation();
		const { error } = await supabase
			.from('renta')
			.update({ renta_activa: false })
			.eq('renta_id', tempRentId);
		if (error) console.log(error.message);
		const activatedRent = rents.findIndex((rent: any) => rent.renta_id === tempRentId);
		rents[activatedRent].renta_activa = false;
		toastStore.trigger(rentDeleted);
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateRent = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('renta')
			.update({ renta_activa: true })
			.eq('renta_id', tempRentId);
		if (error) console.log(error.message);
		const activatedRent = rents.findIndex((rent: any) => rent.renta_id === tempRentId);
		rents[activatedRent].renta_activa = true;
		toastStore.trigger(rentActivated);
	};

	let search: string;

	const searchRent = (search: string) => {
		const searchWords = search.split(' ');

		filteredActiveRents = activeRents.filter((rent: any) =>
			searchWords.every(
				(word: string) =>
					rent.renta_id.toString().includes(word) ||
					new Date(String(rent.renta_fecha_inicio)).toLocaleDateString('en-GB').includes(word) ||
					new Date(String(rent.renta_fecha_final)).toLocaleDateString('en-GB').includes(word) ||
					rent.renta_cantidad.toString().includes(word) ||
					rent.renta_descuento.toString().includes(word) ||
					rent.renta_monto.toString().includes(word)
			)
		);
	};

	const rentFinished: ToastSettings = {
		message: 'Se marcó la renta como terminada exitosamente',
		background: 'variant-filled-primary'
	};

	const rentDeleted: ToastSettings = {
		message: 'Se eliminó la renta exitosamente',
		background: 'variant-filled-primary'
	};

	const rentActivated: ToastSettings = {
		message: 'Se activó la renta exitosamente',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Rentas" />
	<Search searchHandler={searchRent} bind:search />
</div>
<div class="mt-[60px] flex-col space-y-4">
	{#if filteredActiveRents.length === 0 && filteredUnactiveRents.length === 0}
		<NoResultsMessage search={search !== ''} />
	{:else}
		{#if filteredPendingRents.length > 0}
			<SectionSubtitle text="Pendientes" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table class="text-pink-200">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Folio</th>
							<th class="text-left">Fecha de renta</th>
							<th class="text-left">Fecha de entrega</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Pago</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Total</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredPendingRents as pendingRent (pendingRent.renta_id)}
							<RentRow
								finishRent={(rentId) => {
									tempRentId = rentId;
									toggleFinishRent();
								}}
								toggleDetail={(rentId, memberId, rentTotal, rentQuantity) => {
									toggleShowDetail();
									tempRentId = rentId;
									tempMemberId = memberId;
									tempRentTotal = rentTotal;
									tempRentQuantity = rentQuantity;
								}}
								toggleRent={(rentId) => {
									toggleDeleteConfirmation();
									tempRentId = rentId;
								}}
								rentId={pendingRent.renta_id}
								pending={true}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class="h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredActiveRents.length > 0}
			<SectionSubtitle text="Activas" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table class="text-indigo-200">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Folio</th>
							<th class="text-left">Fecha de renta</th>
							<th class="text-left">Fecha de entrega</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Pago</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Total</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredActiveRents as activeRent (activeRent.renta_id)}
							<RentRow
								finishRent={(rentId) => {
									tempRentId = rentId;
									toggleFinishRent();
								}}
								toggleDetail={(rentId, memberId, rentTotal, rentQuantity) => {
									toggleShowDetail();
									tempRentId = rentId;
									tempMemberId = memberId;
									tempRentTotal = rentTotal;
									tempRentQuantity = rentQuantity;
								}}
								toggleRent={(rentId) => {
									toggleDeleteConfirmation();
									tempRentId = rentId;
								}}
								rentId={activeRent.renta_id}
								pending={true}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class="h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredPreviousRents.length > 0}
			<SectionSubtitle text="Historial" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table>
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Folio</th>
							<th class="text-left">Fecha de renta</th>
							<th class="text-left">Fecha de entrega</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Pago</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Total</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredPreviousRents as previousRent (previousRent.renta_id)}
							<RentRow
								toggleDetail={(rentId, memberId, rentTotal, rentQuantity) => {
									toggleShowDetail();
									tempRentId = rentId;
									tempMemberId = memberId;
									tempRentTotal = rentTotal;
									tempRentQuantity = rentQuantity;
								}}
								toggleRent={(rentaId) => {
									toggleDeleteConfirmation();
									tempRentId = rentaId;
								}}
								rentId={previousRent.renta_id}
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
			<SectionSubtitle text="Desactivadas" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table class="text-stone-400">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">Folio</th>
							<th class="text-left">Fecha de renta</th>
							<th class="text-left">Fecha de entrega</th>
							<th class="text-left">Cantidad</th>
							<th class="text-left">Pago</th>
							<th class="text-left">Descuento</th>
							<th class="text-left">Total</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredUnactiveRents as previousRent (previousRent.renta_id)}
							<RentRow
								toggleDetail={(rentId, memberId, rentTotal, rentQuantity) => {
									toggleShowDetail();
									tempRentId = rentId;
									tempMemberId = memberId;
									tempRentTotal = rentTotal;
									tempRentQuantity = rentQuantity;
								}}
								toggleRent={(rentaId) => {
									toggleActivateConfirmation();
									tempRentId = rentaId;
								}}
								rentId={previousRent.renta_id}
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
		<RentDetail
			closeHandler={toggleShowDetail}
			rentId={tempRentId}
			memberId={tempMemberId}
			total={tempRentTotal}
			quantity={tempRentQuantity}
		/>
	</DarkenSreen>
{/if}
{#if finishingRent}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleFinishRent}
			confirmHandler={finishRent}
			title="Terminar Renta"
			text="¿Seguro de que desea marcar la renta como terminada?"
		/>
	</DarkenSreen>
{/if}
{#if deleteConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleDeleteConfirmation}
			confirmHandler={deleteRent}
			title="Eliminar Renta"
			text="¿Seguro de que desea eliminar la renta?"
		/>
	</DarkenSreen>
{/if}
{#if activateConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleActivateConfirmation}
			confirmHandler={activateRent}
			title="Activar Renta"
			text="¿Seguro de que desea activar la renta?"
		/>
	</DarkenSreen>
{/if}
