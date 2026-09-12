begin;
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
commit;