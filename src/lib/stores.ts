import { writable } from 'svelte/store';

export const productsStore = writable<{ [key: string]: number | string | boolean }[]>([]);
export const cartStore = writable<{ [key: string]: number | string | boolean }[]>([]);
