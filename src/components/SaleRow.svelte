<script lang="ts">
	import Icon from '@iconify/svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';

	export let id: number;
	export let total: number;
	export let discount: number;
	export let date: string;

	let dropdownVisible = false;

	const toggleDropdown = () => {
		dropdownVisible = !dropdownVisible;
	};
</script>

<tr>
	<td class="p-2 text-left">{id}</td>
	<td class="p-2 text-left">{total}</td>
	<td class="p-2 text-left">{discount}</td>
	<td class="p-2 text-left">{date}</td>
	<td class="py-2 text-right">
		<button
			on:click={toggleDropdown}
			class="rounded-full p-2 hover:bg-stone-800 active:bg-stone-950 transition-all"
		>
			<Icon icon={menuDotsBold} rotate={1} height={24} />
		</button>
	</td>
</tr>
