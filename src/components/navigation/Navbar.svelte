<script lang="ts">
	import PantherGamesLogo from '../PantherGamesLogo.svelte';
	import NavButton from './NavButton.svelte';

	export let navbarVisible: boolean;
</script>

<div
	class={'absolute inset-y-0 left-0 w-64 p-4 transform -translate-x-full md:relative md:translate-x-0 bg-stone-900 border-r border-stone-800 shadow-xl transition' +
		(navbarVisible ? '-translate-x-full' : '')}
>
	<nav class="flex flex-col">
		<a href="/home" class="pb-4"><PantherGamesLogo size={2} /></a>
		<NavButton href="/home" text="Inicio" icon="ion:home-outline" />
		<NavButton href="/home/products" text="Productos" icon="ion:game-controller-outline" />
		<NavButton href="/home/sales" text="Ventas" icon="mdi-light:home" />
		<NavButton href="/home/reports" text="Reportes" icon="mdi-light:home" />
		<NavButton href="/" text="Cerrar sesión" icon="mdi-light:home" />
	</nav>
</div>
