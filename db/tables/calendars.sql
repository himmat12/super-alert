begin;
    create table if not exists dt.calendars(
        id bigint generated always as identity primary key,
        oauth_token_id bigint not null,
        external_calendar_id varchar(100) unique,
        summary varchar(200),
        description text,
        timezone text,
        is_primary boolean not null default false,
        created_at timestamptz not null default current_timestamp,
        updated_at timestamptz,
        is_active boolean not null default true,

        constraint calendars_oauth_token_id_fk
            foreign key (oauth_token_id)
            references dt.oauth_tokens(id)
            on delete cascade
    );
commit;

