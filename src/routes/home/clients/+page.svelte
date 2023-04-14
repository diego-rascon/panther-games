<script lang="ts">
	import { supabase } from '$lib/db';
	import { onMount } from 'svelte';
	import Icon from '@iconify/svelte';
	import crownMinimalisticBold from '@iconify/icons-solar/crown-minimalistic-bold';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import LoadingScreen from '../../../components/utils/LoadingScreen.svelte';
	import ErrorScreen from '../../../components/utils/ErrorScreen.svelte';
	import AddButton from '../../../components/AddButton.svelte';
	import AddClient from '../../../components/AddClient.svelte';

	let loading = true;
	let errorFetching = false;
	let errorMessage = '';

	let clients: any = [];

	let modalVisible = false;

	const toggleModal = () => {
		modalVisible = !modalVisible;
	};

	onMount(() => {
		fetchUsers();
	});

	const fetchUsers = async () => {
		let { data, error } = await supabase
			.from('cliente')
			.select('*')
			.order('cliente_id', { ascending: true });
		if (error) {
			errorFetching = true;
			errorMessage = error.message;
		} else {
			clients = data;
		}
		loading = false;
	};

	const addClient = async () => {};
</script>

{#if loading}
	<LoadingScreen text="clientes" />
{:else if errorFetching}
	<ErrorScreen text={errorMessage} />
{:else}
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
							<button
								class="rounded-full p-2 hover:bg-stone-800 active:bg-stone-950 transition-all"
							>
								<Icon icon={menuDotsBold} rotate={1} height={24} />
							</button>
						</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
	<AddButton clickHandler={toggleModal} />
	{#if modalVisible}
		<AddClient cancelHandler={toggleModal} confirmHandler={addClient} />
	{/if}
{/if}
