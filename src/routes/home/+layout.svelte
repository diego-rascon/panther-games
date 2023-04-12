<script>
	import LoadingScreen from '../../components/LoadingScreen.svelte';
	import Header from '../../components/navigation/Header.svelte';
	import Navbar from '../../components/navigation/Navbar.svelte';
</script>

<div class="relative min-h-screen md:flex bg-stone-950">
	<Navbar />
	<div class="flex-1 p-4 ml-64">
		<Header />
		<slot />
	</div>
</div>
