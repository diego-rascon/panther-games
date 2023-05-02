<script lang="ts">
	import { scale } from 'svelte/transition';
</script>

<div
	class="z-[999] flex flex-col p-2 bg-stone-900 border border-stone-800 rounded-xl shadow-xl"
	transition:scale={{ duration: 150 }}
>
	<slot />
</div>
