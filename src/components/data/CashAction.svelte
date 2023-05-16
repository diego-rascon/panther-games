<script lang="ts">
	import Icon from '@iconify/svelte';
	import type { IconifyIcon } from '@iconify/svelte';

	export let icon: IconifyIcon;
	export let text: string;
	export let active: boolean;
</script>

<button
	class="flex flex-col p-4 btn {active ? 'variant-filled-primary' : 'variant-soft-primary'}"
	on:click
>
	<div class="flex flex-col space-y-2 items-center">
		<Icon {icon} height={48} />
		<p class="unstyled font-lexend font-bold text-xl">{text}</p>
	</div>
</button>
