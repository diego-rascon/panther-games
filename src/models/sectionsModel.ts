import type { IconifyIcon } from '@iconify/types';
import gamepadLinear from '@iconify/icons-solar/gamepad-outline';
import dollarMinimalisticLinear from '@iconify/icons-solar/dollar-minimalistic-outline';
import crownStarLinear from '@iconify/icons-solar/crown-star-outline';
import userLinear from '@iconify/icons-solar/user-outline';
import documentTextLinear from '@iconify/icons-solar/document-text-outline';
import logoutLinear from '@iconify/icons-solar/logout-outline';

export type SectionData = {
	href: string;
	text: string;
	icon: IconifyIcon;
};

export const sections: SectionData[] = [
	{ href: '/home', text: 'Productos', icon: gamepadLinear },
	{ href: '/home/sales', text: 'Ventas', icon: dollarMinimalisticLinear },
	{ href: '/home/members', text: 'Miembros', icon: crownStarLinear },
	{ href: '/home/clients', text: 'Clientes', icon: userLinear },
	{ href: '/home/reports', text: 'Reportes', icon: documentTextLinear },
	{ href: '/', text: 'Cerrar sesión', icon: logoutLinear }
];
