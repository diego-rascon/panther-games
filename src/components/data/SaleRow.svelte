<script lang="ts">
	import { readUser, salesStore } from '$lib/stores';
	import dayjs from 'dayjs';
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import restartLinear from '@iconify/icons-solar/restart-linear';

	export let toggleDetail: (
		clientId: number,
		saleId: number,
		date: string,
		total: number,
		paymentType: string,
		quantity: number
	) => void;
	export let toggleSale: (saleId: number) => void;
	export let id: number;

	$: sale = $salesStore.find((saleEntry: any) => saleEntry.venta_id === id);
	$: originalDate = dayjs(String(sale?.venta_fecha));
	$: formattedDate = originalDate.format('DD/MM/YYYY');
	$: total = Number(sale?.venta_monto);
	$: quantity = Number(sale?.venta_cantidad);
	$: discount = sale?.venta_descuento;
	$: paymentType = sale?.venta_tarjeta ? 'Tarjeta' : 'Efectivo';
	$: client = Number(sale?.cliente_id);
	$: active = sale?.venta_activa;
	$: formattedPrice = total.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
</script>

<tr
	on:click={() => {
		toggleDetail(client, id, formattedDate, total, paymentType, quantity);
	}}
	class="border-t border-stone-800 hover:bg-stone-800 active:variant-soft-primary transition-all cursor-pointer"
>
	<td class="p-4 text-left select-text">{id}</td>
	<td class="text-left select-text">{formattedDate}</td>
	<td class="text-left select-text">{quantity}</td>
	<td class="text-left select-text">{paymentType}</td>
	<td class="text-left select-text">{discount}%</td>
	<td class="text-left select-text">{formattedPrice}</td>
	{#if !$readUser}
		<td class="pr-4 text-right">
			<button
				on:click|stopPropagation={() => toggleSale(id)}
				class="btn p-1 rounded-full variant-soft-surface"
			>
				<Icon icon={active ? trashBinMinimalisticLinear : restartLinear} height={20} hFlip={true} />
			</button>
		</td>
	{/if}
</tr>
