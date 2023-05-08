<script lang="ts">
	import { membersStore } from '$lib/stores';
	import { popup } from '@skeletonlabs/skeleton';
	import Dropdown from './dropdown/Dropdown.svelte';
	import DropdownItem from './dropdown/DropdownItem.svelte';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import userCheckOutline from '@iconify/icons-solar/user-check-outline';
	import dayjs from 'dayjs';

	export let editMember: (memberId: number) => void;
	export let deleteMember: (memberId: number) => void = () => {};
	export let activateClient: (memberId: number) => void = () => {};
	export let id: number;

	$: member = $membersStore.find((memberEntry: any) => memberEntry.miembro_id === id);
	$: name = member?.cliente_nombre;
	$: email = member?.cliente_email;
	$: phone = member?.cliente_telefono;
	$: active = member?.cliente_activo;
	$: startDate = dayjs(String(member?.miembro_fecha_inicio));
	$: endDate = dayjs(String(member?.miembro_fecha_final));
	$: formattedStartDate = startDate.format('DD/MM/YYYY');
	$: formattedEndDate = endDate.format('DD/MM/YYYY');

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
	<td class="p-4 text-left select-text">{id}</td>
	<td class="text-left select-text">{name}</td>
	<td class="text-left select-text">{email}</td>
	<td class="text-left select-text">{phone}</td>
	<td class="text-left select-text">{formattedStartDate}</td>
	<td class="text-left select-text">{formattedEndDate}</td>
	<td class="pr-4 text-right">
		<button
			use:popup={{ ...dropdown, target: `client-dropdown-${id}` }}
			class="btn p-1 rounded-full {selected
				? 'variant-soft-primary'
				: 'hover:variant-filled-surface'}"
		>
			<Icon icon={menuDotsBold} rotate={1} height={20} />
		</button>
	</td>
	<div data-popup={`client-dropdown-${id}`}>
		<Dropdown>
			<DropdownItem
				text="Editar"
				icon={pen2Linear}
				on:click={() => {
					editMember(id);
				}}
			/>
			{#if active}
				<DropdownItem
					text="Eliminar"
					icon={trashBinMinimalisticLinear}
					on:click={() => {
						deleteMember(id);
					}}
				/>
			{:else}
				<DropdownItem
					text="Activar"
					icon={userCheckOutline}
					on:click={() => {
						activateClient(id);
					}}
				/>
			{/if}
		</Dropdown>
	</div>
</tr>
