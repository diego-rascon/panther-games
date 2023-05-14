<script lang="ts">
	import { salesStore } from '$lib/stores';
	import dayjs from 'dayjs';
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import checkCircleOutline from '@iconify/icons-solar/check-circle-outline';

	export let toggleDetail: (saleId: number, total: number, quantity: number) => void;
	export let toggleSale: (saleId: number) => void;
	export let id: number;

	$: sale = $salesStore.find((saleEntry: any) => saleEntry.venta_id === id);
	$: originalDate = dayjs(String(sale?.venta_fecha));
	$: formattedDate = originalDate.format('DD/MM/YYYY');
	$: total = Number(sale?.venta_monto);
	$: quantity = Number(sale?.venta_cantidad);
	$: discount = sale?.venta_descuento;
	$: paymentType = sale?.venta_tarjeta ? 'Tarjeta' : 'Efectivo';
	$: client = sale?.cliente_id;
	$: active = sale?.venta_activa;
	$: formattedPrice = total.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
</script>

<tr
	on:click={() => {
		toggleDetail(id, total, quantity);
	}}
	class="border-t border-stone-800 hover:bg-stone-800 active:variant-soft-primary transition-all cursor-pointer {active
		? ''
		: 'text-stone-400'}"
>
	<td class="p-4 text-left select-text">{id}</td>
	<td class="text-left select-text">{formattedDate}</td>
	<td class="text-left select-text">{quantity}</td>
	<td class="text-left select-text">{paymentType}</td>
	<td class="text-left select-text">{discount}%</td>
	<td class="text-left select-text">{formattedPrice}</td>
	<td class="pr-4 text-right">
		<button
			on:click|stopPropagation={() => toggleSale(id)}
			class="btn p-1 rounded-full variant-soft-surface"
		>
			<Icon icon={active ? trashBinMinimalisticLinear : checkCircleOutline} height={20} />
		</button>
	</td>
</tr>
