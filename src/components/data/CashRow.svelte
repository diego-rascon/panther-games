<script lang="ts">
	import { popup } from '@skeletonlabs/skeleton';
	import dayjs from 'dayjs';
	import Dropdown from './dropdown/Dropdown.svelte';
	import DropdownItem from './dropdown/DropdownItem.svelte';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';

	export let deleteCaja: (cajaId: number) => void;
	export let id: number;

	export let date: string;
	$: formattedDate = dayjs(date).format('DD/MM/YYYY');

	export let cajaStart: number;
	$: formattedStart = cajaStart.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	export let cajaTotal: number;
	$: formattedTotal = cajaTotal.toLocaleString('en-US', { style: 'currency', currency: 'USD' });

	let selected = false;

	let dropdown: any = {
		placement: 'top-end',
		event: 'focus-click',
		state: (e: { state: boolean }) => (selected = e.state)
	};
</script>

<tr
	class="border-t border-stone-800 transition-all {selected
		? 'variant-soft-primary'
		: 'hover:bg-stone-800'}"
>
	<td class="p-4 text-left select-text">{formattedDate}</td>
	<td class="text-left select-text">{formattedStart}</td>
	<td class="text-left select-text">{formattedTotal}</td>
	<td class="pr-4 text-right">
		<button
			on:click|stopPropagation
			use:popup={{ ...dropdown, target: `caja-dropdown-${id}` }}
			class="btn p-1 rounded-full {selected
				? 'variant-soft-primary'
				: 'hover:variant-filled-surface'}"
		>
			<Icon icon={menuDotsBold} rotate={1} height={20} />
		</button>
	</td>
	<div data-popup={`caja-dropdown-${id}`}>
		<Dropdown>
			<DropdownItem
				text="Eliminar"
				icon={trashBinMinimalisticLinear}
				on:click={() => deleteCaja(id)}
			/>
		</Dropdown>
	</div>
</tr>
