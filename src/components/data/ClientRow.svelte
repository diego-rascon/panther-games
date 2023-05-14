<script lang="ts">
	import { clientsStore } from '$lib/stores';
	import { popup } from '@skeletonlabs/skeleton';
	import Dropdown from '../dropdown/Dropdown.svelte';
	import DropdownItem from '../dropdown/DropdownItem.svelte';
	import Icon from '@iconify/svelte';
	import crownMinimalisticBold from '@iconify/icons-solar/crown-minimalistic-bold';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import userCheckOutline from '@iconify/icons-solar/user-check-outline';

	export let editClient: (productId: number) => void;
	export let deleteClient: (productId: number) => void = () => {};
	export let activateClient: (productId: number) => void = () => {};
	export let id: number;

	$: client = $clientsStore.find((clientEntry: any) => clientEntry.cliente_id === id);
	$: name = client?.cliente_nombre;
	$: email = client?.cliente_email;
	$: phone = client?.cliente_telefono;
	$: active = client?.cliente_activo;
	$: member = client?.cliente_miembro;

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
	class="relative border-t border-stone-800 transition-all {dropdownVisible
		? 'variant-soft-primary'
		: 'hover:bg-stone-800'} {!active ? ' text-stone-400' : ''}"
>
	<td class="p-4 text-left select-text">{id}</td>
	<td class="text-left select-text">{name}</td>
	<td class="text-left select-text">{email}</td>
	<td class="text-left select-text">{phone}</td>
	<td class="text-right text-primary-500">
		{#if member}
			<Icon icon={crownMinimalisticBold} />
		{/if}
	</td>
	<td class="pr-4 text-right" bind:this={container}>
		<button
			on:click={toggleDropdown}
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
							editClient(id);
							toggleDropdown();
						}}
					/>
					{#if active}
						<DropdownItem
							text="Eliminar"
							icon={trashBinMinimalisticLinear}
							on:click={() => {
								deleteClient(id);
								toggleDropdown();
							}}
						/>
					{:else}
						<DropdownItem
							text="Activar"
							icon={userCheckOutline}
							on:click={() => {
								activateClient(id);
								toggleDropdown();
							}}
						/>
					{/if}
				</Dropdown>
			</div>
		{/if}
	</td>
</tr>
