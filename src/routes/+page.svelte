<script lang="ts">
	import SignInInput from '../components/inputs/SignInInput.svelte';
	import PantherGamesLogo from '../components/PantherGamesLogo.svelte';
	import { supabase } from '$lib/db';
	import InputError from '../components/add-menus/InputError.svelte';
	import Icon from '@iconify/svelte';
	import refreshLinear from '@iconify/icons-solar/refresh-linear';
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
			errorString = 'Por favor, ingresa usuario y contraseña';
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
	<div class="mx-auto p-8 bg-stone-950 border border-stone-800 rounded-xl shadow-xl transition-all">
		<form class="flex flex-col w-64 space-y-4">
			<PantherGamesLogo size={4} />
			<input
				type="text"
				bind:value={usuario}
				placeholder="Usuario"
				class="px-4 py-2 rounded-xl bg-stone-900 outline-none focus:outline-pink-700 transition-all"
				on:keypress={submitOnEnter}
			/>
			<input
				type="password"
				bind:value={contraseña}
				placeholder="Contraseña"
				class="px-4 py-2 rounded-xl bg-stone-900 outline-none focus:outline-pink-700 transition-all"
				on:keypress={submitOnEnter}
			/>
			{#if errorVisible}
				<InputError text={errorString} />
			{/if}
			<button
				type="button"
				class="px-4 py-2 rounded-xl font-bold {loginSuccess ? 'bg-green-500' : 'btn-fill'}"
				on:click={submit}
			>
				{#if loginSuccess}
					Bienvenido :)
				{:else if loading}
					<LoadingScreen />
				{:else}
					<p>Iniciar sesión</p>
				{/if}
			</button>
		</form>
	</div>
</div>
