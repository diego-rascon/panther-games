<script>
	import { goto } from '$app/navigation';
	import { session } from '$lib/stores';
	import Navbar from '../../components/navigation/Navbar.svelte';

	if (!$session) goto('/');
</script>

<div class="min-h-screen bg-stone-950">
	{#if $session}
		<Navbar />
		<main class="flex-1 p-4 ml-64 select-none">
			<slot />
		</main>
	{/if}
</div>
