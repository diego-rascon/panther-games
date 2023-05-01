<script lang="ts">
	import { supabase } from '$lib/db';
	import Icon from '@iconify/svelte';
	import crownMinimalisticBold from '@iconify/icons-solar/crown-minimalistic-bold';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import AddButton from '../../../components/AddButton.svelte';
	import AddClient from '../../../components/add-menus/AddClient.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import Search from '../../../components/inputs/Search.svelte';
	import ClientRow from '../../../components/ClientRow.svelte';

	export let data;
	let { clients } = data;
	$: ({ clients } = data);

	$: filteredClients = clients;

	let name: string;
	let email: string;
	let phone: string;

	let search: string;

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
		if (client) clients = [client, ...clients];
		toggleAddMenu();
	};

	const searchClient = (search: string) => {
		filteredClients = clients.filter(
			(client) =>
				client.cliente_nombre.toLowerCase().includes(search.toLowerCase()) ||
				client.cliente_email.toLowerCase().includes(search.toLowerCase()) ||
				client.cliente_telefono.toLowerCase().includes(search.toLowerCase())
		);
	};

	let addMenuVisible = false;

	const toggleAddMenu = () => {
		addMenuVisible = !addMenuVisible;
	};
</script>

<div
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Clientes" />
	<Search searchHandler={searchClient} bind:search />
</div>
<div class="mt-14 flex flex-col min-w-full mb-20 bg-stone-900 px-4 py-2 rounded-xl overflow-x-auto">
	<table>
		<thead class="border-b border-stone-700">
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
					<!--
					<td class="p-2 text-left">{client.cliente_id}</td>
					<td class="p-2 text-left">{client.cliente_nombre}</td>
					<td class="p-2 text-left">{client.cliente_email}</td>
					<td class="p-2 text-left">{client.cliente_telefono}</td>
					<td class="p-2 text-center">
						{#if client.cliente_miembro}
							<Icon icon={crownMinimalisticBold} color="#e6d92e" />
						{/if}
					</td>
					<td class="py-2 text-right">
						<button class="rounded-full p-2 hover:bg-stone-800 active:bg-stone-950 transition-all">
							<Icon icon={menuDotsBold} rotate={1} height={24} />
						</button>
					</td>
					-->
				</tr>
			{/each}
		</tbody>
	</table>
</div>
<div class="fixed bottom-0 right-0">
	<AddButton on:click={toggleAddMenu} />
</div>
{#if addMenuVisible}
	<AddClient
		cancelHandler={toggleAddMenu}
		confirmHandler={addClient}
		bind:name
		bind:email
		bind:phone
	/>
{/if}
