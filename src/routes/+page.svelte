<script>
	import SignInInput from '../components/SignInInput.svelte';
</script>

<div class="relative flex flex-col min-h-screen justify-center overflow-hidden bg-stone-900">
	<div class="relative mx-auto p-8 bg-stone-950 border border-stone-800 rounded-xl shadow-xl">
		<form class="flex flex-col space-y-4">
			<div class="text-center text-4xl font-lexend text-pink-700">
				<h1 class="font-bold">Panther</h1>
				<h1>Games</h1>
			</div>
			<SignInInput type="text" placeholder="Usuario" />
			<SignInInput type="password" placeholder="Contraseña" />
			<a class="px-4 py-2 rounded-xl text-center font-bold btn-fill" href="/home">Iniciar sesión</a>
		</form>
	</div>
</div>
