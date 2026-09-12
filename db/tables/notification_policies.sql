begin;
    create table if not exists dt.notification_policies(
        id bigint generated always as identity primary key,
        user_id bigint not null,
        name text,
        is_default boolean not null default false,
        created_at timestamptz not null default current_timestamp,
        updated_at timestamptz,
        is_active boolean not null default true,

        constraint notification_policies_user_id_fk
            foreign key (user_id)
            references dt.users(id)
            on delete cascade
    );
commit;

