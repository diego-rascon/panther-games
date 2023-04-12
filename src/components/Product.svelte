<script lang="ts">
	export let text: string;
	export let category: number;

	const isGame: boolean = category === 1;
</script>

<div class="flex flex-col p-4 text-left bg-stone-900 rounded-xl transition-all">
	<p class="text-xl font-lexend font-bold select-none">{text}</p>
	<div class="mt-auto">
		<div class="py-4">
			{#if isGame}
				<p class="text-sm"><strong>Plataforma:</strong> gaystation</p>
			{/if}
			<p class="text-sm"><strong>Cantidad:</strong> 69</p>
			<p class="pt-4 text-xl font-bold">$420</p>
		</div>
		<button
			class=" w-full py-2 hover:bg-stone-800 active:bg-stone-950 outline-none focus:outline-pink-700 border-2 border-pink-700 transition-all rounded-xl select-none"
		>
			<p class="font-bold">Agregar</p>
		</button>
	</div>
</div>
