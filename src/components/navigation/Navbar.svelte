<script lang="ts">
	import PantherGamesLogo from '../PantherGamesLogo.svelte';
	import NavButton from './NavButton.svelte';
	import { sections } from '../sectionsModel';
</script>

<div
	class="fixed inset-y-0 left-0 w-64 p-4 bg-stone-900 border-r border-stone-800 shadow-xl transition-all"
>
	<nav class="flex flex-col">
		<a href="/home" class="pb-4"><PantherGamesLogo size={2} /></a>
		{#each sections as section}
			<NavButton href={section.href} text={section.text} icon={section.icon} />
		{/each}
	</nav>
</div>
