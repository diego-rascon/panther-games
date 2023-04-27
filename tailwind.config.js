/** @type {import('tailwindcss').Config} */
export default {
	content: ['./src/**/*.{html,js,svelte,ts}'],
	theme: {
		extend: {
			fontFamily: {
				lexend: ['"Lexend"', 'sans-serif']
			}
		}
	},
	darkMode: 'class',
	plugins: [require('tailwind-scrollbar')],
	variants: {
		scrollbar: ['rounded']
	}
};
