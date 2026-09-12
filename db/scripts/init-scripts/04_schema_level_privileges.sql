BEGIN;
    -- revoke anyone who can connect on dtbase server from accessing from public schema
    REVOKE ALL ON SCHEMA public FROM PUBLIC;   

    -- changing schemas ownership to least privilege user `superalert_worker`
    ALTER SCHEMA dt OWNER TO superalert_worker;
    ALTER SCHEMA api OWNER TO superalert_worker;

    -- grant USAGE to users:
    -- for superalert_dev
    GRANT USAGE ON SCHEMA dt TO superalert_dev;
    GRANT USAGE ON SCHEMA api TO superalert_dev;

    -- for superalert_dev
    GRANT USAGE ON SCHEMA api TO superalert_user;

    -- grant CREATE to users:
    -- for superalert_dev
    GRANT CREATE ON SCHEMA dt TO superalert_dev;
    GRANT CREATE ON SCHEMA api TO superalert_dev;

    -- for superalert_user
    --  No any CREATE, UPDATE or DELETE GRANT for `superaler_user` but just USAGE on `api` schema 
    
COMMIT;