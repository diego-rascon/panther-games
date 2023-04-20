<script lang="ts">
	import Icon from '@iconify/svelte';
	import type { IconifyIcon } from '@iconify/types';

	type ClickHandler = () => void;

	export let text: string;
	export let icon: IconifyIcon;
</script>

<button
	class="flex items-center px-4 py-2 space-x-4 hover:bg-stone-800 active:bg-stone-950 rounded-xl transition-all"
>
	<Icon {icon} height={20} />
	<p>{text}</p>
</button>
