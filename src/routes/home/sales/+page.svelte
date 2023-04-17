<script lang="ts">
	import { supabase } from '$lib/db';
	import Icon from '@iconify/svelte';
	import crownMinimalisticBold from '@iconify/icons-solar/crown-minimalistic-bold';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import AddButton from '../../../components/AddButton.svelte';
	import AddClient from '../../../components/add-menus/AddClient.svelte';
	import ConfirmDialog from '../../../components/modals/confirmDialog.svelte';

	export let data;
	let { sales } = data;
	$: ({ sales } = data);

	let addMenuVisible = false;

	const openAddMenu = () => {
		addMenuVisible = true;
	};

	const closeAddMenu = () => {
		addMenuVisible = false;
	};

	let confirmationVisible = false;

	const openConfirmation = () => {
		confirmationVisible = true;
	};

	const closeConfirmation = () => {
		confirmationVisible = false;
	};

	let cancelConfirmationVisible = false;

	const openCancelConfirmation = () => {
		cancelConfirmationVisible = true;
	};

	const closeCancelConfirmation = () => {
		cancelConfirmationVisible = false;
	};

	const cancelAddClient = () => {
		closeCancelConfirmation();
		closeAddMenu();
	};
</script>

<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl overflow-x-auto">
	<table>
		<thead class="border-b border-stone-700">
			<tr>
				<th class="p-2 text-left">ID</th>
				<th class="p-2 text-left">Monto Venta</th>
				<th class="p-2 text-left">Venta Descuento(%)</th>
				<th class="p-2 text-left">Fecha</th>
				<th class="p-2 text-left">Usuario ID</th>
				<th class="p-2 text-left">Cliente ID</th>
				<th class="py-2" />
				<th class="py-2" />
			</tr>
		</thead>
		<tbody>
			{#each sales as sale}
				<tr>
					<td class="p-2 text-left">{sale.venta_id}</td>
					<td class="p-2 text-left">{sale.venta_monto}</td>
					<td class="p-2 text-left">{sale.venta_descuento}</td>
					<td class="p-2 text-left">{sale.venta_fecha}</td>
					<td class="p-2 text-center">{sale.usuario_id} </td>
                    <td class="p-2 text-center">{sale.cliente_id} </td>
				</tr>
			{/each}
		</tbody>
	</table>
</div>
