<script lang="ts">
	import Icon from '@iconify/svelte';
	import addCircleLinear from '@iconify/icons-solar/add-circle-linear';
</script>

<button on:click class="flex m-4 p-4 space-x-2 btn variant-filled-primary shadow-xl">
	<Icon icon={addCircleLinear} height={32} />
	<p class="font-bold">Nuevo</p>
</button>
