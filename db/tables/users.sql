BEGIN;
    CREATE TABLE IF NOT EXISTS dt.users(
        ID int,
        Name varchar(50)
    );
COMMIT;
