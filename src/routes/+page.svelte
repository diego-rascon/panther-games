<script>
	import PantherGamesLogo from '../components/PantherGamesLogo.svelte';
	import SignInInput from '../components/inputs/SignInInput.svelte';
</script>

<div class="relative flex flex-col min-h-screen justify-center bg-stone-900">
	<div class="mx-auto p-8 bg-stone-950 border border-stone-800 rounded-xl shadow-xl">
		<form class="flex flex-col w-64 space-y-4">
			<PantherGamesLogo size={4} />
			<SignInInput type="text" placeholder="Usuario" />
			<SignInInput type="password" placeholder="Contraseña" />
			<a class="px-4 py-2 rounded-xl text-center font-bold btn-fill" href="/home">Iniciar sesión</a>
		</form>
	</div>
</div>
