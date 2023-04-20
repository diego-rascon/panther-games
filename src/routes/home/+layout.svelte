<script>
	import Navbar from '../../components/navigation/Navbar.svelte';
</script>

<div class="min-h-screen bg-stone-950">
	<Navbar />
	<div class="flex-1 p-4 ml-64">
		<slot />
	</div>
</div>
