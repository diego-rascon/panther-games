<script lang="ts">
	import { supabase } from '$lib/db';
	import { Toast, toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import AddButton from '../../../components/AddButton.svelte';
	import AddClient from '../../../components/forms/ClientForm.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import Search from '../../../components/inputs/Search.svelte';
	import ClientRow from '../../../components/ClientRow.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';

	export let data;
	let { clients } = data;
	$: ({ clients } = data);

	$: filteredClients = clients;

	let name: string;
	let email: string;
	let phone: string;

	const addClient = async () => {
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
			toggleAddingClient();
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
		message: 'Se agregó a un nuevo cliente con éxito',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Clientes" />
	<Search searchHandler={searchClient} bind:search />
</div>
<div
	class="mt-[60px] flex flex-col min-w-full mb-20 bg-stone-900 px-4 py-2 rounded-xl overflow-x-auto"
>
	<table>
		<thead class="border-b border-stone-800">
			<tr>
				<th class="p-2 text-left">ID</th>
				<th class="p-2 text-left">Nombre</th>
				<th class="p-2 text-left">Correo</th>
				<th class="p-2 text-left">Telefono</th>
				<th class="py-2" />
				<th class="py-2" />
			</tr>
		</thead>
		<tbody>
			{#each filteredClients as client}
				<tr>
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
