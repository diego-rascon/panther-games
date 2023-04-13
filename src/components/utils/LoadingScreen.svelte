<script lang="ts">
	import Icon from '@iconify/svelte';

	export let text: string;
</script>

<div class="flex items-center justify-center p-4 space-x-2 transition-all">
	<Icon class="animate-spin" icon="mingcute:loading-3-fill" height={28} />
	<p>Cargando {text}...</p>
</div>
