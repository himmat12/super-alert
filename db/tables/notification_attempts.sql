begin;
    create table if not exists dt.notification_attempts(
        id bigint generated always as identity primary key,
        event_notification_id bigint not null,
        attempt_number int not null,

        started_at timestamptz not null default current_timestamp,
        completed_at timestamptz,

        status text not null default 'processing',
        
        provider_message_id text,
        error_code text,
        error_message text,
        next_retry_at timestamptz,

        constraint notification_attempts_number_check
            check (attempt_number > 0),

        constraint notification_attempts_unique_number
            unique (event_notification_id, attempt_number),
            
        constraint notification_atempts_status_check
            check (status in ('processing', 'delivered', 'retryable', 'failed')),

        constraint notification_attempts_event_notification_id_fk
            foreign key (event_notification_id)
            references dt.event_notifications(id)
            on delete cascade
    );
commit;