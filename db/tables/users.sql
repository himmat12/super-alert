begin;
    create table if not exists dt.users(
        id bigint generated always as identity primary key,
        first_name varchar(50),
        last_name varchar(50),
        email varchar(50),
        avatar bytea,
        created_at timestamp not null default current_timestamp,
        updated_at timestamp,
        is_active boolean not null default true
    );
commit;
