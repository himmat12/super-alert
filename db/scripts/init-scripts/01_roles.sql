BEGIN;
DO $$

    BEGIN
        -- speralert developer user 
        IF NOT EXISTS (SELECT 1 from pg_roles WHERE rolname = 'superalert_dev') THEN
            EXECUTE format(
			'CREATE ROLE %I WITH LOGIN PASSWORD %L', 
			'superalert_dev', 
			'dev'
			);
        END IF;
        
        -- speralert app user
        IF NOT EXISTS (SELECT 1 from pg_roles WHERE rolname = 'superalert_user') THEN
            EXECUTE format(
				'CREATE ROLE %I WITH LOGIN PASSWORD %L', 
				'superalert_user', 
				'user'
				);
        END IF;

        -- speralert db worker user
        IF NOT EXISTS (SELECT 1 from pg_roles WHERE rolname = 'superalert_worker') THEN
            EXECUTE format(
			'CREATE ROLE %I NOLOGIN', 
			'superalert_worker'
			);
        END IF;
END $$;
COMMIT;

