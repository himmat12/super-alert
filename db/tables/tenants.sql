begin;
    create table if not exists dt.tenants(
        id bigint generated always as identity primary key,
        name varchar(100),
        slug varchar(100),
        created_at timestamp not null default current_timestamp,
        is_active boolean not null default true
    );
commit;