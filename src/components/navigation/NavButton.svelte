<script lang="ts">
	import Icon from '@iconify/svelte';
	import type { IconifyIcon } from '@iconify/types';
	import { page } from '$app/stores';

	export let href: string;
	export let text: string;
	export let icon: IconifyIcon;

	let isActive: boolean = false;

	$: {
		isActive = false;
		const route: string | null = $page.route.id;
		if (href === route) isActive = true;
	}
</script>

<a
	{href}
	data-sveltekit-preload-data
	class="p-4 rounded-xl outline-none transition-all select-none {isActive
		? 'btn-fill font-bold'
		: 'hover:bg-stone-800 active:bg-stone-950 outline-none focus:outline-pink-700 selection:outline-none'}"
>
	<div class="flex space-x-4">
		<Icon {icon} height={24} />
		<p>{text}</p>
	</div>
</a>
