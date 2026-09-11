CREATE OR REPLACE FUNCTION api.get_all_users() 
RETURNS SETOF dt.users
LANGUAGE plpgsql
AS $$
    BEGIN
        RETURN QUERY
            SELECT * FROM dt.users; 
    END;
$$;