begin;
    create table if not exists dt.event_notifications(
        id bigint generated always as identity primary key,
        event_id bigint not null,
        notification_step_id bigint not null,

        scheduled_at timestamptz not null,
        status text not null default 'pending',

        attempt_count int not null default 0,
        max_attempts int not null default 5,
        next_attempt_at timestamptz,

        idempotency_key text,

        delivered_at timestamptz,
        created_at timestamptz not null default current_timestamp,
        updated_at timestamptz,

        constraint event_notification_status_check
            check (status in ('pending', 'processing', 'delivered', 'retryable', 'failed', 'cancelled')),

        constraint event_notifications_attempt_count_check
            check (attempt_count >= 0),

        constraint event_notifications_max_attempts_check
            check (max_attempts > 0),

        constraint event_notifications_event_id_fk
            foreign key (event_id)
            references dt.events(id)
            on delete cascade,

        constraint event_notifications_notification_step_id_fk
            foreign key (notification_step_id)
            references dt.notification_steps(id)
            on delete cascade
    );
commit;

