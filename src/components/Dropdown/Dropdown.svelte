<script>
	import DropdownItem from './DropdownItem.svelte';
	import pen2Outline from '@iconify/icons-solar/pen-2-outline';
	import trashBinMinimalisticOutline from '@iconify/icons-solar/trash-bin-minimalistic-outline';
	import boxOutline from '@iconify/icons-solar/box-outline';
	import { scale } from 'svelte/transition';
</script>

<div
	class="absolute top-10 right-4 flex flex-col p-2 bg-stone-900 border border-stone-700 rounded-xl shadow-xl origin-top-right"
	transition:scale={{ duration: 150 }}
>
	<DropdownItem text="Editar" icon={pen2Outline} />
	<DropdownItem text="Eliminar" icon={trashBinMinimalisticOutline} />
	<DropdownItem text="Modificar stock" icon={boxOutline} />
</div>
