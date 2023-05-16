<script lang="ts">
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import dayjs from 'dayjs';

	export let deleteCaja: (cajaId: number) => void;
	export let id: number;

	export let date: string;
	$: formattedDate = dayjs(date).format('DD/MM/YYYY');

	export let cajaStart: number;
	$: formattedStart = cajaStart.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	export let cajaTotal: number;
	$: formattedTotal = cajaTotal.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
</script>

<tr class="border-t border-stone-800 transition-all hover:bg-stone-800">
	<td class="p-4 text-left select-text">{formattedDate}</td>
	<td class="text-left select-text">{formattedStart}</td>
	<td class="text-left select-text">{formattedTotal}</td>
	<td class="pr-4 text-right">
		<button
			on:click|stopPropagation={() => deleteCaja(id)}
			class="btn p-1 rounded-full variant-soft-surface"
		>
			<Icon icon={trashBinMinimalisticLinear} height={20} hFlip={true} />
		</button>
	</td>
</tr>
