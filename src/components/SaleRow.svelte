<script lang="ts">
	import { salesStore } from '$lib/stores';
	import { popup } from '@skeletonlabs/skeleton';
	import Dropdown from './dropdown/Dropdown.svelte';
	import DropdownItem from './dropdown/DropdownItem.svelte';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import userCheckOutline from '@iconify/icons-solar/user-check-outline';

	export let toggleSale: (saleId: number) => void = () => {};
	export let id: number;

	$: sale = $salesStore.find((saleEntry: any) => saleEntry.venta_id === id);
	$: originalDate = new Date(String(sale?.venta_fecha));
	$: formattedDate = originalDate.toLocaleDateString('en-GB');
	$: total = sale?.venta_monto;
	$: discount = sale?.venta_descuento;
	$: paymentType = sale?.venta_tarjeta ? 'Tarjeta' : 'Efectivo';
	$: client = sale?.cliente_id;
	$: active = sale?.venta_activa;

	let selected = false;

	let dropdown: any = {
		placement: 'top-end',
		event: 'focus-click',
		state: () => (selected = !selected)
	};
</script>

<tr
	class="border-t border-stone-800 transition-all {selected
		? 'variant-soft-primary'
		: 'hover:bg-stone-800'}"
>
	<td class="p-4 text-left select-text">{id}</td>
	<td class="text-left select-text">{formattedDate}</td>
	<td class="text-left select-text">$ {total}</td>
	<td class="text-left select-text">{discount}%</td>
	<td class="text-left select-text">{paymentType}</td>
	<td class="text-left select-text">{client}</td>
	<td class="pr-4 text-right">
		<button
			on:click
			use:popup={{ ...dropdown, target: `dropdown-${id}` }}
			class="btn hover:variant-filled-surface activea:variant-filled-surface p-1 rounded-full"
		>
			<Icon icon={menuDotsBold} rotate={1} height={20} />
		</button>
	</td>
	<div data-popup={`dropdown-${id}`}>
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
