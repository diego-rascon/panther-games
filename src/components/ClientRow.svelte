<script lang="ts">
	import crownMinimalisticBold from '@iconify/icons-solar/crown-minimalistic-bold';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import Icon from '@iconify/svelte';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';

	export let id: number;
	export let name: string;
	export let email: string;
	export let phone: string;
	export let member: boolean;
</script>

<td class="p-2 text-left">{id}</td>
<td class="p-2 text-left">{name}</td>
<td class="p-2 text-left">{email}</td>
<td class="p-2 text-left">{phone}</td>
<td class="p-2 text-center">
	{#if member}
		<Icon icon={crownMinimalisticBold} color="#e6d92e" />
	{/if}
</td>
<td class="relative py-2 text-right">
	<button class="rounded-full p-2 hover:bg-stone-800 active:bg-stone-950 transition-all">
		<Icon icon={menuDotsBold} rotate={1} height={24} />
	</button>
</td>
