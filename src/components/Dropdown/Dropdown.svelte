<script lang="ts">
	import { scale } from 'svelte/transition';
</script>

<div
	class="absolute z-50 top-12 right-4 flex flex-col p-2 bg-stone-900 border border-stone-700 rounded-xl shadow-xl origin-top-right"
	transition:scale={{ duration: 150 }}
>
	<slot />
</div>
