<script lang="ts">
	import Icon from '@iconify/svelte';
	import addCircleLinear from '@iconify/icons-solar/add-circle-linear';

	type ClickHandler = () => void;

	export let clickHandler: ClickHandler;
</script>

<button
	on:click={clickHandler}
	class="flex m-4 p-4 items-center space-x-2 btn-fill rounded-xl shadow-xl transition-all"
>
	<Icon icon={addCircleLinear} height={32} />
	<p class="font-bold">Agregar</p>
</button>
