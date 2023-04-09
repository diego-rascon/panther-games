import { redirect } from '@sveltejs/kit';
import type { PageServerLoad } from './$types';
import { sections } from '../models/sectionsModel';

export const load: PageServerLoad = async ({ url, locals: { getSession } }) => {
	const session = await getSession();

	// if the user is already logged in return them to the account page
	if (session) {
		throw redirect(303, sections[0].href);
	}

	return { url: url.origin };
};
