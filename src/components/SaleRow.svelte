<script lang="ts">
	import { salesStore } from '$lib/stores';
	import { popup } from '@skeletonlabs/skeleton';
	import Dropdown from './dropdown/Dropdown.svelte';
	import DropdownItem from './dropdown/DropdownItem.svelte';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import userCheckOutline from '@iconify/icons-solar/user-check-outline';

	export let toggleDetail: (saleId: number, total: number, quantity: number) => void;
	export let toggleSale: (saleId: number) => void;
	export let id: number;

	$: sale = $salesStore.find((saleEntry: any) => saleEntry.venta_id === id);
	$: originalDate = new Date(String(sale?.venta_fecha));
	$: formattedDate = originalDate.toLocaleDateString('en-GB');
	$: total = Number(sale?.venta_monto);
	$: quantity = Number(sale?.venta_cantidad);
	$: discount = sale?.venta_descuento;
	$: paymentType = sale?.venta_tarjeta ? 'Tarjeta' : 'Efectivo';
	$: client = sale?.cliente_id;
	$: active = sale?.venta_activa;

	$: formattedPrice = total.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	let selected = false;

	let dropdown: any = {
		placement: 'top-end',
		event: 'focus-click',
		state: (e: { state: boolean }) => (selected = e.state)
	};
</script>

<tr
	on:click={() => {
		toggleDetail(id, total, quantity);
	}}
	class="border-t border-stone-800 transition-all cursor-pointer active:variant-soft-primary {selected
		? 'variant-soft-primary'
		: 'hover:bg-stone-800'}"
>
	<td class="p-4 text-left select-text">{id}</td>
	<td class="text-left select-text">{formattedDate}</td>
	<td class="text-left select-text">{formattedPrice}</td>
	<td class="text-left select-text">{quantity}</td>
	<td class="text-left select-text">{discount}%</td>
	<td class="text-left select-text">{paymentType}</td>
	<td class="text-left select-text">{client}</td>
	<td class="pr-4 text-right">
		<button
			on:click|stopPropagation
			use:popup={{ ...dropdown, target: `sale-dropdown-${id}` }}
			class="btn p-1 rounded-full {selected
				? 'variant-soft-primary'
				: 'hover:variant-filled-surface'}"
		>
			<Icon icon={menuDotsBold} rotate={1} height={20} />
		</button>
	</td>
	<div data-popup={`sale-dropdown-${id}`}>
		<Dropdown>
			{#if active}
				<DropdownItem
					text="Eliminar"
					icon={trashBinMinimalisticLinear}
					on:click={() => {
						toggleSale(id);
					}}
				/>
			{:else}
				<DropdownItem
					text="Activar"
					icon={userCheckOutline}
					on:click={() => {
						toggleSale(id);
					}}
				/>
			{/if}
		</Dropdown>
	</div>
</tr>
