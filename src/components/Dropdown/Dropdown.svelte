<script>
	import DropdownItem from './DropdownItem.svelte';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import boxLinear from '@iconify/icons-solar/box-linear';
	import { scale } from 'svelte/transition';
</script>

<div
	class="absolute top-10 right-4 flex flex-col p-2 bg-stone-900 border border-stone-700 rounded-xl shadow-xl origin-top-right"
	transition:scale={{ duration: 150 }}
>
	<DropdownItem text="Editar" icon={pen2Linear} />
	<DropdownItem text="Eliminar" icon={trashBinMinimalisticLinear} />
	<DropdownItem text="Modificar stock" icon={boxLinear} />
</div>
