create sequence seq_dwh_cities;
create sequence seq_dwh_cashiers;
create sequence seq_dwh_shops;
create sequence seq_dwh_details;
create sequence seq_dwh_masters;
create sequence seq_dwh_clients;
create sequence seq_dwh_diagnoses;
create sequence seq_dwh_invoices;


create or replace package pkg_dwh_dictionary is

    c_source_id_primary constant number(1) := 1;

    procedure add_cities;
    procedure add_shops;
    procedure add_cashiers;
    procedure add_clients;
    procedure add_details;
    procedure add_masters;
    procedure add_diagnoses;

    procedure load_data (
        v_date in date
    );

end pkg_dwh_dictionary;

create or replace package body pkg_dwh_dictionary is


    procedure add_cities is

    v_dwh_city_id number(12);

    begin
       for c0 in ( select c.city_id,
                          c.city_name
                   from   cities c
                   where  to_char(c.city_id) not in
                          ( select i.ext_id
                            from   dwh_cities_id i
                            where  i.dwh_source_id = c_source_id_primary
                          )
                 )
       loop
          insert
          into   dwh_cities
                 ( dwh_city_id,
                   dwh_city_name
                 )
          values ( seq_dwh_cities.nextval,
                   c0.city_name
                 )
          returning dwh_city_id into v_dwh_city_id;

          insert
          into   dwh_cities_id
                 ( dwh_city_id,
                   dwh_source_id,
                   ext_id
                 )
          values ( v_dwh_city_id,
                   c_source_id_primary,
                   to_char(c0.city_id)
                 );

       end loop;
    end;


    procedure add_shops is

        v_dwh_shop_id number(12);

    begin
        for s0 in ( select s.shop_id,
                           s.shop_name,
                           s.SHOP_ADDRESS,
                           s.CITY_ID
                    from   shops s
                    where  to_char(s.SHOP_ID) not in
                           ( select i.ext_id
                             from   dwh_shops_id i
                             where  i.dwh_source_id = c_source_id_primary
                           )
            )
            loop
                insert
                into   dwh_shops
                ( dwh_shop_id,
                  dwh_shop_name,
                  DWH_CITY_ID,
                  DWH_SHOP_ADDRESS
                )
                values ( seq_dwh_shops.nextval,
                         s0.SHOP_NAME,
                         s0.CITY_ID,
                         s0.SHOP_ADDRESS
                       )
                returning dwh_shop_id into v_dwh_shop_id;

                insert
                into   dwh_shops_id
                ( dwh_shop_id,
                  dwh_source_id,
                  ext_id
                )
                values ( v_dwh_shop_id,
                         c_source_id_primary,
                         to_char(s0.shop_id)
                       );

            end loop;
    end;

    procedure add_clients is

        v_dwh_client_id number(12);

    begin
        for c0 in ( select c.CLIENT_ID,
                           c.CLIENT_NAME,
                           c.CLIENT_RATE
                    from   clients c
                    where  to_char(c.CLIENT_ID) not in
                           ( select i.ext_id
                             from   dwh_clients_id i
                             where  i.dwh_source_id = c_source_id_primary
                           )
            )
            loop
                insert
                into   dwh_clients
                ( dwh_client_id,
                  DWH_CLIENT_NAME,
                  CLIENT_RATE
                )
                values ( seq_dwh_clients.nextval,
                         c0.CLIENT_NAME,
                         c0.CLIENT_RATE
                       )
                returning DWH_CLIENT_ID into v_dwh_client_id;

                insert
                into   dwh_clients_id
                ( DWH_CLIENT_ID,
                  dwh_source_id,
                  ext_id
                )
                values ( v_dwh_client_id,
                         c_source_id_primary,
                         to_char(c0.client_id)
                       );

            end loop;
    end;

    procedure add_cashiers is

        v_dwh_cashier_id number(12);

    begin
        for c0 in ( select c.CASHIER_ID,
                           c.CASHIER_NAME,
                           c.CASHIER_TAX
                    from   cashiers c
                    where  to_char(c.CASHIER_ID) not in
                           ( select i.ext_id
                             from   dwh_cashiers_id i
                             where  i.dwh_source_id = c_source_id_primary
                           )
            )
            loop
                insert
                into   dwh_cashiers
                ( dwh_cashier_id,
                  dwh_cashier_name,
                  DWH_CASHIER_TAX
                )
                values ( seq_dwh_cities.nextval,
                         c0.CASHIER_NAME,
                         c0.CASHIER_TAX
                       )
                returning dwh_cashier_id into v_dwh_cashier_id;

                insert
                into   DWH_CASHIERS_ID
                ( DWH_CASHIER_ID,
                  dwh_source_id,
                  ext_id
                )
                values ( v_dwh_cashier_id,
                         c_source_id_primary,
                         to_char(c0.cashier_id)
                       );

            end loop;
    end;

    procedure add_masters is

        v_dwh_master_id number(12);

    begin
        for c0 in ( select m.MASTER_ID,
                           m.MASTER_NAME,
                           m.MASTER_TAX
                    from   masters m
                    where  to_char(m.MASTER_ID) not in
                           ( select i.ext_id
                             from   dwh_masters_id i
                             where  i.dwh_source_id = c_source_id_primary
                           )
            )
            loop
                insert
                into   dwh_masters
                ( dwh_master_id,
                  dwh_master_name,
                  DWH_master_TAX
                )
                values ( seq_dwh_cities.nextval,
                         c0.master_name,
                         c0.MASTER_TAX
                       )
                returning dwh_master_id into v_dwh_master_id;

                insert
                into   DWH_MASTERS_ID
                ( DWH_MASTER_ID,
                  dwh_source_id,
                  ext_id
                )
                values ( v_dwh_master_id,
                         c_source_id_primary,
                         to_char(c0.master_id)
                       );

            end loop;
    end;


    procedure add_details is

        v_dwh_details_id number(12);

    begin
        for c0 in ( select d_sup_items.detail_id,
                           d_sup.PROVIDER_ID,
                           d_sup.CASHIER_ID,
                           d_sup.SHOP_ID,
                           d_classes.DETAIL_CLASS_NAME
                    from   DETAILS_SUPPLY_ITEMS d_sup_items,
                           DETAILS_SUPPLY d_sup,
                           DETAIL_CLASSES d_classes
                    where  to_char(d_sup_items.DETAIL_ID) not in
                           ( select i.ext_id
                             from   dwh_details_id i
                             where  i.dwh_source_id = c_source_id_primary
                           )
                      and  d_sup_items.SUPPLY_ID = d_sup.SUPPLY_ID
                      and  d_sup_items.DETAIL_CLASS_ID = d_classes.DETAIL_CLASS_ID


            )
            loop
                insert
                into   dwh_details
                ( dwh_detail_id,
                  dwh_detail_class_name,
                  dwh_provider_id,
                  DWH_CASHIER_ID,
                  DWH_SHOP_ID
                )
                values ( seq_dwh_details.nextval,
                         c0.DETAIL_CLASS_NAME,
                         (select d.DWH_PROVIDER_ID
                             from DWH_PROVIDERS_ID d
                             where d.DWH_SOURCE_ID = c_source_id_primary
                                and d.EXT_ID = to_char(c0.PROVIDER_ID)),
                         (select d.DWH_CASHIER_ID
                             from DWH_CASHIERS_ID d
                             where d.DWH_SOURCE_ID = c_source_id_primary
                                and d.EXT_ID = to_char(c0.CASHIER_ID)),
                         (select d.DWH_SHOP_ID
                          from DWH_SHOPS_ID d
                          where d.DWH_SOURCE_ID = c_source_id_primary
                            and d.EXT_ID = to_char(c0.SHOP_ID))

                       )
                returning DWH_DETAIL_ID into v_dwh_details_id;

                insert
                into   dwh_details_id
                ( dwh_detail_id,
                  dwh_source_id,
                  ext_id
                )
                values ( v_dwh_details_id,
                         c_source_id_primary,
                         to_char(c0.detail_id)
                       );

            end loop;
    end;


    procedure add_diagnoses is

        v_dwh_diagnosis_id number(12);

    begin
        for c0 in ( select d.DIAGNOSIS_ID,
                           d.DIAGNOSIS_NAME,
                           d.DIAGNOSIS_DESCRIPTION,
                           d.ESTIMATED_PRICE,
                           d.ESTIMATED_EXEC_TERM
                    from   DIAGNOSES d
                    where  to_char(d.DIAGNOSIS_ID) not in
                           ( select i.ext_id
                             from   dwh_diagnoses_id i
                             where  i.dwh_source_id = c_source_id_primary
                           )
            )
            loop
                insert
                into   DWH_DIAGNOSES
                ( dwh_diagnosis_id,
                  DWH_DIAGNOSIS_NAME,
                  DWH_DIAGNOSIS_DESCRIPTION,
                  ESTIMATED_PRICE,
                  ESTIMATED_EXEC_TERM
                )
                values ( seq_dwh_diagnoses.nextval,
                         c0.DIAGNOSIS_NAME,
                         c0.DIAGNOSIS_DESCRIPTION,
                         c0.ESTIMATED_PRICE,
                         c0.ESTIMATED_EXEC_TERM
                       )
                returning dwh_diagnosis_id into v_dwh_diagnosis_id;

                insert
                into   DWH_DIAGNOSES_ID
                ( DWH_DIAGNOSIS_ID,
                  dwh_source_id,
                  ext_id
                )
                values ( v_dwh_diagnosis_id,
                         c_source_id_primary,
                         to_char(c0.DIAGNOSIS_ID)
                       );

            end loop;
    end;




    procedure load_data (
        v_date in date
    ) is

    begin
        execute immediate 'truncate table LOAD_PRIMARY_INVOICES';

        insert into LOAD_PRIMARY_INVOICES (
            INVOICE_DATE,
            DEVICE_MODEL,
            DEVICE_STATE,
            ON_GUARANTEE,
            DEVICE_PHOTO_DIR,
            ESTIMATED_PRICE,
            ESTIMATED_EXEC_TERM,
            IS_CANCELED,
            FINISH_DATE,
            IS_PAID,
            TAKE_DATE,
            TOTAL_PRICE,

            SOURCE_ID,
            SOURCE_ROW_ID,

            DIAGNOSIS_ID,
            DETAIL_ID,
            DETAIL_PROVIDER_ID,
            SHOP_ID,
            CASHIER_ID,
            CLIENT_ID,
            MASTER_ID,

            DETAILS_AMOUNT,
            DETAIL_INPUT_PRICE,

            DWH_DIAGNOSIS_ID,
            DWH_DETAIL_ID,
            DWH_DETAIL_PROVIDER_ID,
            DWH_SHOP_ID,
            DWH_CASHIER_ID,
            DWH_CLIENT_ID,
            DWH_MASTER_ID
        ) select
                invoices.INVOICE_DATE,
                invoices.DEVICE_MODEL,
                invoices.DEVICE_STATE,
                invoices.ON_GUARANTEE,
                invoices.DEVICE_PHOTO_DIR,
                diag.ESTIMATED_PRICE,
                diag.ESTIMATED_EXEC_TERM,
                invoices.IS_CANCELED,
                invoices.FINISH_DATE,
                invoices.IS_PAID,
                invoices.TAKE_DATE,
                invoices.TOTAL_PRICE,

                c_source_id_primary,
                invoices.REPAIR_ID || '_' || d_used.DETAIL_ID,

                invoices.DIAGNOSIS_ID,
                d_used.DETAIL_ID,
                d_sup.PROVIDER_ID,
                invoices.SHOP_ID,
                invoices.CASHIER_ID,
                invoices.CLIENT_ID,
                invoices.MASTER_ID,

                d_used.DETAILS_AMOUNT,
                d_sup_items.DETAIL_INPUT_PRICE,

                null,
                null,
                null,
                null,
                null,
                null,
                null
            from
                REPAIR_INVOICES invoices,
                DETAILS_USED d_used,
                DETAILS_SUPPLY d_sup,
                DETAILS_SUPPLY_ITEMS d_sup_items,
                DETAIL_CLASSES d_classes,
                DIAGNOSES diag

            where
                invoices.REPAIR_ID = d_used.REPAIR_ID
            and
                d_used.DETAIL_ID = d_sup_items.DETAIL_ID
            and
                d_sup_items.SUPPLY_ID = d_sup.SUPPLY_ID
            and
                invoices.DIAGNOSIS_ID = diag.DIAGNOSIS_ID
            and
                invoices.INVOICE_DATE >= v_date
            and
                invoices.INVOICE_DATE < v_date + 1;

        add_cashiers();
        add_cities();
        add_clients();
        add_details();
        add_masters();
        add_shops();
        add_diagnoses();

        update LOAD_PRIMARY_INVOICES s

        set s.DWH_DIAGNOSIS_ID = (
            select i.DWH_DIAGNOSIS_ID
            from DWH_DIAGNOSES_ID i
            where i.DWH_SOURCE_ID = c_source_id_primary
              and i.EXT_ID = to_char(s.DIAGNOSIS_ID)
        ),
            s.DWH_DETAIL_ID = (
                select i.DWH_DETAIL_ID
                from DWH_DETAILS_ID i
                where i.DWH_SOURCE_ID = c_source_id_primary
                  and i.EXT_ID = to_char(s.DETAIL_ID)
        ),
            s.DWH_MASTER_ID = (
                select i.DWH_MASTER_ID
                from DWH_MASTERS_ID i
                where i.DWH_SOURCE_ID = c_source_id_primary
                  and i.EXT_ID = to_char(s.MASTER_ID)
        ),
            s.DWH_DETAIL_PROVIDER_ID = (
                select i.DWH_PROVIDER_ID
                from DWH_PROVIDERS_ID i
                where i.DWH_SOURCE_ID = c_source_id_primary
                  and i.EXT_ID = to_char(s.DETAIL_PROVIDER_ID)
        ),
            s.DWH_SHOP_ID = (
                select i.DWH_SHOP_ID
                from DWH_SHOPS_ID i
                where i.DWH_SOURCE_ID = c_source_id_primary
                  and i.EXT_ID = to_char(s.SHOP_ID)
        ),
            s.DWH_CLIENT_ID = (
                select i.DWH_CLIENT_ID
                from DWH_CLIENTS_ID i
                where i.DWH_SOURCE_ID = c_source_id_primary
                  and i.EXT_ID = to_char(s.CLIENT_ID)
        ),
            s.DWH_DETAIL_ID = (
                select i.DWH_CASHIER_ID
                from DWH_CASHIERS_ID i
                where i.DWH_SOURCE_ID = c_source_id_primary
                  and i.EXT_ID = to_char(s.CASHIER_ID)
        );

        delete DWH_REPAIR_INVOICES s
        where  s.INVOICE_DATE >= v_date
          and    s.INVOICE_DATE < v_date + 1
          and    s.source_id = c_source_id_primary
          and    s.source_row_id not in
                 ( select l.source_row_id
                   from   LOAD_PRIMARY_INVOICES l
                 );
        merge into DWH_REPAIR_INVOICES d
        using (select l.*
               from LOAD_PRIMARY_INVOICES l
            ) s
        on (
            d.SOURCE_ID = c_source_id_primary and
            d.SOURCE_ROW_ID = s.SOURCE_ROW_ID
        )
        when matched then
        update set
            d.INVOICE_DATE           = s.INVOICE_DATE,
            d.DEVICE_MODEL           = s.DEVICE_MODEL,
            d.DEVICE_STATE           = s.DEVICE_STATE,
            d.ON_GUARANTEE           = s.ON_GUARANTEE,
            d.DEVICE_PHOTO_DIR       = s.DEVICE_PHOTO_DIR,
            d.DWH_DIAGNOSIS_ID       = s.DWH_DIAGNOSIS_ID,
            d.ESTIMATED_PRICE        = s.ESTIMATED_PRICE,
            d.ESTIMATED_EXEC_TERM    = s.ESTIMATED_EXEC_TERM,
            d.IS_CANCELED            = s.IS_CANCELED,
            d.FINISH_DATE            = s.FINISH_DATE,
            d.IS_PAID                = s.IS_PAID,
            d.TAKE_DATE              = s.TAKE_DATE,
            d.TOTAL_PRICE            = s.TOTAL_PRICE,
            d.DWH_DETAIL_ID          = s.DWH_DETAIL_ID,
            d.DWH_DETAIL_CLASS_NAME  = (select tmp.DWH_DETAIL_CLASS_NAME
                                        from DWH_DETAILS tmp
                                        where tmp.DWH_DETAIL_ID = s.DWH_DETAIL_ID),
            d.DETAILS_AMOUNT         = s.DETAILS_AMOUNT,
            d.DETAIL_INPUT_PRICE     = s.DETAIL_INPUT_PRICE,
            d.DWH_DETAIL_PROVIDER_ID = s.DWH_DETAIL_PROVIDER_ID,
            d.DWH_SHOP_ID            = s.DWH_SHOP_ID,
            d.DWH_CASHIER_ID         = s.DWH_CASHIER_ID,
            d.DWH_CLIENT_ID          = s.DWH_CLIENT_ID,
            d.DWH_MASTER_ID          = s.DWH_MASTER_ID
        when not matched then
        insert (
            DWH_REPAIR_ID,
            SOURCE_ID ,
            SOURCE_ROW_ID,
            INVOICE_DATE,
            DEVICE_MODEL,
            DEVICE_STATE,
            ON_GUARANTEE,
            DEVICE_PHOTO_DIR,
            DWH_DIAGNOSIS_ID ,
            ESTIMATED_PRICE ,
            ESTIMATED_EXEC_TERM ,
            IS_CANCELED ,
            FINISH_DATE,
            IS_PAID ,
            TAKE_DATE,
            TOTAL_PRICE,
            DWH_DETAIL_ID ,
            DWH_DETAIL_CLASS_NAME,
            DETAILS_AMOUNT ,
            DETAIL_INPUT_PRICE,
            DWH_DETAIL_PROVIDER_ID,
            DWH_SHOP_ID ,
            DWH_CASHIER_ID,
            DWH_CLIENT_ID ,
            DWH_MASTER_ID
        ) values (
            seq_dwh_invoices.nextval,
            s.SOURCE_ID,
            s.SOURCE_ROW_ID,
            s.INVOICE_DATE,
            s.DEVICE_MODEL,
            s.DEVICE_STATE,
            s.ON_GUARANTEE,
            s.DEVICE_PHOTO_DIR,
            s.DWH_DIAGNOSIS_ID,
            s.ESTIMATED_PRICE,
            s.ESTIMATED_EXEC_TERM,
            s.IS_CANCELED,
            s.FINISH_DATE,
            s.IS_PAID,
            s.TAKE_DATE,
            s.TOTAL_PRICE,
            s.DWH_DETAIL_ID,
            (select tmp.DWH_DETAIL_CLASS_NAME
             from DWH_DETAILS tmp
             where tmp.DWH_DETAIL_ID = s.DWH_DETAIL_ID),
            s.DETAILS_AMOUNT,
            s.DETAIL_INPUT_PRICE,
            s.DETAIL_PROVIDER_ID,
            s.DWH_SHOP_ID,
            s.DWH_CASHIER_ID,
            s.DWH_CLIENT_ID,
            s.DWH_MASTER_ID
        );

    end;


end pkg_dwh_dictionary;