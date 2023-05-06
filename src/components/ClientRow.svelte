<script lang="ts">
	import { clientsStore } from '$lib/stores';
	import { popup } from '@skeletonlabs/skeleton';
	import Dropdown from './dropdown/Dropdown.svelte';
	import DropdownItem from './dropdown/DropdownItem.svelte';
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

	$: client = $clientsStore.find((item: any) => item.cliente_id === id);
	$: name = client?.cliente_nombre;
	$: email = client?.cliente_email;
	$: phone = client?.cliente_telefono;
	$: member = client?.cliente_miembro;
	$: active = client?.cliente_activo;

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
	<td class="text-left select-text">{name}</td>
	<td class="text-left select-text">{email}</td>
	<td class="text-left select-text">{phone}</td>
	<td class="text-right">
		{#if member}
			<Icon icon={crownMinimalisticBold} color="#e6d92e" />
		{/if}
	</td>
	<td class="p-4 text-right">
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
			<DropdownItem
				text="Editar"
				icon={pen2Linear}
				on:click={() => {
					editClient(id);
				}}
			/>
			{#if active}
				<DropdownItem
					text="Eliminar"
					icon={trashBinMinimalisticLinear}
					on:click={() => {
						deleteClient(id);
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
