<script lang="ts">
	import { scale } from 'svelte/transition';
</script>

<div
	class="flex flex-col p-2 bg-stone-900 border border-stone-800 rounded-xl shadow-xl origin-bottom-right"
	transition:scale={{ duration: 150 }}
>
	<slot />
</div>
