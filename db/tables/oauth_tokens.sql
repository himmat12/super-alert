begin;
    create table if not exists dt.oauth_tokens(
        id bigint generated always as identity primary key,
        user_id bigint not null,
        provider varchar(100),
        provider_email varchar(100),
        access_token text,
        refresh_token text,
        connection_scope text not null,
        created_at timestamptz not null default current_timestamp,
        refreshed_at timestamptz,
        expires_at timestamptz,
        is_active boolean not null default true,

        constraint connection_scope_check
            check (connection_scope in ('identity_and_calendar', 'calendar_only')),

        constraint oauth_tokens_user_id_fk
            foreign key (user_id)
            references dt.users(id)
            on delete cascade
    );
commit;
