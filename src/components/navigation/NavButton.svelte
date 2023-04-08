<script lang="ts">
	import { page } from '$app/stores';
	import Icon from '@iconify/svelte';
	export let href: string;
	export let text: string;
	export let icon: string;

	let isActive: boolean = false;

	$: {
		isActive = false;
		const route: string | null = $page.route.id;
		if (href === route) isActive = true;
	}
</script>

<a
	{href}
	class="p-4 rounded-xl outline-none transition-all select-none {isActive
		? 'btn-fill font-bold'
		: 'hover:bg-stone-800 active:bg-stone-950 outline-none focus:outline-pink-700 selection:outline-none'}"
>
	<div class="flex space-x-4">
		<Icon {icon} height={24} />
		<p>{text}</p>
	</div>
</a>
