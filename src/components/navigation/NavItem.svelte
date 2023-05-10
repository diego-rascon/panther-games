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
	data-sveltekit-preload-data="hover"
	{href}
	class="flex p-4 justify-start space-x-4 select-none {isActive
		? 'btn variant-filled-primary font-bold'
		: 'btn variant-filled-surface text-stone-500'}"
>
	<Icon {icon} height={24} />
	<p>{text}</p>
</a>
