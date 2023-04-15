<script lang="ts">
	import { supabase } from '$lib/db';
	import Icon from '@iconify/svelte';
	import crownMinimalisticBold from '@iconify/icons-solar/crown-minimalistic-bold';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import AddButton from '../../../components/AddButton.svelte';
	import AddClient from '../../../components/AddClient.svelte';

	export let data;
	let { clients } = data;
	$: ({ clients } = data);

	let name: string = '';
	let email: string = '';
	let phone: string = '';

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
		clients = [...clients, client ?? []];
		closeModal();
	};

	let modalVisible = false;

	const openModal = () => {
		modalVisible = true;
	};

	const closeModal = () => {
		modalVisible = false;
	};
</script>

<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl">
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
			{#each clients as client}
				<tr>
					<td class="p-2 text-left">{client.cliente_id}</td>
					<td class="p-2 text-left">{client.cliente_nombre}</td>
					<td class="p-2 text-left">{client.cliente_email}</td>
					<td class="p-2 text-left">{client.cliente_telefono}</td>
					<td class="py-2 text-right">
						{#if client.cliente_miembro}
							<Icon icon={crownMinimalisticBold} color="#e6d92e" />
						{/if}
					</td>
					<td class="p-2 text-cemter">
						<button class="rounded-full p-2 hover:bg-stone-800 active:bg-stone-950 transition-all">
							<Icon icon={menuDotsBold} rotate={1} height={24} />
						</button>
					</td>
				</tr>
			{/each}
		</tbody>
	</table>
</div>
<AddButton clickHandler={openModal} />
{#if modalVisible}
	<AddClient
		cancelHandler={closeModal}
		confirmHandler={addClient}
		bind:name
		bind:email
		bind:phone
	/>
{/if}
