<script lang="ts">
	import { supabase } from '$lib/db';
	import { onMount } from 'svelte';
	import SignInInput from '../components/inputs/SignInInput.svelte';
	import PantherGamesLogo from '../components/PantherGamesLogo.svelte';
	import LoadingScreen from '../components/utils/LoadingScreen.svelte';
	import ErrorScreen from '../components/utils/ErrorScreen.svelte';

	let loading = true;
	let errorFetching = false;
	let errorMessage = '';

	let users: any = [];

	onMount(() => {
		fetchUsers();
	});

	const fetchUsers = async () => {
		let { data, error } = await supabase
			.from('usuario')
			.select('*')
			.order('usuario_id', { ascending: true });
		if (error) {
			errorFetching = true;
			errorMessage = error.message;
		} else {
			users = data;
		}
		loading = false;
	};
</script>

<div class="flex flex-col min-h-screen justify-center bg-stone-900">
	<div class="mx-auto p-8 bg-stone-950 border border-stone-800 rounded-xl shadow-xl transition-all">
		{#if loading}
			<LoadingScreen text="usuarios" />
		{:else if errorFetching}
			<ErrorScreen text={errorMessage} />
		{:else}
			<form action="/home" class="flex flex-col w-64 space-y-4">
				<PantherGamesLogo size={4} />
				<SignInInput type="text" placeholder="Usuario" />
				<SignInInput type="password" placeholder="Contraseña" />
				<button type="submit" class="px-4 py-2 rounded-xl font-bold btn-fill">Iniciar sesión</button
				>
			</form>
		{/if}
	</div>
</div>
