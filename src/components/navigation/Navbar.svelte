<script>
	import PantherGamesLogo from '../PantherGamesLogo.svelte';
	import NavButton from './NavButton.svelte';
</script>

<div class="w-64 p-4 bg-stone-900 border-r border-stone-800 shadow-xl">
	<nav class="flex flex-col">
		<a href="/home"><PantherGamesLogo size={2} /></a>
		<NavButton href="/home" text="Inicio" icon="mdi-light:home" />
		<NavButton href="/home/products" text="Productos" icon="mdi-light:home" />
		<NavButton href="/home/sales" text="Ventas" icon="mdi-light:home" />
		<NavButton href="/home/reports" text="Reportes" icon="mdi-light:home" />
		<NavButton href="/" text="Cerrar sesión" icon="mdi-light:home" />
	</nav>
</div>
