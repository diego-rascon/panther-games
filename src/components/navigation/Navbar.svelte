<script lang="ts">
	import PantherGamesLogo from '../titles/PantherGamesLogo.svelte';
	import NavItem from './NavItem.svelte';
	import gamepadLinear from '@iconify/icons-solar/gamepad-linear';
	import dollarMinimalisticLinear from '@iconify/icons-solar/dollar-minimalistic-linear';
	import watchRoundOutline from '@iconify/icons-solar/watch-round-outline';
	import crownStarLinear from '@iconify/icons-solar/crown-star-linear';
	import usersGroupRoundedOutline from '@iconify/icons-solar/users-group-rounded-outline';
	import documentTextLinear from '@iconify/icons-solar/document-text-linear';
	import moneyBagOutline from '@iconify/icons-solar/money-bag-outline';
	import logoutLinear from '@iconify/icons-solar/logout-linear';
	import DarkenSreen from '../modals/DarkenSreen.svelte';
	import SectionTitle from '../titles/SectionTitle.svelte';
	import { text } from 'svelte/internal';
	import { scale } from 'svelte/transition';

	const sections = [
		{ href: '/home', text: 'Productos', icon: gamepadLinear },
		{ href: '/home/sales', text: 'Ventas', icon: dollarMinimalisticLinear },
		{ href: '/home/rents', text: 'Rentas', icon: watchRoundOutline },
		{ href: '/home/members', text: 'Miembros', icon: crownStarLinear },
		{ href: '/home/clients', text: 'Clientes', icon: usersGroupRoundedOutline },
		{ href: '/home/reports', text: 'Reportes', icon: documentTextLinear }
	];
</script>

<nav
	class="fixed inset-y-0 left-0 w-64 flex flex-col p-4 bg-stone-900 border-r border-stone-800 shadow-xl transition-all overflow-auto"
>
	<a data-sveltekit-preload-data="hover" href="/home" class="btn p-4 rounded-xl">
		<PantherGamesLogo size={2} />
	</a>
	{#each sections as section}
		<NavItem href={section.href} text={section.text} icon={section.icon} />
	{/each}
	<div class="mt-auto">
		<NavItem href="/home/cash" text="Caja" icon={moneyBagOutline} />
		<NavItem href="/" text="Cerrar sesión" icon={logoutLinear} />
	</div>
</nav>
