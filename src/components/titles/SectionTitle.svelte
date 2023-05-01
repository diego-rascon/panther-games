<script lang="ts">
	export let centered: boolean = false;
	export let text: string;
</script>

<p class="unstyled text-4xl font-lexend font-bold select-none {centered ? 'text-center' : 'text-left'}">{text}</p>
