import { writable } from 'svelte/store';

export const productsStore = writable<{ [key: number]: unknown }[]>([]);
