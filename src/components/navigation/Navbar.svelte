<script lang="ts">
	import PantherGamesLogo from '../titles/PantherGamesLogo.svelte';
	import NavItem from './NavItem.svelte';
	import logoutLinear from '@iconify/icons-solar/logout-linear';
	import { sections } from '../../lib/sections';
</script>

<nav
	class="fixed inset-y-0 left-0 w-64 flex flex-col p-4 bg-stone-900 border-r border-stone-800 shadow-xl transition-all overflow-auto"
>
	<a
		href="/home"
		data-sveltekit-preload-data
		class="btn p-4 rounded-xl"><PantherGamesLogo size={2} /></a
	>
	{#each sections as section}
		<NavItem href={section.href} text={section.text} icon={section.icon} />
	{/each}
	<div class="mt-auto">
		<NavItem href="/" text="Cerrar sesión" icon={logoutLinear} />
	</div>
</nav>
