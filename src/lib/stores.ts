import { writable } from 'svelte/store';

export const session = writable(false);
export const readUser = writable(false);
export const editUser = writable(false);

export const productsStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const cartStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const salesStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const rentsStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const clientsStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const membersStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const usersStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const cajaTotalStore = writable(0);
