import { supabase } from '$lib/db';

export const load = async () => {
	const fetchMembers = async () => {
		const { data, error } = await supabase
			.from('cliente')
			.select()
			.eq('cliente_miembro', true)
			.order('cliente_id', { ascending: false });
		if (error) console.log(error);
		if (data) console.log(data);

		return data ?? [];
	};
	/*
	const fetchMembers = async () => {
		const { data } = await supabase.rpc('members');
		return data ?? [];
	};
	*/
	return { members: fetchMembers() };
};
