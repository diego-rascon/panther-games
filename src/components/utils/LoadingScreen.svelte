<script lang="ts">
	import Icon from '@iconify/svelte';
	import refreshCircleOutline from '@iconify/icons-solar/refresh-circle-outline';

	export let text: string;
</script>

<div class="flex items-center justify-center p-4 space-x-2 transition-all">
	<Icon class="animate-spin" icon={refreshCircleOutline} height={28} hFlip={true} />
	<p>Cargando {text}...</p>
</div>
