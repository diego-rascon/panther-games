export interface sectionData {
	href: string;
	text: string;
	icon: string;
}

export const sections: sectionData[] = [
	{ href: '/home', text: 'Inicio', icon: 'solar:home-smile-outline' },
	{ href: '/home/products', text: 'Productos', icon: 'solar:gamepad-outline' },
	{ href: '/home/sales', text: 'Ventas', icon: 'solar:dollar-minimalistic-outline' },
	{ href: '/home/reports', text: 'Reportes', icon: 'solar:document-text-outline' },
	{ href: '/', text: 'Cerrar sesión', icon: 'solar:logout-outline' },
];
