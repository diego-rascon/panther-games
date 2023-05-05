<script lang="ts">
	import { popup } from '@skeletonlabs/skeleton';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import crownMinimalisticBold from '@iconify/icons-solar/crown-minimalistic-bold';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import Dropdown from './dropdown/Dropdown.svelte';
	import DropdownItem from './dropdown/DropdownItem.svelte';
	import { clientsStore } from '$lib/stores';

	export let editClient: (productId: number) => void;
	export let deleteClient: (productId: number) => void;
	export let id: number;

	$: client = $clientsStore.find((item: any) => item.cliente_id === id);
	$: name = client?.cliente_nombre;
	$: email = client?.cliente_email;
	$: phone = client?.cliente_telefono;
	$: member = client?.cliente_miembro;

	let dropdown: any = {
		placement: 'bottom-end',
		event: 'focus-click'
	};
</script>

<td class="p-4 text-left">{id}</td>
<td class="text-left">{name}</td>
<td class="text-left">{email}</td>
<td class="text-left">{phone}</td>
<td class="text-center">
	{#if member}
		<Icon icon={crownMinimalisticBold} color="#e6d92e" />
	{/if}
</td>
<td class="p-4 text-right">
	<button
		on:click
		use:popup={{ ...dropdown, target: `dropdown-${id}` }}
		class="btn p-1 rounded-full"
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
		<DropdownItem
			text="Eliminar"
			icon={trashBinMinimalisticLinear}
			on:click={() => {
				deleteClient(id);
			}}
		/>
	</Dropdown>
</div>
