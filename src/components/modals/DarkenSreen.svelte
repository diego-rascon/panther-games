<script>
	import { fade } from 'svelte/transition';
</script>

<div
	class="fixed inset-0 flex justify-center items-center bg-black transition-all bg-opacity-75"
	transition:fade={{ duration: 150 }}
>
	<slot />
</div>
