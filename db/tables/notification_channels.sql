begin;
    create table if not exists dt.notification_channels(
        id bigint generated always as identity primary key,
        name varchar(100),
        description text
    );
commit;