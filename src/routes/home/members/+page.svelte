<script lang="ts">
	import { supabase } from '$lib/db';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import AddButton from '../../../components/AddButton.svelte';
	import ClientForm from '../../../components/forms/ClientForm.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import Search from '../../../components/inputs/Search.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import { membersStore } from '$lib/stores';
	import { nfd, nfc } from 'unorm';
	import NoResultsMessage from '../../../components/utils/NoResultsMessage.svelte';
	import MemberRow from '../../../components/MemberRow.svelte';
	import dayjs from 'dayjs';

	export let data;
	let { members } = data;
	$: ({ members } = data);

	$: membersStore.set(members);
	$: activeMembers = members.filter((member: any) => member.miembro_activo);
	$: deactivatedMembers = members.filter((member: any) => !member.miembro_activo);
	$: filteredActiveMembers = activeMembers;
	$: filteredDeactivatedMembers = deactivatedMembers;

	console.log(members);

	let name: string;
	let email: string;
	let phone: string;

	const clearForm = () => {
		name = '';
		email = '';
		phone = '';
	};

	let addingMember = false;

	const toggleAddingMember = () => {
		addingMember = !addingMember;
	};

	const addMember = async () => {
		toggleAddingMember();
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
			members = [client, ...members];
			toastStore.trigger(memberAdded);
		}
		clearForm();
	};

	let tempMemberId: number;
	let editingMember = false;

	const toggleEditingMember = () => {
		editingMember = !editingMember;
	};

	const bindValues = () => {
		const editedMember = members.find((member: any) => member.miembro_id === tempMemberId);
		name = editedMember?.cliente_nombre;
		email = editedMember?.cliente_email;
		phone = editedMember?.cliente_telefono;
	};

	const editMember = async () => {
		toggleEditingMember();
		const { error } = await supabase
			.from('cliente')
			.update({
				cliente_nombre: name,
				cliente_email: email,
				cliente_telefono: phone
			})
			.eq('cliente_id', tempMemberId);
		if (error) console.log(error.message);
		const editedClient = members.find((member: any) => member.miembro_id === tempMemberId);
		if (editedClient) {
			editedClient.cliente_nombre = name;
			editedClient.cliente_email = email;
			editedClient.cliente_telefono = phone;
		}
		members = members;
		toastStore.trigger(memberEdited);
	};

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteMember = async () => {
		toggleDeleteConfirmation();
		const { error } = await supabase
			.from('cliente')
			.update({ cliente_activo: false })
			.eq('cliente_id', tempMemberId);
		if (error) console.log(error.message);
		const removedClient = members.find((client: any) => client.cliente_id === tempMemberId);
		if (removedClient) removedClient.cliente_activo = false;
		members = members;
		toastStore.trigger(memberDeleted);
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateMember = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('cliente')
			.update({ cliente_activo: true })
			.eq('cliente_id', tempMemberId);
		if (error) console.log(error.message);
		const activatedClient = members.find((client: any) => client.cliente_id === tempMemberId);
		if (activatedClient) activatedClient.cliente_activo = true;
		members = members;
		toastStore.trigger(memberActivated);
	};

	let search: string;

	const searchClient = (search: string) => {
		const searchWords = search.split(' ');

		filteredActiveMembers = activeMembers.filter((member: any) => {
			const startDate = dayjs(String(member.miembro_fecha_inicio));
			const formattedStartDate = startDate.format('DD/MM/YYYY');

			const endDate = dayjs(String(member.miembro_fecha_final));
			const formattedEndDate = endDate.format('DD/MM/YYYY');

			return searchWords.every(
				(word: string) =>
					member.miembro_id.toString().includes(word) ||
					member.cliente_id.toString().includes(word) ||
					nfd(member.cliente_nombre.toLowerCase()).includes(word) ||
					nfc(member.cliente_nombre.toLowerCase()).includes(word) ||
					member.cliente_email.toLowerCase().includes(word) ||
					member.cliente_telefono.toLowerCase().includes(word) ||
					formattedStartDate.includes(word) ||
					formattedEndDate.includes(word)
			);
		});

		filteredDeactivatedMembers = deactivatedMembers.filter((member: any) => {
			const startDate = dayjs(String(member.miembro_fecha_inicio));
			const formattedStartDate = startDate.format('DD/MM/YYYY');

			const endDate = dayjs(String(member.miembro_fecha_final));
			const formattedEndDate = endDate.format('DD/MM/YYYY');

			return searchWords.every(
				(word: string) =>
					member.miembro_id.toString().includes(word) ||
					member.cliente_id.toString().includes(word) ||
					nfd(member.cliente_nombre.toLowerCase()).includes(word) ||
					nfc(member.cliente_nombre.toLowerCase()).includes(word) ||
					member.cliente_email.toLowerCase().includes(word) ||
					member.cliente_telefono.toLowerCase().includes(word) ||
					formattedStartDate.includes(word) ||
					formattedEndDate.includes(word)
			);
		});
	};

	const memberAdded: ToastSettings = {
		message: 'Un nuevo cliente fue registrado exitosamente',
		background: 'variant-filled-primary'
	};

	const memberEdited: ToastSettings = {
		message: 'Se actualizaron los datos del cliente exitosamente',
		background: 'variant-filled-primary'
	};

	const memberDeleted: ToastSettings = {
		message: 'Se eliminó al cliente exitosamente',
		background: 'variant-filled-primary'
	};

	const memberActivated: ToastSettings = {
		message: 'Se activó al cliente exitosamente',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Miembros" />
	<Search searchHandler={searchClient} bind:search />
</div>
<div class="mt-[60px] flex-col mb-20 space-y-4">
	{#if filteredActiveMembers.length === 0 && filteredDeactivatedMembers.length === 0}
		<NoResultsMessage />
	{:else}
		{#if filteredActiveMembers.length !== 0}
			<div class="flex flex-col min-w-full rounded-xl overflow-x-auto">
				<table class="bg-stone-900">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
							<th class="text-left">Fecha inicial</th>
							<th class="text-left">Fecha final</th>
							<th class="" />
						</tr>
					</thead>
					<tbody>
						{#each filteredActiveMembers as activeMember}
							<MemberRow
								editMember={(memberID) => {
									toggleEditingMember();
									tempMemberId = memberID;
									bindValues();
								}}
								deleteMember={(memberID) => {
									toggleDeleteConfirmation();
									tempMemberId = memberID;
								}}
								id={activeMember.miembro_id}
							/>
						{/each}
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredDeactivatedMembers.length !== 0}
			<SectionSubtitle text="Miembros no Activos" />
			<div class="flex flex-col min-w-full rounded-xl overflow-x-auto">
				<table class="bg-stone-900">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
							<th class="text-left">Fecha inicial</th>
							<th class="text-left">Fecha final</th>
							<th class="" />
						</tr>
					</thead>
					<tbody>
						{#each filteredDeactivatedMembers as deactivadedClient}
							<MemberRow
								editMember={(memberId) => {
									toggleEditingMember();
									tempMemberId = memberId;
									bindValues();
								}}
								activateClient={(memberId) => {
									toggleActivateConfirmation();
									tempMemberId = memberId;
								}}
								id={deactivadedClient.miembro_id}
							/>
						{/each}
					</tbody>
				</table>
			</div>
		{/if}
	{/if}
</div>
<div class="fixed bottom-0 right-0">
	<AddButton on:click={toggleAddingMember} />
</div>
{#if addingMember}
	<DarkenSreen>
		<ClientForm
			cancelHandler={() => {
				toggleAddingMember();
				clearForm();
			}}
			confirmHandler={addMember}
			bind:name
			bind:email
			bind:phone
		/>
	</DarkenSreen>
{/if}
{#if editingMember}
	<DarkenSreen>
		<ClientForm
			editing={true}
			cancelHandler={() => {
				toggleEditingMember();
				clearForm();
			}}
			confirmHandler={editMember}
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
			confirmHandler={deleteMember}
			title="Eliminar Miembro"
			text="¿Seguro de que desea eliminar al miembro?"
		/>
	</DarkenSreen>
{/if}
{#if activateConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleActivateConfirmation}
			confirmHandler={activateMember}
			title="Activar Miembro"
			text="¿Seguro de que desea activar al miembro?"
		/>
	</DarkenSreen>
{/if}
