<script lang="ts">
	export let type: string;
	export let placeholder: string;
</script>

<input
	class="px-4 py-2 rounded-xl bg-stone-900 outline-none focus:outline-pink-700 transition-all"	
	{type}
	{placeholder}
/>
