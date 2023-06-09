<script lang="ts">
	import { supabase } from '$lib/db';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import AddButton from '../../../components/utils/AddButton.svelte';
	import ClientForm from '../../../components/forms/ClientForm.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import Search from '../../../components/utils/Search.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import { clientsStore, readUser } from '$lib/stores';
	import { nfd, nfc } from 'unorm';
	import NoResultsMessage from '../../../components/utils/NoResultsMessage.svelte';
	import ClientRow from '../../../components/data/ClientRow.svelte';

	export let data;
	let { clients } = data;
	$: ({ clients } = data);

	$: clientsStore.set(clients);
	$: activeClients = clients.filter((client: any) => client.cliente_activo);
	$: deactivatedClients = clients.filter((client: any) => !client.cliente_activo);
	$: filteredActiveClients = activeClients;
	$: filteredDeactivatedClients = deactivatedClients;

	let name: string;
	let email: string;
	let phone: string;

	const clearForm = () => {
		name = '';
		email = '';
		phone = '';
	};

	let addingClient = false;

	const toggleAddingClient = () => {
		addingClient = !addingClient;
	};

	const addClient = async () => {
		toggleAddingClient();
		const { data: client } = await supabase
			.from('cliente')
			.insert({
				cliente_nombre: name,
				cliente_email: email,
				cliente_telefono: phone
			})
			.select()
			.single();
		if (client) {
			clients = [client, ...clients];
			toastStore.trigger(clientAdded);
		}
		clearForm();
	};

	let tempClientId: number;
	let editingClient = false;

	const toggleEditingClient = () => {
		editingClient = !editingClient;
	};

	const bindValues = () => {
		const editedClient = clients.find((client: any) => client.cliente_id === tempClientId);
		if (editedClient) {
			name = editedClient.cliente_nombre;
			email = editedClient.cliente_email;
			phone = editedClient.cliente_telefono;
		}
	};

	const editClient = async () => {
		toggleEditingClient();
		const { error } = await supabase
			.from('cliente')
			.update({
				cliente_nombre: name,
				cliente_email: email,
				cliente_telefono: phone
			})
			.eq('cliente_id', tempClientId);
		if (error) console.log(error.message);
		const editedClient = clients.findIndex((client: any) => client.cliente_id === tempClientId);
		clients[editedClient].cliente_nombre = name;
		clients[editedClient].cliente_email = email;
		clients[editedClient].cliente_telefono = phone;
		toastStore.trigger(clientEdited);
		clearForm();
	};

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteClient = async () => {
		toggleDeleteConfirmation();
		const { error } = await supabase
			.from('cliente')
			.update({ cliente_activo: false })
			.eq('cliente_id', tempClientId);
		if (error) console.log(error.message);
		const removedClient = clients.findIndex((client: any) => client.cliente_id === tempClientId);
		clients[removedClient].cliente_activo = false;
		toastStore.trigger(clientDeleted);
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateClient = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('cliente')
			.update({ cliente_activo: true })
			.eq('cliente_id', tempClientId);
		if (error) console.log(error.message);
		const removedClient = clients.findIndex((client: any) => client.cliente_id === tempClientId);
		clients[removedClient].cliente_activo = true;
		toastStore.trigger(clientActivated);
	};

	let search: string;

	const searchClient = (search: string) => {
		const searchWords = search.split(' ');

		filteredActiveClients = activeClients.filter((client: any) =>
			searchWords.every(
				(word: string) =>
					client.cliente_id.toString().includes(word) ||
					nfd(client.cliente_nombre.toLowerCase()).includes(word) ||
					nfc(client.cliente_nombre.toLowerCase()).includes(word) ||
					client.cliente_email.toLowerCase().includes(word) ||
					client.cliente_telefono.toLowerCase().includes(word)
			)
		);

		filteredDeactivatedClients = deactivatedClients.filter((client: any) =>
			searchWords.every(
				(word: string) =>
					client.cliente_id.toString().includes(word) ||
					nfd(client.cliente_nombre.toLowerCase()).includes(word) ||
					nfc(client.cliente_nombre.toLowerCase()).includes(word) ||
					client.cliente_email.toLowerCase().includes(word) ||
					client.cliente_telefono.toLowerCase().includes(word)
			)
		);
	};

	const clientAdded: ToastSettings = {
		message: 'Un nuevo cliente fue registrado exitosamente',
		background: 'variant-filled-primary'
	};

	const clientEdited: ToastSettings = {
		message: 'Se actualizaron los datos del cliente exitosamente',
		background: 'variant-filled-primary'
	};

	const clientDeleted: ToastSettings = {
		message: 'Se eliminó al cliente exitosamente',
		background: 'variant-filled-primary'
	};

	const clientActivated: ToastSettings = {
		message: 'Se activó al cliente exitosamente',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="z-[100] fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Clientes" />
	<Search searchHandler={searchClient} bind:search />
</div>
<div class="mt-[60px] flex flex-col mb-20 space-y-4">
	{#if filteredActiveClients.length === 0 && filteredDeactivatedClients.length === 0}
		<NoResultsMessage search={search !== ''} />
	{:else}
		{#if filteredActiveClients.length !== 0}
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table>
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredActiveClients as client (client.cliente_id)}
							<ClientRow
								editClient={(clientId) => {
									toggleEditingClient();
									tempClientId = clientId;
									bindValues();
								}}
								deleteClient={(clientId) => {
									toggleDeleteConfirmation();
									tempClientId = clientId;
								}}
								id={client.cliente_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class=" h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredDeactivatedClients.length !== 0}
			<SectionSubtitle text="Clientes no Activos" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table class="text-stone-400">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredDeactivatedClients as client (client.cliente_id)}
							<ClientRow
								editClient={(clientId) => {
									toggleEditingClient();
									tempClientId = clientId;
									bindValues();
								}}
								activateClient={(clientId) => {
									toggleActivateConfirmation();
									tempClientId = clientId;
								}}
								id={client.cliente_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class=" h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
	{/if}
</div>
{#if !$readUser}
	<div class="fixed bottom-0 right-0">
		<AddButton on:click={toggleAddingClient} />
	</div>
{/if}
{#if addingClient}
	<DarkenSreen>
		<ClientForm
			cancelHandler={() => {
				toggleAddingClient();
				clearForm();
			}}
			confirmHandler={addClient}
			bind:name
			bind:email
			bind:phone
		/>
	</DarkenSreen>
{/if}
{#if editingClient}
	<DarkenSreen>
		<ClientForm
			editing={true}
			cancelHandler={() => {
				toggleEditingClient();
				clearForm();
			}}
			confirmHandler={editClient}
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
{#if activateConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleActivateConfirmation}
			confirmHandler={activateClient}
			title="Activar Cliente"
			text="¿Seguro de que desea activar al cliente?"
		/>
	</DarkenSreen>
{/if}
