<script lang="ts">
	import Icon from '@iconify/svelte';
	import refreshCircleOutline from '@iconify/icons-solar/refresh-circle-outline';
</script>

<div class="flex items-center justify-center space-x-2 transition-all">
	<div class="animate-spin">
		<Icon icon={refreshCircleOutline} height={24} hFlip={true} />
	</div>
	<p>Cargando...</p>
</div>
