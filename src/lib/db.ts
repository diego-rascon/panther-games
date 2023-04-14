import { createClient } from '@supabase/supabase-js';
import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';

export const supabase = createClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY);

type User = {
	cliente_nombre: string;
	cliente_email: string;
	cliente_telefono: string;
	cliente_miembro: boolean;
};

const fetchClients = async () => {
	const { data } = await supabase.from('cliente').select().order('cliente_id', { ascending: true });
	return data ?? [];
};

const addClient = async (user: User) => {
	const { data } = await supabase.from('cliente').insert(user).select().maybeSingle();
	return data ?? [];
};

export default {
	clients: {
		all: fetchClients(),
		add: addClient
	}
};

/*
const addCategory = async () => {
    let categoryName = 'nueva categoria'.trim();
    if (categories.length) {
        let { data: category, error } = await supabase
            .from('categoria')
            .insert([{ categoria_nombre: categoryName }])
            .select()
            .single();

        if (error) {
            errorText = error.message;
        } else {
            categories = [...categories, category];
        }
    }
};
*/
