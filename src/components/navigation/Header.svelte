<script lang="ts">
	import { page } from '$app/stores';
	import { sections, type sectionData } from '../../models/sectionsModel';
	import SectionTitle from '../titles/SectionTitle.svelte';

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
