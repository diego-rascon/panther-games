import { writable } from 'svelte/store';

export const productsStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const cartStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const salesStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const clientsStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const membersStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const cajaTotalStore = writable(0);