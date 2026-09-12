begin;
    create table if not exists dt.notification_steps(
        id bigint generated always as identity primary key,
        notification_policy_id bigint not null,
        user_notification_channel_id bigint not null,
        offset_interval text not null default 's', -- default to `seconds`
        interval_count int not null default 900, -- default to `900`
        require_acknowledgement boolean not null default false,
        created_at timestamptz not null default current_timestamp,

        constraint unique_notification_policy_and_user_notification_channel
            unique(notification_policy_id, user_notification_channel_id),

        constraint notification_steps_offset_interval_check
            check (offset_interval in ('ms', 's')),

        constraint notification_steps_notification_policy_id_fk
            foreign key (notification_policy_id)
            references dt.notification_policies(id)
            on delete cascade,

        constraint notification_steps_user_notification_channel_id_fk
            foreign key (user_notification_channel_id)
            references dt.user_notification_channels(id)
            on delete cascade
    );
commit;

