import { writable } from 'svelte/store';

export const cartItems = writable<number[]>([]);
