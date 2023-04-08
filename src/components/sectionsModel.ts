export interface sectionData {
	href: string;
	text: string;
	icon: string;
}

export const sections: sectionData[] = [
	{ href: '/home', text: 'Inicio', icon: 'ion:home-outline' },
	{ href: '/home/products', text: 'Productos', icon: 'ion:game-controller-outline' },
	{ href: '/home/sales', text: 'Ventas', icon: 'mdi-light:home' },
	{ href: '/home/reports', text: 'Reportes', icon: 'mdi-light:home' },
	{ href: '/', text: 'Cerrar sesión', icon: 'mdi-light:home' },
];
