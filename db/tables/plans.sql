begin;
    create table if not exists dt.plans(
        id bigint generated always as identity primary key,
        title varchar(50),
        description text,
        price numeric(19, 4) not null,
        billing_interval text not null,
        interval_count int not null default 1,
        currency_code char(3) not null,
        created_at timestamp not null default current_timestamp,
        updated_at timestamp,
        is_active boolean not null default true,

        constraint pans_billing_interval_check
            check (billing_interval in ('day', 'week', 'month', 'year')),
        
        constraint plans_interval_count_check
            check (interval_count > 0),
            
        constraint pans_billing_currency_code_check
            check (currency_code ~ '^[A-Z]{3}$')
    );
commit;