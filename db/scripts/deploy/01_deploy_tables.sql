-- drop all tables
begin;
    drop table if exists dt.notification_attempts;                  -- 01
    drop table if exists dt.event_notifications;                    -- 02
    drop table if exists dt.events;                                 -- 03
    drop table if exists dt.calendars;                              -- 04
    drop table if exists dt.oauth_tokens;                           -- 05
    drop table if exists dt.notification_steps;                     -- 06
    drop table if exists dt.notification_policies;                  -- 07
    drop table if exists dt.user_notification_channels;             -- 08
    drop table if exists dt.notification_channels;                  -- 09
    drop table if exists dt.push_devices;                           -- 10
    drop table if exists dt.tenant_members;                         -- 11
    drop table if exists dt.users;                                  -- 12
    drop table if exists dt.plan_features;                          -- 13
    drop table if exists dt.tenant_subscriptions;                   -- 14
    drop table if exists dt.plans;                                  -- 15
    drop table if exists dt.tenants;                                -- 16
commit;


-- create tables
begin;
    -- 01 users
    create table if not exists dt.users(
        id bigint generated always as identity primary key,
        first_name varchar(50),
        last_name varchar(50),
        email varchar(50),
        avatar bytea,
        created_at timestamptz not null default current_timestamp,
        updated_at timestamptz,
        is_active boolean not null default true
    );

    -- 02 tenants
    create table if not exists dt.tenants(
        id bigint generated always as identity primary key,
        name varchar(100),
        slug varchar(100),
        created_at timestamptz not null default current_timestamp,
        is_active boolean not null default true
    );

    -- 03 tenant_members
    create table if not exists dt.tenant_members(
        tenant_id bigint not null,
        user_id bigint not null,
        role varchar(50),
        created_at timestamptz not null default current_timestamp,

        constraint tenant_members_pk
            primary key (tenant_id, user_id),
        
        constraint tenant_members_tenant_id_fk
            foreign key (tenant_id)
            references dt.tenants (id)
            on delete cascade,
            
        constraint tenant_members_user_id_fk
            foreign key (user_id)
            references dt.users (id)
            on delete cascade
    );

    -- 04 plans
    create table if not exists dt.plans(
        id bigint generated always as identity primary key,
        title varchar(50),
        description text,
        price numeric(19, 4) not null,
        billing_interval text not null,
        interval_count int not null default 1,
        currency_code char(3) not null,
        created_at timestamptz not null default current_timestamp,
        updated_at timestamptz,
        is_active boolean not null default true,

        constraint pans_billing_interval_check
            check (billing_interval in ('day', 'week', 'month', 'year')),
        
        constraint plans_interval_count_check
            check (interval_count > 0),
            
        constraint pans_billing_currency_code_check
            check (currency_code ~ '^[A-Z]{3}$')
    );

    -- 05 tenant_subscriptions
    create table if not exists dt.tenant_subscriptions(
        tenant_id bigint not null,
        plan_id bigint not null,
        provider_customer_id varchar(100) not null,
        provider_subscription_id varchar(100) not null,
        status varchar(50),
        sarted_at timestamptz,
        current_period_start timestamptz,
        current_period_end timestamptz,
        cancelled_at timestamptz,
        created_at timestamptz not null default current_timestamp,
        updated_at timestamptz,
        is_active boolean default true,

        constraint tenant_subscriptions_pk
            primary key (tenant_id, plan_id),
        
        constraint tenant_subscriptions_tenant_id_fk
            foreign key (tenant_id)
            references dt.tenants(id)
            on delete cascade,

        constraint tenant_subscriptions_plan_id_fk
            foreign key (plan_id)
            references dt.plans(id)
    );

    -- 06 plan_features
    create table if not exists dt.plan_features(
        id bigint generated always as identity primary key,
        plan_id bigint not null,
        feature_key varchar(100) not null,
        feature_value varchar(100) not null,
        value_type varchar(10) not null,

        constraint plan_features_plan_id_fk
            foreign key (plan_id)
            references dt.plans(id)
            on delete cascade,
        
        constraint plan_features_value_type_check
            check (value_type in ('int', 'bool'))
    );

    -- 07 push_devices
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

    -- 08 notification_policies
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

    -- 09 notification_channels 
    create table if not exists dt.notification_channels(
        id bigint generated always as identity primary key,
        name varchar(100),
        description text
    );

    -- 10 user_notification_channels
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

    -- 11 notification_steps
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

    -- 12 oauth_tokens
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

    -- 13 calendars
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

    -- 14 events
    create table if not exists dt.events(
        id bigint generated always as identity primary key,
        calendar_id bigint not null,
        external_event_id varchar(100),
        external_recurring_event_id varchar(100),
        e_tag text,
        kind varchar(100),
        html_link text,
        summary varchar(200),
        description text,
        status varchar(100),
        creator varchar(100),
        organiser varchar(100),
        participants text,
        location varchar(100),
        hangout_link text,
        sunc_status varchar(100),
        event_type varchar(100),
        timezone text,
        starts_at timestamptz not null,
        ends_at timestamptz not null,
        sequence_number int not null default 0,
        created_at timestamptz not null default current_timestamp,
        updated_at timestamptz,
        is_cancelled boolean not null default false,

        constraint unique_calender_external_events_check
            unique(calendar_id, external_event_id),
            
        constraint events_start_and_end_time_check
            check (starts_at < ends_at),

        constraint events_calendar_id_fk
            foreign key (calendar_id)
            references dt.calendars(id)
            on delete cascade
    );

    -- 15 event_notifications
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

    -- 16 notification_attempts
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
