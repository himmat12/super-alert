BEGIN;
    -- revoke connect and temp table creation from PUBLIC
    REVOKE CONNECT ON DATABASE superalert FROM PUBLIC;
    REVOKE TEMPORARY ON DATABASE superalert FROM PUBLIC;

    --  grant connect and temporary table creation to users
    GRANT CONNECT ON DATABASE superalert TO superalert_dev;
    GRANT TEMPORARY ON DATABASE superalert TO superalert_dev;
    
    GRANT CONNECT ON DATABASE superalert TO superalert_user;
    
COMMIT;