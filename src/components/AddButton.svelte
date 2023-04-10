<script lang="ts">
	import Icon from '@iconify/svelte';

	export let cartVisible: boolean;

	type ClickHandler = () => void;
	export let buttonHandler: ClickHandler;
</script>

<button
	on:click={buttonHandler}
	class="fixed bottom-0 flex m-4 p-4 items-center space-x-2 btn-fill rounded-xl shadow-xl transition-all {cartVisible
		? 'right-64'
		: 'right-0'}"
>
	<Icon icon="solar:add-circle-outline" height={32} />
	<p class="font-bold">Agregar</p>
</button>
