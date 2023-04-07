<script lang="ts">
	import Icon from '@iconify/svelte';
	export let href: string;
	export let text: string;
	export let icon: string;
</script>

<a {href}>
	<div class="flex p-4 space-x-4 hover:bg-stone-800 active:bg-stone-950 rounded-xl transition-all select-none">
		<Icon {icon} height={24} />
		<p>{text}</p>
	</div>
</a>
