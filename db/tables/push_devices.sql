begin;
    create table if not exists dt.push_devices(
        id bigint generated always as identity primary key,
        user_id bigint not null,
        platform varchar(50),
        push_token varchar(100),
        endpoint varchar(100),
        last_seen_at timestamptz,
        is_active boolean default true,

        constraint push_devices_user_id_fk
            foreign key (user_id)
            references dt.users(id)
            on delete cascade
    );
commit;