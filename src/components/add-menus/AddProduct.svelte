<script lang="ts">
	import { fade, scale } from 'svelte/transition';
	import SectionTitle from '../titles/SectionTitle.svelte';

	type ClickHandler = () => void;

	export let cancelHandler: ClickHandler;
	export let confirmHandler: ClickHandler;
	export let categories: any;
	export let platforms: any;
	export let categoryId: number;
	export let platformId: number;
	export let name: string;
	export let price: number;
	export let stock: number;
    export let minimumStock: number;
	export let used: boolean;

	const animDuration = 150;
</script>

<div
	class="fixed inset-0 flex justify-center items-center bg-black transition-all bg-opacity-75"
	transition:fade={{ duration: animDuration }}
>
	<div
		class="flex flex-col p-8 space-y-8 bg-stone-950 border border-stone-700 rounded-xl transition-all"
		transition:scale={{ duration: animDuration }}
	>
		<SectionTitle text="Registrar Producto" />
		<div class="flex flex-col space-y-4 transition-all">
			<select
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				bind:value={categoryId}
			>
				{#each categories as category}
					<option value={category.categoria_id}>{category.categoria_nombre}</option>
				{/each}
			</select>
			{#if categoryId === 1}
				<select
					transition:fade={{ duration: animDuration }}
					class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
					bind:value={platformId}
				>
					{#each platforms as platform}
						<option value={platform.plataforma_id}>{platform.plataforma_nombre}</option>
					{/each}
				</select>
			{/if}
			<input
				type="text"
				required
				bind:value={name}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Nombre"
			/>
			<input
				type="number"
				required
				bind:value={price}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Precio"
			/>
			<input
				type="number"
				required
				bind:value={stock}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Stock"
			/>
            <input
				type="number"
				required
				bind:value={minimumStock}
				class="bg-stone-900 w-full p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				placeholder="Mínimo de stock"
			/>
			<label class="flex px-4 justify-between select-none">
				Producto usado
				<input
					type="checkbox"
					required
					bind:value={used}
					class="bg-stone-900 p-2 px-4 rounded-xl outline-none focus:outline-pink-600 transition-all"
				/>
			</label>
		</div>
		<div class="grid grid-cols-1 gap-4 sm:grid-cols-2">
			<button
				class="py-2 border-2 border-pink-600 hover:bg-stone-900 active:bg-black outline-none focus:outline-pink-600 rounded-xl transition-all select-none"
				on:click={cancelHandler}
			>
				Cancelar
			</button>
			<button
				class="py-2 btn-fill font-bold rounded-xl transition-all select-none"
				on:click={confirmHandler}
			>
				Confirmar
			</button>
		</div>
	</div>
</div>
