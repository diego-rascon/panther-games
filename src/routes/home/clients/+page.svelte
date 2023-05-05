<script lang="ts">
	import { supabase } from '$lib/db';
	import { toastStore, type TableSource, tableMapperValues, Table } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import Dropdown from '../../../components/dropdown/Dropdown.svelte';
	import DropdownItem from '../../../components/dropdown/DropdownItem.svelte';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import AddButton from '../../../components/AddButton.svelte';
	import AddClient from '../../../components/forms/ClientForm.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import Search from '../../../components/inputs/Search.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ClientRow from '../../../components/ClientRow.svelte';
	import { clientsStore } from '$lib/stores';

	export let data;
	let { clients } = data;
	$: ({ clients } = data);

	$: filteredClients = clients;
	$: clientsStore.set(clients);

	let name: string;
	let email: string;
	let phone: string;

	const addClient = async () => {
		toggleAddingClient();
		const { data: client } = await supabase
			.from('cliente')
			.insert({
				cliente_nombre: name,
				cliente_email: email,
				cliente_telefono: phone,
				cliente_miembro: false
			})
			.select()
			.single();
		if (client) {
			clients = [client, ...clients];
			toastStore.trigger(clientAdded);
		}
	};

	let search: string;

	const searchClient = (search: string) => {
		filteredClients = clients.filter(
			(client) =>
				client.cliente_nombre.toLowerCase().includes(search.toLowerCase()) ||
				client.cliente_email.toLowerCase().includes(search.toLowerCase()) ||
				client.cliente_telefono.toLowerCase().includes(search.toLowerCase())
		);
	};

	let addingClient = false;

	const toggleAddingClient = () => {
		addingClient = !addingClient;
	};

	const clientAdded: ToastSettings = {
		message: 'Un nuevo cliente fue registrado exitosamente',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Clientes" />
	<Search searchHandler={searchClient} bind:search />
</div>
<div class="mt-[60px] flex flex-col min-w-full mb-20 bg-stone-900 rounded-xl overflow-x-auto">
	<table>
		<thead>
			<tr class="text-lg">
				<th class="p-4 text-left">ID</th>
				<th class="text-left">Nombre</th>
				<th class="text-left">Correo</th>
				<th class="text-left">Telefono</th>
				<th class="" />
				<th class="" />
			</tr>
		</thead>
		<tbody>
			{#each filteredClients as client}
				<tr class="border-t border-stone-800 hover:variant-soft-primary">
					<ClientRow
						id={client.cliente_id}
						name={client.cliente_nombre}
						email={client.cliente_email}
						phone={client.cliente_telefono}
						member={client.cliente_miembro}
					/>
				</tr>
			{/each}
		</tbody>
	</table>
</div>
<div data-popup="dropdown">
	<Dropdown>
		<DropdownItem
			text="Editar"
			icon={pen2Linear}
			on:click={() => {
				console.log('Editar');
			}}
		/>
		<DropdownItem
			text="Eliminar"
			icon={trashBinMinimalisticLinear}
			on:click={() => {
				console.log('Eliminar');
			}}
		/>
	</Dropdown>
</div>
<div class="fixed bottom-0 right-0">
	<AddButton on:click={toggleAddingClient} />
</div>
{#if addingClient}
	<DarkenSreen>
		<AddClient
			cancelHandler={toggleAddingClient}
			confirmHandler={addClient}
			bind:name
			bind:email
			bind:phone
		/>
	</DarkenSreen>
{/if}
