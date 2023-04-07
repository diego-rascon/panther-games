<script>
    import NavButton from "./NavButton.svelte";
</script>

<div class="fixed top-0 w-64 bg-stone-900">
	<nav class="flex flex-col">
        <NavButton href="/home/products" text="Productos" />
        <NavButton href="/home/sales" text="Ventas" />
        <NavButton href="/" text="Cerrar sesión" />
	</nav>
</div>
