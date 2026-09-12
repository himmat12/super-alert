begin;
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
commit;

