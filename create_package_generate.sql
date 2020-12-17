-- Excusa. Quod scripsi, scripsi
-- by David Zashkolnyi
-- 15.12.2020

create sequence seq_cashiers;
create sequence seq_cities;
create sequence seq_clients;
create sequence seq_detail_classes;
create sequence seq_details_supply;
create sequence seq_details;
create sequence seq_diagnoses;
create sequence seq_goods_supply;
create sequence seq_goods_supply_items;
create sequence seq_item_classes;
create sequence seq_masters;
create sequence seq_providers;
create sequence seq_repair_invoices;
create sequence seq_sells;
create sequence seq_service_classes;
create sequence seq_service_sells;
create sequence seq_shops;



create or replace package pkg_generate_data is

    type number_table is table of number         index by binary_integer;
    type string_table is table of varchar2(4000) index by binary_integer;
    type date_table   is table of date           index by binary_integer;

    -- =============================== AUXILIARY FUNCTIONS ========================================

    function get_random_date
        return date;

    function get_random_el (
        arr in number_table
    )
        return number;

    function get_random_bool
        return number;

    -- ================================== DICTIONARIES ============================================

    procedure add_cashiers (
        rows_amount in number
    );

    procedure add_cities(
        rows_amount in number
    );

    procedure add_clients(
        rows_amount in number
    );

    procedure add_detail_classes(
        rows_amount in number
    );

    procedure add_diagnoses(
        rows_amount in number
    );

    procedure add_item_classes(
        rows_amount in number
    );

    procedure add_masters(
        rows_amount in number
    );

    procedure add_providers(
        rows_amount in number
    );

    procedure add_service_classes(
        rows_amount in number
    );

    procedure add_shops(
        rows_amount in number
    );


    -- ===================================== GET ID's from dicts ===================================

    function get_cities_id
        return number_table;

    function get_cashiers_id
        return number_table;

    function get_clients_id
        return number_table;

    function get_detail_classes_id
        return number_table;

    function get_diagnoses_id
        return number_table;

    function get_item_classes_id
        return number_table;

    function get_masters_id
        return number_table;

    function get_providers_id
        return number_table;

    function get_service_classes_id
        return number_table;

    function get_shops_id
        return number_table;

    function get_details_supplies_id
        return number_table;

    function get_details_id
        return number_table;

    function get_items_id
        return number_table;

    function get_sells_id
        return number_table;

    function get_repair_invoices_id
        return number_table;
    -- ======================================= SUPPLIES ======================================

    procedure add_details_supplies (
        rows_amount number
    );

    procedure add_details_supply_items (
        rows_amount number
    );

    procedure add_goods_supplies (
        rows_amount number
    );

    procedure add_goods_supply_items (
        rows_amount number
    );

    procedure add_goods_storage (
        rows_amount number
    );

    procedure add_services_prices (
        rows_amount number
    );

    -- ======================================= SELLS =============================================

    procedure add_sells (
        rows_amount number
    );

    procedure add_services_sells(
        rows_amount number
    );

    procedure add_goods_sells_items(
        rows_amount number
    );

    procedure add_repair_invoices(
        rows_amount number
    );

    procedure add_details_used(
        rows_amount number
    );

end pkg_generate_data;

/
-- ####################################################################################################
create or replace package body pkg_generate_data is

    start_date constant date := date '2001-01-01';

    function get_random_date
        return date is

        seconds_between number := (sysdate - start_date) * 86400;
        seconds_to_add number;
    begin
        seconds_to_add := round(DBMS_RANDOM.VALUE() * (seconds_between-1)) + 1;
        return start_date + seconds_to_add / 86400;
    end;

    function get_random_el (
        arr in number_table
    )
        return number is

        v_index number;
    begin
        v_index := round( dbms_random.value * (arr.count-1) )+1 ;
        return arr(v_index);

    end;

    function get_random_bool
        return number is

        v_rand_int number;
        v_res number;
    begin
        v_rand_int := DBMS_RANDOM.VALUE();
        if (v_rand_int >= 0.5) then
            v_res := 1;
        else
            v_res := 0;
        end if;

        return v_res;
    end;

    -- ================== GET ID's from dicts =====================
    function get_cities_id
        return number_table is

        arr_res_ids number_table;
    begin
        select c.CITY_ID
            bulk collect
        into arr_res_ids
        from CITIES c;

        return arr_res_ids;
    end;

    function get_cashiers_id
        return number_table is

        arr_res_ids number_table;
    begin
        select c.CASHIER_ID
            bulk collect
        into arr_res_ids
        from CASHIERS c;

        return arr_res_ids;
    end;

    function get_clients_id
        return number_table is

        arr_res_ids number_table;
    begin
        select c.CLIENT_ID
            bulk collect
        into arr_res_ids
        from CLIENTS c;

        return arr_res_ids;
    end;

    function get_detail_classes_id
        return number_table is

        arr_res_ids number_table;
    begin
        select d.DETAIL_CLASS_ID
            bulk collect
        into arr_res_ids
        from DETAIL_CLASSES d;

        return arr_res_ids;
    end;

    function get_diagnoses_id
        return number_table is

        arr_res_ids number_table;
    begin
        select d.DIAGNOSIS_ID
            bulk collect
        into arr_res_ids
        from DIAGNOSES d;

        return arr_res_ids;
    end;

    function get_item_classes_id
        return number_table is

        arr_res_ids number_table;
    begin
        select i.ITEM_CLASS_ID
            bulk collect
        into arr_res_ids
        from ITEM_CLASSES i;

        return arr_res_ids;
    end;

    function get_masters_id
        return number_table is

        arr_res_ids number_table;
    begin
        select m.MASTER_ID
            bulk collect
        into arr_res_ids
        from MASTERS m;

        return arr_res_ids;
    end;

    function get_providers_id
        return number_table is

        arr_res_ids number_table;
    begin
        select p.PROVIDER_ID
            bulk collect
        into arr_res_ids
        from PROVIDERS p;

        return arr_res_ids;
    end;

    function get_service_classes_id
        return number_table is

        arr_res_ids number_table;
    begin
        select s.SERVICE_CLASS_ID
            bulk collect
        into arr_res_ids
        from SERVICE_CLASSES s;

        return arr_res_ids;
    end;

    function get_shops_id
        return number_table is

        arr_res_ids number_table;
    begin
        select s.SHOP_ID
            bulk collect
        into arr_res_ids
        from SHOPS s;

        return arr_res_ids;
    end;

    function get_details_supplies_id
        return number_table is

        arr_res_ids number_table;
    begin
        select d.SUPPLY_ID
            bulk collect
        into arr_res_ids
        from DETAILS_SUPPLY d;

        return arr_res_ids;
    end;

    function get_goods_supplies_id
        return number_table is

        arr_res_ids number_table;
    begin
        select g.SUPPLY_ID
            bulk collect
        into arr_res_ids
        from GOODS_SUPPLY g;

        return arr_res_ids;
    end;

    function get_details_id
        return number_table is

        arr_res_ids number_table;
    begin
        select d.DETAIL_ID
            bulk collect
        into arr_res_ids
        from DETAILS_SUPPLY_ITEMS d;

        return arr_res_ids;
    end;

    function get_items_id
        return number_table is

        arr_res_ids number_table;
    begin
        select g.ITEM_ID
            bulk collect
        into arr_res_ids
        from GOODS_SUPPLY_ITEMS g;

        return arr_res_ids;
    end;

    function get_sells_id
        return number_table is

        arr_res_ids number_table;
    begin
        select s.SELL_ID
            bulk collect
        into arr_res_ids
        from SELLS s;

        return arr_res_ids;
    end;

    function get_repair_invoices_id
        return number_table is

        arr_res_ids number_table;
    begin
        select r.REPAIR_ID
            bulk collect
        into arr_res_ids
        from REPAIR_INVOICES r;

        return arr_res_ids;
    end;
    -- ============================ DICTIONARIES ==============================
    procedure add_cashiers(
        rows_amount in number
    ) is
        arr_cashiers_id    number_table;
        arr_cashiers_names string_table;
        arr_cashiers_taxes number_table;

    begin
        for i in 1..rows_amount loop
            arr_cashiers_id(i)    := seq_cashiers.nextval;
            arr_cashiers_names(i) := 'Cashier_' || arr_cashiers_id(i);
            arr_cashiers_taxes(i) := DBMS_RANDOM.VALUE();
            end loop;

        forall i in 1..rows_amount
            insert into CASHIERS(
                CASHIER_ID,
                CASHIER_NAME,
                CASHIER_TAX
            ) values (
                arr_cashiers_id(i),
                arr_cashiers_names(i),
                arr_cashiers_taxes(i)
            );
    end;

    procedure add_cities(
        rows_amount in number
    ) is
        arr_cities_id    number_table;
        arr_cities_names string_table;

    begin
        for i in 1..rows_amount loop
                arr_cities_id(i)    := seq_cities.nextval;
                arr_cities_names(i) := 'City_' || arr_cities_id(i);
            end loop;

        forall i in 1..rows_amount
            insert into CITIES(
                CITY_ID,
                CITY_NAME
            ) values (
                arr_cities_id(i),
                arr_cities_names(i)
             );
    end;

    procedure add_clients(
        rows_amount in number
    ) is
        arr_clients_id     number_table;
        arr_clients_names  string_table;
        arr_clients_rates  number_table;
        arr_clients_phones string_table;
    begin
        for i in 1..rows_amount loop
                arr_clients_id(i)     := seq_clients.nextval;
                arr_clients_names(i)  := 'Client_' || arr_clients_id(i);
                arr_clients_rates(i)  := DBMS_RANDOM.VALUE();
                arr_clients_phones(i) := 'PhoneNumber_' || arr_clients_id(i);
            end loop;

        forall i in 1..rows_amount
            insert into CLIENTS(
                CLIENT_ID,
                CLIENT_NAME,
                CLIENT_RATE,
                CLIENT_PHONE
            ) values (
                arr_clients_id(i),
                arr_clients_names(i),
                arr_clients_rates(i),
                arr_clients_phones(i)
            );
    end;

    procedure add_detail_classes(
        rows_amount in number
    ) is
        arr_details_id     number_table;
        arr_details_names  string_table;
    begin
        for i in 1..rows_amount loop
                arr_details_id(i)    := seq_detail_classes.nextval;
                arr_details_names(i) := 'DetailClass_' || arr_details_id(i);

            end loop;

        forall i in 1..rows_amount
            insert into DETAIL_CLASSES(
                DETAIL_CLASS_ID,
                DETAIL_CLASS_NAME
            ) values (
                arr_details_id(i),
                arr_details_names(i)
            );
    end;


    procedure add_diagnoses(
        rows_amount in number
    ) is
        arr_diagnoses_id        number_table;
        arr_diagnoses_names     string_table;
        arr_diagnoses_descrs    string_table;
        arr_estimated_prices    number_table;
        arr_estimated_exec_tems number_table;
    begin
        for i in 1..rows_amount loop
                arr_diagnoses_id(i)     := seq_diagnoses.nextval;
                arr_diagnoses_names(i)  := 'Diagnosis_' || arr_diagnoses_id(i);
                arr_diagnoses_descrs(i) := 'Description for ' || arr_diagnoses_names(i);
                arr_estimated_prices(i) := round(DBMS_RANDOM.VALUE() * 1000);

                -- in days
                arr_estimated_exec_tems(i) := round(DBMS_RANDOM.VALUE(low => 1, high => 30) ) ;

            end loop;

        forall i in 1..rows_amount
            insert into DIAGNOSES(
                DIAGNOSIS_ID,
                DIAGNOSIS_NAME,
                DIAGNOSIS_DESCRIPTION,
                ESTIMATED_PRICE,
                ESTIMATED_EXEC_TERM
            ) values (
                arr_diagnoses_id(i),
                arr_diagnoses_names(i),
                arr_diagnoses_descrs(i),
                arr_estimated_prices(i),
                arr_estimated_exec_tems(i)
            );
    end;

    procedure add_item_classes(
        rows_amount in number
    ) is
        arr_item_classes_id     number_table;
        arr_item_classes_names  string_table;
        arr_item_classes_descrs string_table;
        arr_item_classes_photo_dirs string_table;
            
    begin
        for i in 1..rows_amount loop
                arr_item_classes_id(i)         := seq_item_classes.nextval;
                arr_item_classes_names(i)      := 'ItemClass_' || arr_item_classes_id(i);
                arr_item_classes_descrs(i)     := 'Description for ' || arr_item_classes_names(i);
                arr_item_classes_photo_dirs(i) := '/files/photo_' || arr_item_classes_id(i);
            end loop;

        forall i in 1..rows_amount
            insert into ITEM_CLASSES(
                ITEM_CLASS_ID,
                ITEM_CLASS_NAME,
                ITEM_CLASS_DESCRIPTION,
                ITEM_CLASS_PHOTO_DIR
            ) values (
                arr_item_classes_id(i),
                arr_item_classes_names(i),
                arr_item_classes_descrs(i),
                arr_item_classes_photo_dirs(i)
             );
    end;

    procedure add_masters(
        rows_amount in number
    ) is
        arr_masters_id     number_table;
        arr_masters_names  string_table;
        arr_masters_taxes  number_table;
    begin
        for i in 1..rows_amount loop
                arr_masters_id(i)    := seq_masters.nextval;
                arr_masters_names(i) := 'Master_' || arr_masters_id(i);
                arr_masters_taxes(i) := 0.3;
            end loop;

        forall i in 1..rows_amount
            insert into MASTERS(
                MASTER_ID,
                MASTER_NAME,
                MASTER_TAX
            ) values (
                arr_masters_id(i),
                arr_masters_names(i),
                arr_masters_taxes(i)
            );
    end;

    procedure add_providers(
        rows_amount in number
    ) is
        arr_providers_id     number_table;
        arr_providers_names  string_table;
    begin
        for i in 1..rows_amount loop
                arr_providers_id(i)    := seq_providers.nextval;
                arr_providers_names(i) := 'Provider_' || arr_providers_id(i);

            end loop;

        forall i in 1..rows_amount
            insert into PROVIDERS(
                PROVIDER_ID,
                PROVIDER_NAME
            ) values (
                arr_providers_id(i),
                arr_providers_names(i)
            );
    end;

    procedure add_service_classes(
        rows_amount in number
    ) is
        arr_service_classes_id     number_table;
        arr_service_classes_names  string_table;
        arr_service_classes_descrs string_table;
    begin
        for i in 1..rows_amount loop
                arr_service_classes_id(i)     := seq_service_classes.nextval;
                arr_service_classes_names(i)  := 'ServiceClass_' || arr_service_classes_id(i);
                arr_service_classes_descrs(i) := 'Description for ' || arr_service_classes_names(i);
            end loop;

        forall i in 1..rows_amount
            insert into SERVICE_CLASSES(
                SERVICE_CLASS_ID,
                SERVICE_CLASS_NAME,
                SERVICE_CLASS_DESCRIPTION
            ) values (
                arr_service_classes_id(i),
                arr_service_classes_names(i),
                arr_service_classes_descrs(i)
            );
    end;

    procedure add_shops(
        rows_amount in number
    ) is
        arr_all_cities_id number_table := get_cities_id();
        arr_shops_id number_table;
        arr_cities_id number_table;
        arr_shops_names string_table;
        arr_shops_addresses string_table;
        arr_shops_phones string_table;
    begin
        for i in 1..rows_amount loop
                arr_shops_id(i)        := seq_shops.nextval;
                arr_cities_id(i)       := get_random_el(arr => arr_all_cities_id);
                arr_shops_names(i)     := 'Shop_' || arr_shops_id(i);
                arr_shops_addresses(i) := 'Address for ' || arr_shops_names(i);
                arr_shops_phones(i)    := 'Phone for ' || arr_shops_names(i);
            end loop;

        forall i in 1..rows_amount
            insert into SHOPS(
                SHOP_ID,
                SHOP_NAME,
                SHOP_ADDRESS,
                CITY_ID,
                SHOP_PHONE
            ) values (
                arr_shops_id(i),
                arr_shops_names(i),
                arr_shops_addresses(i),
                arr_cities_id(i),
                arr_shops_phones(i)
            );
    end;


    -- ======================================= SUPPLIES ======================================

    procedure add_details_supplies (
        rows_amount number
    ) is
        arr_supplies_id number_table;
        arr_cashiers_id number_table;
        arr_providers_id number_table;
        arr_shops_id number_table;
        arr_supplies_dates date_table;

        arr_all_cashiers_id number_table  := get_cashiers_id();
        arr_all_providers_id number_table := get_providers_id();
        arr_all_shops_id number_table     := get_shops_id();
    begin
        for i in 1..rows_amount loop
            arr_supplies_id(i)    := seq_details_supply.nextval;
            arr_cashiers_id(i)    := get_random_el(arr => arr_all_cashiers_id);
            arr_providers_id(i)   := get_random_el(arr => arr_all_providers_id);
            arr_shops_id(i)       := get_random_el(arr => arr_all_shops_id);
            arr_supplies_dates(i) := trunc(get_random_date());
            end loop;

        forall i in 1..rows_amount
            insert into DETAILS_SUPPLY (
                SUPPLY_ID,
                SUPPLY_DATE,
                PROVIDER_ID,
                CASHIER_ID,
                SHOP_ID
            ) values (
                arr_supplies_id(i),
                arr_supplies_dates(i),
                arr_providers_id(i),
                arr_cashiers_id(i),
                arr_shops_id(i)
            );
    end;

    -- trigger TR_DETAILS_STORAGE after this
    procedure add_details_supply_items (
        rows_amount number
    ) is
        arr_details_id           number_table;
        arr_detail_classes_id    number_table;
        arr_details_input_amount number_table;
        arr_details_input_prices number_table;
        arr_supplies_id          number_table;

        arr_all_detail_classes_id number_table := get_detail_classes_id();
        arr_all_supplies_id number_table := get_details_supplies_id();

    begin
        for i in 1..rows_amount loop
            arr_details_id(i)           := seq_details.nextval;
            arr_detail_classes_id(i)    := get_random_el(arr => arr_all_detail_classes_id);
            arr_details_input_amount(i) := round(DBMS_RANDOM.VALUE(low => 1, high => 30));
            arr_details_input_prices(i) := DBMS_RANDOM.VALUE(low => 1, high => 100);
            arr_supplies_id(i)          := get_random_el(arr => arr_all_supplies_id);
            end loop;

        forall i in 1..rows_amount
            insert into DETAILS_SUPPLY_ITEMS (
                DETAIL_ID,
                SUPPLY_ID,
                DETAIL_CLASS_ID,
                DETAIL_INPUT_AMOUNT,
                DETAIL_INPUT_PRICE
            ) values (
                arr_details_id(i),
                arr_supplies_id(i),
                arr_detail_classes_id(i),
                arr_details_input_amount(i),
                arr_details_input_prices(i)
            );
    end;

    procedure add_goods_supplies (
        rows_amount number
    ) is
        arr_supplies_id    number_table;
        arr_cashiers_id    number_table;
        arr_providers_id   number_table;
        arr_shops_id       number_table;
        arr_supplies_dates date_table;

        arr_all_cashiers_id number_table  := get_cashiers_id();
        arr_all_providers_id number_table := get_providers_id();
        arr_all_shops_id number_table     := get_shops_id();
    begin
        for i in 1..rows_amount loop
                arr_supplies_id(i)    := seq_goods_supply.nextval;
                arr_cashiers_id(i)    := get_random_el(arr => arr_all_cashiers_id);
                arr_providers_id(i)   := get_random_el(arr => arr_all_providers_id);
                arr_shops_id(i)       := get_random_el(arr => arr_all_shops_id);
                arr_supplies_dates(i) := trunc(get_random_date());
            end loop;

        forall i in 1..rows_amount
            insert into GOODS_SUPPLY (
                SUPPLY_ID,
                SUPPLY_DATE,
                PROVIDER_ID,
                CASHIER_ID,
                SHOP_ID
            ) values (
                arr_supplies_id(i),
                arr_supplies_dates(i),
                arr_providers_id(i),
                arr_cashiers_id(i),
                arr_shops_id(i)
            );
    end;

    -- trigger TR_SELL_GOODS after this
    procedure add_goods_supply_items (
        rows_amount number
    ) is
        arr_items_id           number_table;
        arr_item_classes_id    number_table;
        arr_items_input_amount number_table;
        arr_items_input_prices number_table;
        arr_supplies_id        number_table;

        arr_all_item_classes_id number_table := get_item_classes_id();
        arr_all_supplies_id number_table := get_goods_supplies_id();

    begin
        for i in 1..rows_amount loop
                arr_items_id(i)           := seq_goods_supply_items.nextval;
                arr_item_classes_id(i)    := get_random_el(arr => arr_all_item_classes_id);
                arr_items_input_amount(i) := round(DBMS_RANDOM.VALUE(low => 1, high => 30));
                arr_items_input_prices(i) := DBMS_RANDOM.VALUE(low => 1, high => 100);
                arr_supplies_id(i)        := get_random_el(arr => arr_all_supplies_id);
            end loop;

        forall i in 1..rows_amount
            insert into GOODS_SUPPLY_ITEMS (
                ITEM_ID,
                SUPPLY_ID,
                ITEM_CLASS_ID,
                ITEMS_INPUT_AMOUNT,
                ITEM_INPUT_PRICE
            ) values (
                arr_items_id(i),
                arr_supplies_id(i),
                arr_item_classes_id(i),
                arr_items_input_amount(i),
                arr_items_input_prices(i)
            );
    end;

    procedure add_goods_storage (
        rows_amount number
    ) is
        arr_items_id     number_table;
        arr_start_dates    date_table;
        arr_items_amount number_table;
        arr_items_prices number_table;

        arr_all_items_id number_table := get_items_id();
    begin

        for i in 1..rows_amount loop
                    arr_items_id(i)     := get_random_el(arr => arr_all_items_id);
                    arr_start_dates(i)  := trunc(get_random_date());
                    arr_items_amount(i) := round(DBMS_RANDOM.VALUE(low => 1, high => 30));
                    arr_items_prices(i) := DBMS_RANDOM.VALUE(low => 1, high => 100);
            end loop;

        forall i in 1..rows_amount
            insert into GOODS_STORAGE(
                ITEM_ID,
                START_DATE,
                ITEMS_AMOUNT,
                PRICE
            ) values (
                arr_items_id(i),
                arr_start_dates(i),
                arr_items_amount(i),
                arr_items_prices(i)
            );
    end;

    procedure add_services_prices (
        rows_amount number
    ) is
        arr_service_classes_id number_table;
        arr_start_dates        date_table;
        arr_prices             number_table;

        arr_all_service_classes_id number_table := get_service_classes_id();
    begin
        for i in 1..rows_amount loop
            arr_service_classes_id(i) := get_random_el(arr => arr_all_service_classes_id);
            arr_start_dates(i)        := trunc(get_random_date());
            arr_prices(i)             := DBMS_RANDOM.VALUE(low => 1, high => 100);
            end loop;

        forall i in 1..rows_amount
            insert into SERVICES_PRICES (
                SERVICE_CLASS_ID,
                START_DATE,
                PRICE
            ) values (
                arr_service_classes_id(i),
                arr_start_dates(i),
                arr_prices(i)
            );
    end;

    -- ======================================= SELLS =============================================

    procedure add_sells (
        rows_amount number
    ) is
        arr_sells_id     number_table;
        arr_cashiers_id  number_table;
        arr_sell_dates   date_table;
        arr_shops_id     number_table;
        arr_total_prices number_table;

        arr_all_cashiers_id number_table := get_cashiers_id();
        arr_all_shops_id    number_table := get_shops_id();

    begin
        for i in 1..rows_amount loop
            arr_sells_id(i)     := seq_sells.nextval;
            arr_cashiers_id(i)  := get_random_el(arr => arr_all_cashiers_id);
            arr_sell_dates(i)   := trunc(get_random_date());
            arr_shops_id(i)     := get_random_el(arr => arr_all_shops_id);
            arr_total_prices(i) := 0;          -- update by trigger
            end loop;

        forall i in 1..rows_amount
            insert into SELLS (
                SELL_ID,
                SELL_DATE,
                CASHIER_ID,
                SHOP_ID,
                TOTAL_PRICE
            ) values (
                arr_sells_id(i),
                arr_sell_dates(i),
                arr_cashiers_id(i),
                arr_shops_id(i),
                arr_total_prices(i)
            );
    end;

    procedure add_services_sells(
        rows_amount number
    ) is
        arr_services_id        number_table;
        arr_sells_id           number_table;
        arr_service_classes_id number_table;
        arr_service_prices     number_table;

        arr_all_sells_id number_table        := get_sells_id();
        arr_all_service_classes number_table := get_service_classes_id();
    begin
        for i in 1..rows_amount loop
            arr_services_id(i)        := seq_service_sells.nextval;
            arr_sells_id(i)           := get_random_el(arr => arr_all_sells_id);
            arr_service_classes_id(i) := get_random_el(arr => arr_all_service_classes);
            arr_service_prices(i)     := DBMS_RANDOM.VALUE(low => 1, high => 100);
            end loop;

        forall i in 1..rows_amount
            insert into SERVICES_SELLS (
                SERVICE_ID,
                SELL_ID,
                SERVICE_CLASS_ID,
                SERVICE_PRICE
            ) values (
                arr_services_id(i),
                arr_sells_id(i),
                arr_service_classes_id(i),
                arr_service_prices(i)
            );
    end;

    procedure add_goods_sells_items(
        rows_amount number
    ) is
        arr_items_id         number_table;
        arr_sells_id         number_table;
        arr_item_classes_id  number_table;
        arr_item_prices      number_table;
        arr_item_amounts     number_table;

        arr_all_items_id number_table     := get_items_id();
        arr_all_sells_id number_table     := get_sells_id();
        arr_all_item_classes number_table := get_item_classes_id();
    begin
        for i in 1..rows_amount loop
                arr_items_id(i)         := get_random_el(arr => arr_all_items_id);
                arr_sells_id(i)         := get_random_el(arr => arr_all_sells_id);
                arr_item_classes_id(i)  := get_random_el(arr => arr_all_item_classes);
                arr_item_prices(i)      := DBMS_RANDOM.VALUE(low => 1, high => 100);
                arr_item_amounts(i)     := round(DBMS_RANDOM.VALUE(low => 1, high => 100));
            end loop;

        forall i in 1..rows_amount
            insert into GOODS_SELLS_ITEMS (
                ITEM_ID,
                SELL_ID,
                ITEM_CLASS_ID,
                ITEM_PRICE,
                ITEMS_AMOUNT
            ) values (
                arr_items_id(i),
                arr_sells_id(i),
                arr_item_classes_id(i),
                arr_item_prices(i),
                arr_item_amounts(i)
            );
    end;

    procedure add_repair_invoices(
        rows_amount number
    ) is
        arr_repairs_id    number_table;
        arr_cashiers_id   number_table;
        arr_clients_id    number_table;
        arr_devices_model string_table;
        arr_devices_photo string_table;
        arr_devices_state string_table;
        arr_diagnoses_id  number_table;
        arr_finish_dates  date_table;
        arr_invoice_dates date_table;
        arr_is_canceled   number_table;
        arr_is_paid       number_table;
        arr_masters_id    number_table;
        arr_on_guarantee  number_table;
        arr_shops_id      number_table;
        arr_take_dates    date_table;
        arr_total_costs   number_table;
        arr_total_price   number_table;

        arr_all_cashiers_id  number_table := get_cashiers_id();
        arr_all_clients_id   number_table := get_clients_id();
        arr_all_diagnoses_id number_table := get_diagnoses_id();
        arr_all_masters_id   number_table := get_masters_id();
        arr_all_shops_id     number_table := get_shops_id();
    begin
        for i in 1..rows_amount loop
                arr_repairs_id(i)    := seq_repair_invoices.nextval;
                arr_cashiers_id(i)   := get_random_el(arr => arr_all_cashiers_id);
                arr_clients_id(i)    := get_random_el(arr => arr_all_clients_id);
                arr_devices_model(i) := 'Device Model for RepairInvoice_' || arr_repairs_id(i);
                arr_devices_photo(i) := 'Device Photo for RepairInvoice_' || arr_repairs_id(i);
                arr_devices_state(i) := 'Device State for RepairInvoice_' || arr_repairs_id(i);
                arr_diagnoses_id(i)  := get_random_el(arr => arr_all_diagnoses_id);
                arr_finish_dates(i)  := trunc(get_random_date());
                arr_invoice_dates(i) := trunc(get_random_date());
                arr_is_canceled(i)   := get_random_bool();
                arr_is_paid(i)       := get_random_bool();
                arr_masters_id(i)    := get_random_el(arr => arr_all_masters_id);
                arr_on_guarantee(i)  := get_random_bool();
                arr_shops_id(i)      := get_random_el(arr => arr_all_shops_id);
                arr_take_dates(i)    := trunc(get_random_date());
                arr_total_costs(i)   := DBMS_RANDOM.VALUE(low => 1, high => 30);
                arr_total_price(i)   := DBMS_RANDOM.VALUE(low => 1, high => 20) + arr_total_costs(i);

            end loop;

        forall i in 1..rows_amount
            insert into REPAIR_INVOICES (
                REPAIR_ID,
                INVOICE_DATE,
                DEVICE_MODEL,
                DEVICE_STATE,
                ON_GUARANTEE,
                DEVICE_PHOTO_DIR,
                DIAGNOSIS_ID,
                IS_CANCELED,
                FINISH_DATE,
                IS_PAID,
                TAKE_DATE,
                TOTAL_PRICE,
                TOTAL_COSTS,
                SHOP_ID,
                CASHIER_ID,
                CLIENT_ID,
                MASTER_ID
            ) values (
                arr_repairs_id(i),
                arr_invoice_dates(i),
                arr_devices_model(i),
                arr_devices_state(i),
                arr_on_guarantee(i),
                arr_devices_photo(i),
                arr_diagnoses_id(i),
                arr_is_canceled(i),
                arr_finish_dates(i),
                arr_is_paid(i),
                arr_take_dates(i),
                arr_total_price(i),
                arr_total_costs(i),
                arr_shops_id(i),
                arr_cashiers_id(i),
                arr_clients_id(i),
                arr_masters_id(i)
            );
    end;

    procedure add_details_used(
        rows_amount number
    ) is
        arr_details_id     number_table;
        arr_details_amount number_table;
        arr_repair_id      number_table;

        arr_all_details_id number_table := get_details_id();
        arr_all_repair_id number_table  := get_repair_invoices_id();
    begin
        for i in 1..rows_amount loop
            arr_details_id(i) := get_random_el(arr => arr_all_details_id);
            arr_repair_id(i)  := get_random_el(arr => arr_all_repair_id);
            arr_details_amount(i) := round(DBMS_RANDOM.VALUE(low => 1, high => 30));
            end loop;

        forall i in 1..rows_amount
            insert into DETAILS_USED (
                DETAIL_ID,
                REPAIR_ID,
                DETAILS_AMOUNT
            ) values (
                arr_details_id(i),
                arr_repair_id(i),
                arr_details_amount(i)
            );

    end;

end pkg_generate_data;