<script>
	import PantherGamesLogo from '../PantherGamesLogo.svelte';
	import NavButton from './NavButton.svelte';
</script>

<div class="w-64 p-4 bg-stone-900 border-r border-stone-800 shadow-xl">
	<nav class="flex flex-col">
		<a href="/home"><PantherGamesLogo size={2} /></a>
		<NavButton href="/home" text="Inicio" />
		<NavButton href="/home/products" text="Productos" />
		<NavButton href="/home/sales" text="Ventas" />
		<NavButton href="/home/reports" text="Reportes" />
		<NavButton href="/" text="Cerrar sesión" />
	</nav>
</div>
