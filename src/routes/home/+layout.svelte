<script>
	import Navbar from '../../components/navigation/Navbar.svelte';
</script>

<div class="relative min-h-screen flex">
	<Navbar />
	<div class="flex-1 p-4 bg-stone-950">
		<slot />
	</div>
</div>
