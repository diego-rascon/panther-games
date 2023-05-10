<script lang="ts">
	import PantherGamesLogo from '../components/titles/PantherGamesLogo.svelte';
	import { supabase } from '$lib/db';
	import InputError from '../components/utils/InputError.svelte';
	import LoadingScreen from '../components/utils/LoadingScreen.svelte';

	let usuario = '';
	let contraseña = '';
	let errorString = '';

	let errorVisible = false;
	let loginSuccess = false;

	let loading = false;

	const checkLogin = async () => {
		// Verificar si el usuario y la contraseña no están vacíos
		if (usuario && contraseña) {
			// Realizar una consulta a la tabla "usuario" en Supabase para verificar la coincidencia
			const { data, error } = await supabase
				.from('usuario')
				.select()
				.eq('usuario_username', usuario)
				.eq('usuario_password', contraseña)
				.limit(1);

			if (error) {
				console.error('Error al verificar usuario y contraseña:', error);
				return;
			}

			if (data && data.length > 0) {
				// Desactivar variables
				errorVisible = false;
				// Volver boton verde
				loginSuccess = true;
				// Los datos coinciden, el usuario y contraseña son válidos
				console.log('Usuario y contraseña coinciden.');
				// Redireccionar a la página de inicio
				window.location.href = '/home';
			} else {
				loading = false;
				errorVisible = true;
				errorString = 'Usuario o contraseña no coinciden.';
			}
		} else {
			loading = false;
			errorVisible = true;
			errorString = 'Favor de introducir usuario y contraseña.';
		}
	};

	const submit = () => {
		loading = true;
		checkLogin();
	};

	const submitOnEnter = (event: KeyboardEvent) => {
		if (event.key === 'Enter') {
			submit();
		}
	};
</script>

<div class="flex flex-col min-h-screen justify-center bg-stone-900">
	<div
		class="mx-auto p-8 max-w-sm w-full bg-stone-950 border border-stone-800 rounded-xl shadow-xl transition-all"
	>
		<div class="flex flex-col space-y-4">
			<PantherGamesLogo size={4} />
			<input
				type="text"
				bind:value={usuario}
				placeholder="Usuario"
				class="input"
				on:keypress={submitOnEnter}
			/>
			<input
				type="password"
				bind:value={contraseña}
				placeholder="Contraseña"
				class="input"
				on:keypress={submitOnEnter}
			/>
			{#if errorVisible}
				<InputError text={errorString} />
			{/if}
			<a
				href='/home'
				type="button"
				class="btn font-bold {loginSuccess ? 'variant-filled-success' : 'variant-filled-primary'}"
			>
				{#if loginSuccess}
					<span>Bienvenido</span>
				{:else if loading}
					<LoadingScreen />
				{:else}
					<span>Iniciar sesión</span>
				{/if}
			</a>
			<!--
			<button
				type="button"
				class="btn font-bold {loginSuccess ? 'variant-filled-success' : 'variant-filled-primary'}"
				on:click={submit}
			>
				{#if loginSuccess}
					<span>Bienvenido</span>
				{:else if loading}
					<LoadingScreen />
				{:else}
					<span>Iniciar sesión</span>
				{/if}
			</button>
			-->
		</div>
	</div>
</div>
