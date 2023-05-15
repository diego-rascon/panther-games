<script>
	import { fade } from 'svelte/transition';
</script>

<div
	on:keyup
	on:click
	class="z-[999] fixed inset-0 flex justify-center items-center bg-black transition-all bg-opacity-75"
	transition:fade={{ duration: 150 }}
>
	<slot />
</div>
