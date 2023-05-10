<script lang="ts">
	import Icon from '@iconify/svelte';

	export let search: boolean;
</script>

<div class="flex flex-col p-24 items-center space-y-4 text-stone-500">
	<Icon icon="solar:sad-square-outline" height={64} color="" />
	<p>
		{search
			? 'No se encontraron resultados que coincidan con la busqueda.'
			: 'No se encontraron registros.'}
	</p>
</div>
