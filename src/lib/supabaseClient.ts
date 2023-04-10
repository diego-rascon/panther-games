import { createClient } from '@supabase/supabase-js';

export const supabase = createClient(
	'https://fetqjcvlfqwclagwhdqy.supabase.co',
	'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZldHFqY3ZsZnF3Y2xhZ3doZHF5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODEwNjg0MzgsImV4cCI6MTk5NjY0NDQzOH0.t83LL3w7cnrYzSXxV43FZ6bqnF_qkl-i5LDLtv2MIPI'
);
