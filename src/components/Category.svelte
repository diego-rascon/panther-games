<script lang="ts">
	export let text: string;
</script>

<button
	class="p-4 border-2 hover:bg-stone-900 active:bg-black border-pink-700 outline-none focus:outline-pink-700 rounded-xl transition-all"
>
	<p class="select-none font-lexend font-bold">{text}</p>
</button>
