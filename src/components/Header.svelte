<script lang="ts">
	import { page } from '$app/stores';
	import SectionTitle from './SectionTitle.svelte';
	import { sections, type sectionData } from './sectionsModel';

	let title: string;

	$: {
		const route: string | null = $page.route.id;
		const section: sectionData | undefined = sections.find((section) => section.href === route);
		if (section) title = section.text;
	}
</script>

<div class="flex items-center space-x-4">
	<SectionTitle text={title} />
</div>
