<script>
	import Icon from '@iconify/svelte';
	import Navbar from '../../components/navigation/Navbar.svelte';
	import SectionTitle from '../../components/SectionTitle.svelte';

	let navbarVisible = true;

	function showNavbar() {
		navbarVisible = !navbarVisible;
	}
</script>

<div class="relative min-h-screen md:flex bg-stone-950">
	<div class="flex justify-between p-4 bg-stone-900 md:hidden">
		<button
			on:click={showNavbar}
			class="p-2 hover:bg-stone-800 active:bg-stone-950 rounded-xl transition-all"
		>
			<Icon icon="ion:menu" height={24} />
		</button>
		<SectionTitle text="Inicio" />
	</div>
	<Navbar {navbarVisible} />
	<div class="flex-1 p-4">
		<slot />
	</div>
</div>
