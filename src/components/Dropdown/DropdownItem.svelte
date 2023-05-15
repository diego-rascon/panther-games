<script lang="ts">
	import Icon from '@iconify/svelte';
	import type { IconifyIcon } from '@iconify/types';

	export let text: string;
	export let icon: IconifyIcon;
	export let flipIcon = false;
</script>

<button on:click|stopPropagation class="btn variant-filled-surface justify-start space-x-4">
	<Icon {icon} height={20} hFlip={flipIcon} />
	<p>{text}</p>
</button>
