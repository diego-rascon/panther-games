<script>
	import Icon from '@iconify/svelte';
	import SectionTitle from '../SectionTitle.svelte';
</script>

<div class="flex justify-between p-4 bg-stone-900 md:hidden">
	<button class="p-2 hover:bg-stone-800 active:bg-stone-950 rounded-xl transition-all">
		<Icon icon="ion:menu" height={24} />
	</button>
	<SectionTitle text="Inicio" />
</div>
