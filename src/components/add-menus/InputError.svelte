<script lang="ts">
	export let isWarning: boolean = false;
	export let text: string;
</script>

<p class={isWarning ? 'text-amber-500' : 'text-rose-600'}>{text}</p>
