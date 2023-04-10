<script lang="ts">
	import SectionTitle from './titles/SectionTitle.svelte';

	export let cartVisible: boolean;
</script>

<div
	class="fixed inset-y-0 right-0 w-64 p-4 bg-stone-900 border-l border-stone-800 transition ease-in-out {!cartVisible
		? 'translate-x-full'
		: ''}"
>
	<SectionTitle text="Carrito" />
</div>
