<script lang="ts">
	import { supabase } from '$lib/db';
	import { session } from '$lib/stores';
	import { goto } from '$app/navigation';
	import PantherGamesLogo from '../components/titles/PantherGamesLogo.svelte';
	import InputError from '../components/utils/InputError.svelte';
	import Icon from '@iconify/svelte';
	import refreshCircleOutline from '@iconify/icons-solar/refresh-circle-outline';

	session.set(false);

	let user = '';
	let password = '';

	let loading = false;
	let inputError = false;
	let validLogin = false;

	const checkLogin = async () => {
		const { data, error } = await supabase
			.from('usuario')
			.select()
			.eq('usuario_username', user)
			.eq('usuario_password', password)
			.maybeSingle();
		if (data) {
			session.set(true);
			validLogin = true;
			goto('/home');
		} else inputError = true;
		loading = false;
	};
</script>

<div class="flex flex-col min-h-screen justify-center bg-stone-900">
	<div
		class="mx-auto p-8 max-w-sm w-full bg-stone-950 border border-stone-800 rounded-xl shadow-xl transition-all"
	>
		<form class="flex flex-col space-y-4">
			<PantherGamesLogo size={4} />
			<input type="text" bind:value={user} placeholder="Usuario" class="input" />
			<input type="password" bind:value={password} placeholder="Contraseña" class="input" />
			{#if inputError}
				<InputError text="El usuario y contraseña no coinciden." />
			{/if}
			<button
				type="submit"
				class="btn font-bold {validLogin ? 'variant-filled-success' : 'variant-filled-primary'}"
				on:click={() => {
					if (!loading && !validLogin) {
						loading = true;
						inputError = false;
						checkLogin();
					}
				}}
			>
				{#if loading}
					<Icon class="animate-spin" icon={refreshCircleOutline} height={24} hFlip={true} />
				{:else}
					{validLogin ? 'Bienvenido' : 'Iniciar sesión'}
				{/if}
			</button>
		</form>
	</div>
</div>
