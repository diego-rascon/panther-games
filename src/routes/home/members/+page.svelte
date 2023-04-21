<script lang="ts">
	import { supabase } from '$lib/db';
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import AddButton from '../../../components/AddButton.svelte';
	import AddClient from '../../../components/add-menus/AddClient.svelte';
	import ConfirmDialog from '../../../components/modals/confirmDialog.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';

	export let data;
	let { members } = data;
	$: ({ members } = data);

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
		members = [client ?? [], ...members];
		closeConfirmation();
		closeAddMenu();
	};

	let addMenuVisible = false;

	const openAddMenu = () => {
		addMenuVisible = true;
	};

	const closeAddMenu = () => {
		addMenuVisible = false;
	};

	let confirmationVisible = false;

	const openConfirmation = () => {
		confirmationVisible = true;
	};

	const closeConfirmation = () => {
		confirmationVisible = false;
	};

	let cancelConfirmationVisible = false;

	const openCancelConfirmation = () => {
		cancelConfirmationVisible = true;
	};

	const closeCancelConfirmation = () => {
		cancelConfirmationVisible = false;
	};

	const cancelAddClient = () => {
		closeCancelConfirmation();
		closeAddMenu();
	};
</script>

<SectionTitle text="Miembros" />
<div class="flex flex-col min-w-full bg-stone-900 mt-4 px-4 py-2 rounded-xl overflow-x-auto">
	<table>
		<thead class="border-b border-stone-700">
			<tr>
				<th class="p-2 text-left">ID</th>
				<th class="p-2 text-left">Nombre</th>
				<th class="p-2 text-left">Correo</th>
				<th class="p-2 text-left">Telefono</th>
				<th class="py-2" />
			</tr>
		</thead>
		<tbody>
			{#each members as member}
				<tr>
					<td class="p-2 text-left">{member.cliente_id}</td>
					<td class="p-2 text-left">{member.cliente_nombre}</td>
					<td class="p-2 text-left">{member.cliente_email}</td>
					<td class="p-2 text-left">{member.cliente_telefono}</td>
					<td class="py-2 text-right">
						<button class="rounded-full p-2 hover:bg-stone-800 active:bg-stone-950 transition-all">
							<Icon icon={menuDotsBold} rotate={1} height={24} />
						</button>
					</td>
				</tr>
			{/each}
		</tbody>
	</table>
</div>
<div class="fixed bottom-0 right-0">
	<AddButton clickHandler={openAddMenu} />
</div>
{#if addMenuVisible}
	<AddClient
		cancelHandler={openCancelConfirmation}
		confirmHandler={openConfirmation}
		bind:name
		bind:email
		bind:phone
	/>
{/if}
{#if confirmationVisible}
	<ConfirmDialog
		cancelHandler={closeConfirmation}
		confirmHandler={addClient}
		title="Confirmar Registro"
		text="¿Está seguro de que desea registrar el nuevo cliente?"
	/>
{/if}
{#if cancelConfirmationVisible}
	<ConfirmDialog
		cancelHandler={closeCancelConfirmation}
		confirmHandler={cancelAddClient}
		title="Cancelar Registro"
		text="¿Está seguro de que desea cancelar el registro del nuevo cliente?"
	/>
{/if}
