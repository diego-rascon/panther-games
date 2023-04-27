<script lang="ts">
	export let centered: boolean = false;
	export let text: string;
</script>

<h1 class="text-4xl font-lexend font-bold select-none {centered ? 'text-center' : 'text-left'}">{text}</h1>
