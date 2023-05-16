<script lang="ts">
	import { supabase } from '$lib/db';
	import { toastStore } from '@skeletonlabs/skeleton';
	import type { ToastSettings } from '@skeletonlabs/skeleton';
	import AddButton from '../../../components/utils/AddButton.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import SectionSubtitle from '../../../components/titles/SectionSubtitle.svelte';
	import Search from '../../../components/utils/Search.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import { membersStore } from '$lib/stores';
	import { nfd, nfc } from 'unorm';
	import NoResultsMessage from '../../../components/utils/NoResultsMessage.svelte';
	import dayjs from 'dayjs';
	import MemberForm from '../../../components/forms/MemberForm.svelte';
	import RenewMemberForm from '../../../components/forms/RenewMemberForm.svelte';
	import MemberRow from '../../../components/data/MemberRow.svelte';
	import MemberDetail from '../../../components/data/MemberDetail.svelte';

	export let data;
	let { members, clients } = data;
	$: ({ members, clients } = data);

	$: membersStore.set(members);
	$: activeMembers = members.filter(
		(member: any) => member.miembro_activo && new Date(member.miembro_fecha_final) >= new Date()
	);
	$: expiredMembers = members.filter(
		(member: any) => member.miembro_activo && new Date(member.miembro_fecha_final) < new Date()
	);
	$: deactivatedMembers = members.filter((member: any) => !member.miembro_activo);
	$: filteredActiveMembers = activeMembers;
	$: filteredExpiredMembers = expiredMembers;
	$: filteredDeactivatedMembers = deactivatedMembers;

	let newClient = true;
	let clientId: number | undefined;
	let name: string;
	let email: string;
	let phone: string;
	let date: string;
	$: endDate = dayjs(date).add(1, 'year').format('YYYY-MM-DD');

	const today = new Date();
	const year = today.getFullYear();
	const month = String(today.getMonth() + 1).padStart(2, '0');
	const day = String(today.getDate()).padStart(2, '0');

	let startDate = `${year}-${month}-${day}`;

	const clearForm = () => {
		clientId = undefined;
		name = '';
		email = '';
		phone = '';
	};

	let showingDetail = false;

	const toggleShowDetail = () => {
		showingDetail = !showingDetail;
	};

	let addingMember = false;

	const toggleAddingMember = () => {
		addingMember = !addingMember;
	};

	const addMember = async () => {
		toggleAddingMember();
		if (newClient) {
			const { data: client, error: clientError } = await supabase
				.from('cliente')
				.insert({ cliente_nombre: name, cliente_email: email, cliente_telefono: phone })
				.select()
				.single();
			if (clientError) console.log(clientError.message);
			if (client) {
				const { data: member, error: errorMessage } = await supabase
					.from('miembro')
					.insert({
						cliente_id: client.cliente_id,
						miembro_fecha_original: date,
						miembro_fecha_inicio: date,
						miembro_fecha_final: endDate
					})
					.select()
					.single();
				if (errorMessage) console.log(errorMessage.message);
				if (member) {
					const newMember = client;
					newMember.miembro_id = member.miembro_id;
					newMember.miembro_activo = true;
					newMember.miembro_fecha_inicio = date;
					newMember.miembro_fecha_final = endDate;
					newMember.miembro_compras = 0;
					newMember.miembro_rentas = 0;
					members = [newMember, ...members];
				}
			}
		} else {
			const { error } = await supabase
				.from('miembro')
				.insert({
					cliente_id: clientId,
					miembro_fecha_original: date,
					miembro_fecha_inicio: date,
					miembro_fecha_final: endDate
				})
				.select()
				.single();
			if (error) console.log(error.message);
			const newMember = clients.find((clientEntry: any) => clientEntry.cliente_id === clientId);
			newMember.miembro_id = clientId;
			newMember.miembro_activo = true;
			newMember.miembro_fecha_inicio = date;
			newMember.miembro_fecha_final = endDate;
			newMember.miembro_compras = 0;
			newMember.miembro_rentas = 0;
			members = [newMember, ...members];
			clients = clients.filter((clientEntry: any) => clientEntry.cliente_id !== clientId);
		}
		clearForm();
		toastStore.trigger(memberAdded);
	};

	let tempMemberId: number;
	let tempClientId: number;
	let editingMember = false;

	const toggleEditingMember = () => {
		editingMember = !editingMember;
	};

	const bindValues = () => {
		const editedMember = members.find((member: any) => member.cliente_id === tempClientId);
		if (editedMember) {
			name = editedMember.cliente_nombre;
			email = editedMember.cliente_email;
			phone = editedMember.cliente_telefono;
		}
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
			.eq('cliente_id', tempClientId);
		if (error) console.log(error.message);
		const editedClient = members.findIndex((member: any) => member.cliente_id === tempClientId);
		members[editedClient].cliente_nombre = name;
		members[editedClient].cliente_email = email;
		members[editedClient].cliente_telefono = phone;
		toastStore.trigger(memberEdited);
	};

	let renewingMember = false;

	const toggleRenewingMember = () => {
		renewingMember = !renewingMember;
	};

	const renewMember = async () => {
		toggleRenewingMember();
		const { data, error } = await supabase
			.from('miembro')
			.update({ miembro_fecha_inicio: date, miembro_fecha_final: endDate })
			.eq('miembro_id', tempMemberId)
			.select();
		if (error) console.log(error.message);
		if (data) {
			const renewedMember = members.findIndex((member: any) => member.miembro_id === tempMemberId);
			members[renewedMember].miembro_fecha_inicio = date;
			members[renewedMember].miembro_fecha_final = endDate;
			toastStore.trigger(memberRenewed);
		}
	};

	let deleteConfirmation = false;

	const toggleDeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteMember = async () => {
		toggleDeleteConfirmation();
		const { data: activeRents, error } = await supabase
			.from('renta')
			.select()
			.eq('miembro_id', tempMemberId)
			.or('renta_completada.eq.false,renta_activa.eq.false');
		//.eq('renta_completada', false)
		if (error) console.log(error.message);
		if (activeRents && activeRents.length === 0) {
			const { error: memberError } = await supabase
				.from('miembro')
				.update({ miembro_activo: false })
				.eq('miembro_id', tempMemberId);
			if (memberError) console.log(memberError.message);
			const removedMember = members.findIndex((member: any) => member.miembro_id === tempMemberId);
			members[removedMember].miembro_activo = false;
			toastStore.trigger(memberDeleted);
		} else {
			toastStore.trigger(memberWithRents);
		}
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateMember = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('miembro')
			.update({ miembro_activo: true })
			.eq('miembro_id', tempMemberId);
		if (error) console.log(error.message);
		const removedMember = members.findIndex((member: any) => member.miembro_id === tempMemberId);
		members[removedMember].miembro_activo = true;
		toastStore.trigger(memberActivated);
	};

	let search: string;

	const searchMember = (search: string) => {
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

		filteredExpiredMembers = expiredMembers.filter((member: any) => {
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
		message: 'Un nuevo miembro fue registrado exitosamente.',
		background: 'variant-filled-primary'
	};

	const memberEdited: ToastSettings = {
		message: 'Se actualizaron los datos del miembro exitosamente.',
		background: 'variant-filled-primary'
	};

	const memberRenewed: ToastSettings = {
		message: 'Se renovó al miembro exitosamente.',
		background: 'variant-filled-primary'
	};

	const memberDeleted: ToastSettings = {
		message: 'Se eliminó al miembro exitosamente.',
		background: 'variant-filled-primary'
	};

	const memberActivated: ToastSettings = {
		message: 'Se activó al miembro exitosamente.',
		background: 'variant-filled-primary'
	};

	const memberWithRents: ToastSettings = {
		message: 'No se pueden eliminar miembros con rentas activas.',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="z-[100] fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Miembros" />
	<Search searchHandler={searchMember} bind:search />
</div>
<div class="mt-[60px] flex flex-col mb-20 space-y-4">
	{#if filteredActiveMembers.length === 0 && filteredExpiredMembers === 0 && filteredDeactivatedMembers.length === 0}
		<NoResultsMessage search={search !== ''} />
	{:else}
		{#if filteredActiveMembers.length > 0}
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table>
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
							<th class="text-left">Fecha inicial</th>
							<th class="text-left">Fecha final</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredActiveMembers as activeMember (activeMember.miembro_id)}
							<MemberRow
								toggleDetail={(memberId) => {
									tempMemberId = memberId;
									toggleShowDetail();
								}}
								editMember={(clientId) => {
									tempClientId = clientId;
									toggleEditingMember();
									bindValues();
								}}
								toggleMember={(memberId) => {
									tempMemberId = memberId;
									toggleDeleteConfirmation();
								}}
								memberId={activeMember.miembro_id}
								clientId={activeMember.cliente_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class="h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredExpiredMembers.length > 0}
			<SectionSubtitle text="Miembros Vencidos" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table class="text-stone-400">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
							<th class="text-left">Fecha inicial</th>
							<th class="text-left">Fecha final</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredExpiredMembers as expiredMember (expiredMember.miembro_id)}
							<MemberRow
								toggleDetail={(memberId) => {
									tempMemberId = memberId;
									toggleShowDetail();
								}}
								editMember={(clientId) => {
									tempClientId = clientId;
									toggleEditingMember();
									bindValues();
								}}
								renewMember={(memberId) => {
									tempMemberId = memberId;
									toggleRenewingMember();
								}}
								toggleMember={(memberID) => {
									tempMemberId = memberID;
									toggleDeleteConfirmation();
								}}
								memberId={expiredMember.miembro_id}
								clientId={expiredMember.cliente_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class="h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredDeactivatedMembers.length > 0}
			<SectionSubtitle text="Miembros no Activos" />
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table class="text-stone-400">
					<thead>
						<tr class="text-lg">
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
							<th class="text-left">Fecha inicial</th>
							<th class="text-left">Fecha final</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredDeactivatedMembers as deactivadedMember (deactivadedMember.miembro_id)}
							<MemberRow
								toggleDetail={(memberId) => {
									tempMemberId = memberId;
									toggleShowDetail();
								}}
								editMember={(clientId) => {
									tempClientId = clientId;
									toggleEditingMember();
									bindValues();
								}}
								toggleMember={(memberId) => {
									tempMemberId = memberId;
									toggleActivateConfirmation();
								}}
								memberId={deactivadedMember.miembro_id}
								clientId={deactivadedMember.cliente_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class="h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
	{/if}
</div>
<div class="fixed bottom-0 right-0">
	<AddButton on:click={toggleAddingMember} />
</div>
{#if showingDetail}
	<DarkenSreen>
		<MemberDetail closeHandler={toggleShowDetail} memberId={tempMemberId} />
	</DarkenSreen>
{/if}
{#if addingMember}
	<DarkenSreen>
		<MemberForm
			cancelHandler={() => {
				toggleAddingMember();
				clearForm();
			}}
			confirmHandler={addMember}
			{clients}
			bind:newClient
			bind:clientId
			bind:name
			bind:email
			bind:phone
			bind:date
			{startDate}
		/>
	</DarkenSreen>
{/if}
{#if editingMember}
	<DarkenSreen>
		<MemberForm
			editing={true}
			cancelHandler={() => {
				toggleEditingMember();
				clearForm();
			}}
			confirmHandler={editMember}
			{clients}
			bind:newClient
			bind:clientId
			bind:name
			bind:email
			bind:phone
			bind:date
			{startDate}
		/>
	</DarkenSreen>
{/if}
{#if renewingMember}
	<DarkenSreen>
		<RenewMemberForm
			cancelHandler={() => {
				toggleRenewingMember();
				clearForm();
			}}
			confirmHandler={renewMember}
			memberId={tempMemberId}
			bind:date
			{startDate}
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
