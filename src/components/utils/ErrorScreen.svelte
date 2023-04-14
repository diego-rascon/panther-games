<script lang="ts">
	import Icon from '@iconify/svelte';
	import sadSquareOutline from '@iconify/icons-solar/sad-square-outline';

	export let text: string;
</script>

<div class="flex flex-col items-center justify-center p-4 space-y-4 transition-all">
	<Icon icon={sadSquareOutline} height={64} />
	<p>Ocurrió un error cargando los datos ({text}).</p>
</div>
