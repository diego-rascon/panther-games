<script lang="ts">
	export let isWarning: boolean = false;
	export let text: string;
</script>

<p class={isWarning ? 'text-amber-600' : 'text-red-600'}>{text}</p>
