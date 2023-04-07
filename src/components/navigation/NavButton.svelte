<script lang="ts">
	import Icon from '@iconify/svelte';
	export let href: string;
	export let text: string;
    export let icon: string;
</script>

<a {href} class="flex p-4 hover:bg-stone-800 rounded-xl"
	><Icon icon={icon} width={24} />{text}</a
>
