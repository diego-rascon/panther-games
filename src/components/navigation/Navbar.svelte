<script lang="ts">
	import PantherGamesLogo from '../PantherGamesLogo.svelte';
	import NavItem from './NavItem.svelte';
	import { sections } from '../../models/sectionsModel';
</script>

<div
	class="fixed inset-y-0 left-0 w-64 p-4 pt-0 bg-stone-900 border-r border-stone-800 shadow-xl transition-all"
>
	<nav class="flex flex-col">
		<a
			href="/home"
			data-sveltekit-preload-data
			class="p-4 outline-none focus:outline-pink-700 rounded-xl"><PantherGamesLogo size={2} /></a
		>
		{#each sections as section}
			<NavItem href={section.href} text={section.text} icon={section.icon} />
		{/each}
	</nav>
</div>
