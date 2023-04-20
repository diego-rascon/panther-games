<script lang="ts">
	import Icon from '@iconify/svelte';
	import refreshCircleLinear from '@iconify/icons-solar/refresh-circle-linear';

	export let text: string;
</script>

<div class="flex items-center justify-center p-4 space-x-2 transition-all">
	<div class="animate-spin">
		<Icon icon={refreshCircleLinear} height={28} hFlip={true} />
	</div>
	<p>Cargando {text}...</p>
</div>
