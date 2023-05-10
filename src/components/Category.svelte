<script lang="ts">
	export let active: boolean;
	export let text: string;
</script>

<button
	on:click
	class="btn p-4 unstyled font-lexend font-bold text-xl {active
		? 'variant-filled-primary'
		: 'variant-soft-primary'}"
>
	{text}
</button>
