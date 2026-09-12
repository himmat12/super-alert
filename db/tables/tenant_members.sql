begin;
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
commit;