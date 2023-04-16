<script lang="ts">
	import SignInInput from '../components/inputs/SignInInput.svelte';
	import PantherGamesLogo from '../components/PantherGamesLogo.svelte';
</script>

<div class="flex flex-col min-h-screen justify-center bg-stone-900">
	<div class="mx-auto p-8 bg-stone-950 border border-stone-800 rounded-xl shadow-xl transition-all">
		<form action="/home" class="flex flex-col w-64 space-y-4">
			<PantherGamesLogo size={4} />
			<SignInInput type="text" placeholder="Usuario" />
			<SignInInput type="password" placeholder="Contraseña" />
			<button type="submit" class="px-4 py-2 rounded-xl font-bold btn-fill">Iniciar sesión</button>
		</form>
	</div>
</div>
