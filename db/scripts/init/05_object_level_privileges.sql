BEGIN;

    -- setting default GRANT privileges on all tables
    ALTER DEFAULT PRIVILEGES FOR ROLE superalert_dev IN SCHEMA dt 
        GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO superalert_worker;

    -- Table/Sequences GRANT for superalert_dev 
    ALTER DEFAULT PRIVILEGES FOR ROLE superalert_dev IN SCHEMA dt 
        GRANT ALL PRIVILEGES ON TABLES TO superalert_dev;
    ALTER DEFAULT PRIVILEGES FOR ROLE superalert_dev IN SCHEMA dt 
        GRANT ALL PRIVILEGES ON SEQUENCES TO superalert_dev;
    
    -- Functions/Procedures GRANT for superalert_dev 
    ALTER DEFAULT PRIVILEGES FOR ROLE superalert_dev IN SCHEMA api 
        GRANT ALL PRIVILEGES ON FUNCTIONS TO superalert_dev;
    
    -- Functions/Procedures GRANT for superalert_user 
    ALTER DEFAULT PRIVILEGES FOR ROLE superalert_dev IN SCHEMA api 
        GRANT EXECUTE ON FUNCTIONS TO superalert_user;

COMMIT;