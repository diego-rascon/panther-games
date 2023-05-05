<script lang="ts">
	import { supabase } from '$lib/db';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import AddButton from '../../../components/AddButton.svelte';
	import AddClient from '../../../components/forms/ClientForm.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import Search from '../../../components/inputs/Search.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ClientRow from '../../../components/ClientRow.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import { clientsStore } from '$lib/stores';
	import { nfd, nfc } from 'unorm';

	export let data;
	let { clients } = data;
	$: ({ clients } = data);

	$: clientsStore.set(clients);
	$: activeClients = clients.filter((client) => client.cliente_activo);
	$: deactivatedClients = clients.filter((client: any) => !client.cliente_activo);
	$: filteredActiveClients = activeClients;
	$: filteredDeactivatedClients = deactivatedClients;

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

	let tempClientId: number;
	let editingClient = false;

	const toggleEditingClient = () => {
		editingClient = !editingClient;
	};

	const bindValues = () => {};

	let search: string;

	const searchClient = (search: string) => {
		filteredActiveClients = activeClients.filter(
			(client) =>
				nfd(client.cliente_nombre.toLowerCase()).includes(search.toLowerCase()) ||
				client.cliente_email.toLowerCase().includes(search.toLowerCase()) ||
				client.cliente_telefono.toLowerCase().includes(search.toLowerCase())
		);
		filteredDeactivatedClients = deactivatedClients.filter(
			(client) =>
				nfd(client.cliente_nombre.toLowerCase()).includes(search.toLowerCase()) ||
				client.cliente_email.toLowerCase().includes(search.toLowerCase()) ||
				client.cliente_telefono.toLowerCase().includes(search.toLowerCase())
		);
	};

	let addingClient = false;

	const toggleAddingClient = () => {
		addingClient = !addingClient;
	};

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		console.log(clients);
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteClient = async () => {
		toggleDeleteConfirmation();
		const { error } = await supabase
			.from('cliente')
			.update({ cliente_activo: false })
			.eq('cliente_id', tempClientId);
		if (error) console.log(error.message);
		const removedClient = clients.find((client: any) => client.cliente_id === tempClientId);
		if (removedClient) removedClient.cliente_activo = false;
		clients = clients;
		toastStore.trigger(clientDeleted);
	};

	const clientAdded: ToastSettings = {
		message: 'Un nuevo cliente fue registrado exitosamente',
		background: 'variant-filled-primary'
	};

	const clientDeleted: ToastSettings = {
		message: 'Se eliminó a un cliente exitosamente',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Clientes" />
	<Search searchHandler={searchClient} bind:search />
</div>
<div class="mt-[60px] flex-col mb-20 space-y-4">
	<div class="flex flex-col min-w-full rounded-xl overflow-x-auto">
		<table class="bg-stone-900">
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
				{#each filteredActiveClients as client}
					<tr class="border-t border-stone-800 hover:variant-soft-primary">
						<ClientRow
							deleteClient={(clientId) => {
								toggleDeleteConfirmation();
								tempClientId = clientId;
							}}
							id={client.cliente_id}
						/>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
	<SectionSubtitle text="Clientes Desactivados" />
	<div class="flex flex-col min-w-full rounded-xl overflow-x-auto">
		<table class="bg-stone-900">
			<thead>
				<tr class="text-lg">
					<th class="p-4 text-left">ID</th>
					<th class="text-left">Nombre</th>
					<th class="text-left">Correo</th>
					<th class="text-left">Telefono</th>
					<th />
					<th />
				</tr>
			</thead>
			<tbody>
				{#each filteredDeactivatedClients as client}
					<tr class="border-t border-stone-800 hover:variant-soft-primary">
						<ClientRow
							deleteClient={(clientId) => {
								toggleDeleteConfirmation();
								tempClientId = clientId;
							}}
							id={client.cliente_id}
						/>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
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
{#if deleteConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleDeleteConfirmation}
			confirmHandler={deleteClient}
			title="Eliminar Cliente"
			text="¿Seguro de que desea eliminar al cliente?"
		/>
	</DarkenSreen>
{/if}
