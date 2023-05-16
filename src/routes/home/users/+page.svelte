<script lang="ts">
	import { supabase } from '$lib/db';
	import { usersStore } from '$lib/stores';
	import UserRow from '../../../components/data/UserRow.svelte';
	import UserForm from '../../../components/forms/UserForm.svelte';
	import DarkenSreen from '../../../components/modals/DarkenSreen.svelte';
	import SectionTitle from '../../../components/titles/SectionTitle.svelte';
	import AddButton from '../../../components/utils/AddButton.svelte';
	import Search from '../../../components/utils/Search.svelte';

	export let data;
	let { users } = data;
	$: ({ users } = data);

	$: usersStore.set(users);

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
		const { data: user } = await supabase.from('usuario').insert({
			usuario_nombre: name,
			usuario_email: email,
			usuario_telefono: phone,
			usuario_username: userName,
			usuario_password: password
		});
	};

	let search: string;

	const searchUser = () => {};
</script>

<div
	class="z-[100] fixed top-0 inset-x-0 p-4 ml-64 flex justify-between space-x-8 bg-gradient-to-b from-stone-950"
>
	<SectionTitle text="Usuarios" />
	<Search searchHandler={searchUser} bind:search />
</div>
<div class="mt-[60px] flex flex-col mb-20 space-y-4">
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
				{#each users as user (user.usuario_id)}
					<UserRow userId={user.usuario_id} />
				{/each}
				<tr class="border-t border-stone-800">
					<td class=" h-7" />
				</tr>
			</tbody>
		</table>
	</div>
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
