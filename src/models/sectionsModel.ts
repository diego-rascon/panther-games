import type { IconifyIcon } from '@iconify/types';
import gamepadOutline from '@iconify/icons-solar/gamepad-outline';
import dollarMinimalisticOutline from '@iconify/icons-solar/dollar-minimalistic-outline';
import crownStarOutline from '@iconify/icons-solar/crown-star-outline';
import userOutline from '@iconify/icons-solar/user-outline';
import documentTextOutline from '@iconify/icons-solar/document-text-outline';
import logoutOutline from '@iconify/icons-solar/logout-outline';

export type sectionData = {
	href: string;
	text: string;
	icon: IconifyIcon;
};

export const sections: sectionData[] = [
	{ href: '/home', text: 'Productos', icon: gamepadOutline },
	{ href: '/home/sales', text: 'Ventas', icon: dollarMinimalisticOutline },
	{ href: '/home/members', text: 'Miembros', icon: crownStarOutline },
	{ href: '/home/clients', text: 'Clientes', icon: userOutline },
	{ href: '/home/reports', text: 'Reportes', icon: documentTextOutline },
	{ href: '/', text: 'Cerrar sesión', icon: logoutOutline }
];
