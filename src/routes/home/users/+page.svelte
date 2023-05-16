<script lang="ts">
	import { supabase } from '$lib/db';
	import { clientsStore, usersStore } from '$lib/stores';
	import { toastStore, type ToastSettings } from '@skeletonlabs/skeleton';
	import UserRow from '../../../components/data/UserRow.svelte';
	import UserForm from '../../../components/forms/UserForm.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import AddButton from '../../../components/utils/AddButton.svelte';
	import Search from '../../../components/utils/Search.svelte';
	import ConfirmDialog from '../../../components/modals/ConfirmDialog.svelte';
	import NoResultsMessage from '../../../components/utils/NoResultsMessage.svelte';

	export let data;
	let { users } = data;
	$: ({ users } = data);

	$: usersStore.set(users);
	$: activeUsers = users.filter((user: any) => user.usuario_activo);
	$: unactiveUsers = users.filter((user: any) => !user.usuario_activo);
	$: filteredActiveUsers = activeUsers;
	$: filteredUnactiveUsers = unactiveUsers;

	let name: string;
	let email: string;
	let phone: string;
	let userName: string;
	let password: string;
	let reader: boolean;
	let admin = true;

	const clearForm = () => {
		name = '';
		email = '';
		phone = '';
		userName = '';
		password = '';
	};

	let addingUser = false;

	const toggleAddingUser = () => {
		addingUser = !addingUser;
	};

	const addUser = async () => {
		toggleAddingUser();
		const { data: user, error } = await supabase
			.from('usuario')
			.insert({
				sucursal_id: 1,
				usuario_nombre: name,
				usuario_email: email,
				usuario_telefono: phone,
				usuario_username: userName,
				usuario_password: password,
				usuario_leer: reader,
				usuario_admin: admin
			})
			.select()
			.single();
		if (error) console.log(error.message);
		if (user) {
			users = [user, ...users];
			toastStore.trigger(userAdded);
			clearForm();
		}
	};

	let tempUserId: number;
	let editingUser = false;

	const toggleEditingUser = () => {
		editingUser = !editingUser;
	};

	const bindValues = () => {
		const editedUser = users.find((user: any) => user.usuario_id === tempUserId);
		if (editedUser) {
			name = editedUser.usuario_nombre;
			email = editedUser.usuario_email;
			phone = editedUser.usuario_telefono;
		}
	};

	const editUser = async () => {
		toggleEditingUser();
		const { error } = await supabase
			.from('usuario')
			.update({
				usuario_nombre: name,
				usuario_email: email,
				usuario_telefono: phone
			})
			.eq('usuario_id', tempUserId);
		if (error) console.log(error.message);
		const editedUser = users.findIndex((user: any) => user.usuario_id === tempUserId);
		users[editedUser].usuario_nombre = name;
		users[editedUser].usuario_email = email;
		users[editedUser].usuario_telefono = phone;
		toastStore.trigger(userEdited);
		clearForm();
	};

	let deleteConfirmation = false;

	const toggledeleteConfirmation = () => {
		deleteConfirmation = !deleteConfirmation;
	};

	const deleteUser = async () => {
		toggledeleteConfirmation();
		const { error } = await supabase
			.from('usuario')
			.update({ usuario_activo: false })
			.eq('usuario_id', tempUserId);
		if (error) console.log(error.message);
		const removedUser = users.findIndex((user: any) => user.usuario_id === tempUserId);
		users[removedUser].usuario_activo = false;
		toastStore.trigger(userDeleted);
	};

	let activateConfirmation = false;

	const toggleActivateConfirmation = () => {
		activateConfirmation = !activateConfirmation;
	};

	const activateUser = async () => {
		toggleActivateConfirmation();
		const { error } = await supabase
			.from('usuario')
			.update({ usuario_activo: true })
			.eq('usuario_id', tempUserId);
		if (error) console.log(error.message);
		const activatedUser = users.findIndex((user: any) => user.usuario_id === tempUserId);
		users[activatedUser].usuario_activo = true;
		toastStore.trigger(userActivated);
	};

	let search: string;

	const searchUser = () => {};

	const userAdded: ToastSettings = {
		message: 'Se agregó a un nuevo usuario exitosamente.',
		background: 'variant-filled-primary'
	};

	const userEdited: ToastSettings = {
		message: 'Se editó al usuario exitosamente.',
		background: 'variant-filled-primary'
	};

	const userDeleted: ToastSettings = {
		message: 'Se eliminó al usuario exitosamente.',
		background: 'variant-filled-primary'
	};

	const userActivated: ToastSettings = {
		message: 'Se activó al usuario exitosamente.',
		background: 'variant-filled-primary'
	};
</script>

<div
	class="z-[100] fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Usuarios" />
	<Search searchHandler={searchUser} bind:search />
</div>
<div class="mt-[60px] flex flex-col mb-20 space-y-4">
	{#if filteredActiveUsers.length === 0 && filteredUnactiveUsers.length === 0}
		<NoResultsMessage search={search != ''} />
	{:else}
		{#if filteredActiveUsers.length > 0}
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table>
					<thead>
						<tr>
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Usuario</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
							<th class="text-left">Permisos</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredActiveUsers as activeUser (activeUser.usuario_id)}
							<UserRow
								editUser={(userId) => {
									toggleEditingUser();
									tempUserId = userId;
									bindValues();
								}}
								toggleUser={(userId) => {
									toggledeleteConfirmation();
									tempUserId = userId;
								}}
								userId={activeUser.usuario_id}
							/>
						{/each}
						<tr class="border-t border-stone-800">
							<td class=" h-7" />
						</tr>
					</tbody>
				</table>
			</div>
		{/if}
		{#if filteredUnactiveUsers.length > 0}
			<div class="flex flex-col rounded-xl bg-stone-900">
				<table class="text-stone-400">
					<thead>
						<tr>
							<th class="p-4 text-left">ID</th>
							<th class="text-left">Nombre</th>
							<th class="text-left">Usuario</th>
							<th class="text-left">Correo</th>
							<th class="text-left">Telefono</th>
							<th class="text-left">Permisos</th>
						</tr>
					</thead>
					<tbody>
						{#each filteredUnactiveUsers as unactiveUser (unactiveUser.usuario_id)}
							<UserRow
								editUser={(userId) => {
									toggleEditingUser();
									tempUserId = userId;
									bindValues();
								}}
								toggleUser={(userId) => {
									toggleActivateConfirmation();
									tempUserId = userId;
								}}
								userId={unactiveUser.usuario_id}
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
<div class="fixed bottom-0 right-0">
	<AddButton on:click={toggleAddingUser} />
</div>
{#if addingUser}
	<DarkenSreen>
		<UserForm
			editing={false}
			cancelHandler={() => {
				toggleAddingUser();
				clearForm();
			}}
			confirmHandler={addUser}
			bind:name
			bind:email
			bind:phone
			bind:userName
			bind:password
			bind:reader
			bind:admin
		/>
	</DarkenSreen>
{/if}
{#if editingUser}
	<DarkenSreen>
		<UserForm
			editing={true}
			cancelHandler={() => {
				toggleEditingUser();
				clearForm();
			}}
			confirmHandler={editUser}
			bind:name
			bind:email
			bind:phone
			bind:userName
			bind:password
			bind:reader
			bind:admin
		/>
	</DarkenSreen>
{/if}
{#if deleteConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggledeleteConfirmation}
			confirmHandler={deleteUser}
			title="Eliminar Usuario"
			text="¿Seguro de que desea eliminar al usuario?"
		/>
	</DarkenSreen>
{/if}
{#if activateConfirmation}
	<DarkenSreen>
		<ConfirmDialog
			cancelHandler={toggleActivateConfirmation}
			confirmHandler={activateUser}
			title="Activar Usuario"
			text="¿Seguro de que desea activar al usuario?"
		/>
	</DarkenSreen>
{/if}
