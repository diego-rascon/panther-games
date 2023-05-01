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
	class="flex p-4 space-x-4 rounded-xl outline-none transition-all select-none text-white {isActive
		? 'btn variant-filled-primary'
		: 'btn'}"
>
	<Icon {icon} height={24} />
	<p>{text}</p>
</a>
