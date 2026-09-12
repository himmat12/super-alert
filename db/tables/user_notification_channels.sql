begin;
    create table if not exists dt.user_notification_channels(
        id bigint generated always as identity primary key,
        user_id bigint not null,
        notification_channel_id bigint not null,
        is_enabled boolean not null default true,
        order_sequence_number int default 0,
        verified_at timestamptz,
        created_at timestamptz not null default current_timestamp,
        updated_at timestamptz,

        constraint unique_user_id_and_notification_channel_id
            unique (user_id, notification_channel_id),

        constraint user_notification_channels_user_id_fk
            foreign key (user_id)
            references dt.users(id)
            on delete cascade,

        constraint user_notification_channels_notification_channel_id_fk
            foreign key (notification_channel_id)
            references dt.notification_channels(id)
            on delete cascade
    );
commit;

