<script>
	import Navbar from '../../components/navigation/Navbar.svelte';
	import Header from '../../components/navigation/Header.svelte';

	const routes = [
		'/',
		
	]
</script>

<div class="relative min-h-screen md:flex bg-stone-950">
	<Header />
	<Navbar />
	<div class="flex-1 p-4">
		<slot />
	</div>
</div>
