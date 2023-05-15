<script lang="ts">
	import { rentsStore } from '$lib/stores';
	import dayjs from 'dayjs';
	import Icon from '@iconify/svelte';
	import billCheckOutline from '@iconify/icons-solar/bill-check-outline';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import restartLinear from '@iconify/icons-solar/restart-linear';

	export let toggleDetail: (rentId: number, total: number, quantity: number) => void;
	export let finishRent: (rentId: number) => void = () => {};
	export let toggleRent: (rentId: number) => void;
	export let rentId: number;
	export let pending = false;

	$: rent = $rentsStore.find((rentEntry: any) => rentEntry.renta_id === rentId);
	$: startDate = dayjs(String(rent?.renta_fecha_inicio));
	$: formattedStartDate = startDate.format('DD/MM/YYYY');
	$: endDate = dayjs(String(rent?.renta_fecha_final));
	$: formattedEndDate = endDate.format('DD/MM/YYYY');
	$: total = Number(rent?.renta_monto);
	$: quantity = Number(rent?.renta_cantidad);
	$: discount = rent?.renta_descuento;
	$: paymentType = rent?.renta_tarjeta ? 'Tarjeta' : 'Efectivo';
	$: memberId = rent?.miembro_id;
	$: active = rent?.renta_activa;
	$: formattedPrice = total.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
</script>

<tr
	on:click={() => {
		toggleDetail(rentId, total, quantity);
	}}
	class="border-t border-stone-800 hover:bg-stone-800 active:variant-soft-primary transition-all cursor-pointer"
>
	<td class="p-4 text-left select-text">{rentId}</td>
	<td class="text-left select-text">{formattedStartDate}</td>
	<td class="text-left select-text">{formattedEndDate}</td>
	<td class="text-left select-text">{quantity}</td>
	<td class="text-left select-text">{paymentType}</td>
	<td class="text-left select-text">{discount}%</td>
	<td class="text-left select-text">{formattedPrice}</td>
	{#if pending}
		<td class="pr-4 text-right">
			<button
				on:click|stopPropagation={() => finishRent(rentId)}
				class="btn p-1 rounded-full variant-soft-surface"
			>
				<Icon icon={billCheckOutline} height={20} />
			</button>
		</td>
	{/if}
	<td class="pr-4 text-right">
		<button
			on:click|stopPropagation={() => toggleRent(rentId)}
			class="btn p-1 rounded-full variant-soft-surface"
		>
			<Icon icon={active ? trashBinMinimalisticLinear : restartLinear} height={20} hFlip={true} />
		</button>
	</td>
</tr>
