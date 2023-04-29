import type { IconifyIcon } from '@iconify/types';
import gamepadLinear from '@iconify/icons-solar/gamepad-linear';
import dollarMinimalisticLinear from '@iconify/icons-solar/dollar-minimalistic-linear';
import crownStarLinear from '@iconify/icons-solar/crown-star-linear';
import userLinear from '@iconify/icons-solar/user-linear';
import documentTextLinear from '@iconify/icons-solar/document-text-linear';

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
	{ href: '/home/reports', text: 'Reportes', icon: documentTextLinear }
];
