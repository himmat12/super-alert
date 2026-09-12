begin;
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
commit;