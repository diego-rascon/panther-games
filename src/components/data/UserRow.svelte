<script lang="ts">
	import { usersStore } from '$lib/stores';
	import Icon from '@iconify/svelte';
	import Dropdown from '../dropdown/Dropdown.svelte';
	import DropdownItem from '../dropdown/DropdownItem.svelte';
	import menuDotsBold from '@iconify/icons-solar/menu-dots-bold';
	import pen2Linear from '@iconify/icons-solar/pen-2-linear';
	import trashBinMinimalisticLinear from '@iconify/icons-solar/trash-bin-minimalistic-linear';
	import restartLinear from '@iconify/icons-solar/restart-linear';
	import keyOutline from '@iconify/icons-solar/key-outline';

	export let userId: number;

	$: user = $usersStore.find((userEntry: any) => userEntry.usuario_id === userId);
	$: name = user?.usuario_nombre;
	$: userName = user?.usuario_username;
	$: email = user?.usuario_email;
	$: phone = user?.usuario_telefono;
	$: active = user?.usuario_activo;
	$: admin = user?.usuario_admin;
	$: read = user?.usuario_leer;

	let permissions = 'Administrador';
	if (read) permissions = 'Lector';

	let dropdownVisible = false;
	let container: HTMLElement;

	const toggleDropdown = () => {
		dropdownVisible = !dropdownVisible;
	};

	const windowHandler = (e: any) => {
		if (container.contains(e.target) == false) dropdownVisible = false;
	};
</script>

<svelte:window on:click={windowHandler} on:wheel={windowHandler} />
<tr
	class="relative border-t border-stone-800 transition-all {dropdownVisible
		? 'variant-soft-primary'
		: 'hover:bg-stone-800'}"
>
	<td class="p-4 text-left select-text">{userId}</td>
	<td class="text-left select-text">{name}</td>
	<td class="text-left select-text">{userName}</td>
	<td class="text-left select-text">{email}</td>
	<td class="text-left select-text">{phone}</td>
	<td class="text-left select-text">{permissions}</td>
	<td class="pr-4 text-right" bind:this={container}>
		<button
			on:click={toggleDropdown}
			class="btn p-1 rounded-full {dropdownVisible
				? 'variant-soft-primary'
				: 'hover:variant-filled-surface'}"
		>
			<Icon icon={menuDotsBold} rotate={1} height={20} />
		</button>
		{#if dropdownVisible}
			<div class="z-[999] absolute bottom-12 right-4">
				<Dropdown>
					<DropdownItem
						text="Editar"
						icon={pen2Linear}
						on:click={() => {
							toggleDropdown();
						}}
					/>
					{#if active}
						<DropdownItem
							text="Cambiar contraseña"
							icon={keyOutline}
							on:click={() => {
								toggleDropdown();
							}}
						/>
						<DropdownItem
							text="Eliminar"
							icon={trashBinMinimalisticLinear}
							on:click={() => {
								toggleDropdown();
							}}
						/>
					{:else}
						<DropdownItem
							text="Activar"
							icon={restartLinear}
							flipIcon={true}
							on:click={() => {
								toggleDropdown();
							}}
						/>
					{/if}
				</Dropdown>
			</div>
		{/if}
	</td>
</tr>
