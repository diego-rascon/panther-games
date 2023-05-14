<script lang="ts">
	import { membersStore } from '$lib/stores';
	import { popup } from '@skeletonlabs/skeleton';
	import Dropdown from '../dropdown/Dropdown.svelte';
	import DropdownItem from '../dropdown/DropdownItem.svelte';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import refreshOutline from '@iconify/icons-solar/refresh-outline';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import userCheckOutline from '@iconify/icons-solar/user-check-outline';
	import dayjs from 'dayjs';
	import { stop_propagation } from 'svelte/internal';

	export let toggleDetail: (memberId: number) => void;
	export let editMember: (clientId: number) => void;
	export let renewMember: (memberId: number) => void = () => {};
	export let toggleMember: (memberId: number) => void = () => {};
	export let memberId: number;
	export let clientId: number;

	$: member = $membersStore.find((memberEntry: any) => memberEntry.cliente_id === clientId);
	$: name = member?.cliente_nombre;
	$: email = member?.cliente_email;
	$: phone = member?.cliente_telefono;
	$: active = member?.miembro_activo;
	$: startDate = dayjs(String(member?.miembro_fecha_inicio));
	$: endDate = dayjs(String(member?.miembro_fecha_final));
	$: formattedStartDate = startDate.format('DD/MM/YYYY');
	$: formattedEndDate = endDate.format('DD/MM/YYYY');
	$: expired = new Date(String(member?.miembro_fecha_final)) < new Date();

	let dropdownVisible = false;
	let container: HTMLElement;

	const toggleDropdown = () => {
		dropdownVisible = !dropdownVisible;
	};

	const windowHandler = (e: any) => {
		if (container.contains(e.target) == false) dropdownVisible = false;
	};
</script>

<svelte:window on:click={windowHandler} on:wheel={windowHandler} />
<tr
	on:click={() => {
		toggleDetail(memberId);
	}}
	class="relative border-t border-stone-800 transition-all active:variant-soft-primary cursor-pointer {dropdownVisible
		? 'variant-soft-primary'
		: 'hover:bg-stone-800'} {!active || expired ? ' text-stone-400' : ''}"
>
	<td class="p-4 text-left select-text">{memberId}</td>
	<td class="text-left select-text">{name}</td>
	<td class="text-left select-text">{email}</td>
	<td class="text-left select-text">{phone}</td>
	<td class="text-left select-text">{formattedStartDate}</td>
	<td class="text-left select-text">{formattedEndDate}</td>
	<td class="pr-4 text-right" bind:this={container}>
		<button
			on:click|stopPropagation={toggleDropdown}
			class="btn p-1 rounded-full {dropdownVisible
				? 'variant-soft-primary'
				: 'hover:variant-filled-surface'}"
		>
			<Icon icon={menuDotsBold} rotate={1} height={20} />
		</button>
		{#if dropdownVisible}
			<div class="z-[999] absolute bottom-12 right-4">
				<Dropdown>
					<DropdownItem
						text="Editar"
						icon={pen2Linear}
						on:click={() => {
							editMember(clientId);
							toggleDropdown();
						}}
					/>
					{#if active && expired}
						<DropdownItem
							text="Renovar"
							icon={refreshOutline}
							on:click={() => {
								renewMember(memberId);
								toggleDropdown();
							}}
						/>
					{/if}
					{#if active}
						<DropdownItem
							text="Eliminar"
							icon={trashBinMinimalisticLinear}
							on:click={() => {
								toggleMember(memberId);
								toggleDropdown();
							}}
						/>
					{:else}
						<DropdownItem
							text="Activar"
							icon={userCheckOutline}
							on:click={() => {
								toggleMember(memberId);
								toggleDropdown();
							}}
						/>
					{/if}
				</Dropdown>
			</div>
		{/if}
	</td>
</tr>
