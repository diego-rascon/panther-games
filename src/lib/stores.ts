import { writable } from 'svelte/store';

export const cartItems = writable<number[]>([]);
export const activeProducts = writable<{ [key: number]: unknown }[]>([]);
