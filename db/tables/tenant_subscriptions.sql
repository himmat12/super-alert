begin;
    create table if not exists dt.tenant_subscriptions(
        tenant_id bigint not null,
        plan_id bigint not null,
        provider_customer_id varchar(100) not null,
        provider_subscription_id varchar(100) not null,
        status varchar(50),
        sarted_at timestamp,
        current_period_start timestamp,
        current_period_end timestamp,
        cancelled_at timestamp,
        created_at timestamp not null default current_timestamp,
        updated_at timestamp,
        is_active boolean default true,


        constraint tenant_subscriptions_pk
            primary key (tenant_id, plan_id),
        
        constraint tenant_subscriptions_tenant_id_fk
            foreign key (tenant_id)
            references dt.tenants(id)
            on delete set null,

        constraint tenant_subscriptions_plan_id_fk
            foreign key (plan_id)
            references dt.plans(id)
    );
commit;