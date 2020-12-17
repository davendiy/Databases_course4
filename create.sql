-- Excusa. Quod scripsi, scripsi
-- by David Zashkolnyi
-- 10.11.2020

-- Drop for reuse

-- Create schemas

-- Create tables
CREATE TABLE CASHIERS
(
    CASHIER_ID NUMBER(12) NOT NULL,
    CASHIER_NAME VARCHAR(256),
    CASHIER_TAX NUMBER(16, 2),
    CONSTRAINT cashiers_pk PRIMARY KEY(CASHIER_ID)
);

comment on table CASHIERS is 'Dictionary of cashiers';
comment on column CASHIERS.CASHIER_NAME is 'Full name of cashier';
comment on column CASHIERS.CASHIER_TAX is 'Tax of cashier per operation';

CREATE TABLE PROVIDERS
(
    PROVIDER_ID NUMBER(12) NOT NULL,
    PROVIDER_NAME VARCHAR(256),
    CONSTRAINT providers_pk PRIMARY KEY(PROVIDER_ID)
);

comment on table PROVIDERS is 'Dictionary of providers';
comment on column PROVIDERS.PROVIDER_NAME is 'Full official name of provider';


CREATE TABLE ITEM_CLASSES
(
    ITEM_CLASS_ID NUMBER(12) NOT NULL,
    ITEM_CLASS_NAME VARCHAR(256) NOT NULL,
    ITEM_CLASS_DESCRIPTION VARCHAR(1024),
    ITEM_CLASS_PHOTO_DIR VARCHAR(1024),
    CONSTRAINT item_classes_pk PRIMARY KEY(ITEM_CLASS_ID)
);

comment on table ITEM_CLASSES is 'Dictionary of items classes (model, size, etc)';
comment on column ITEM_CLASSES.ITEM_CLASS_NAME is
    'Full name of item class (like Nokia 3310 black)';
comment on column ITEM_CLASSES.ITEM_CLASS_DESCRIPTION is
    'Full description of item class';
comment on column ITEM_CLASSES.ITEM_CLASS_PHOTO_DIR is 'Full address of photo';


CREATE TABLE SERVICE_CLASSES
(
    SERVICE_CLASS_ID NUMBER(12) NOT NULL,
    SERVICE_CLASS_NAME VARCHAR(256) NOT NULL,
    SERVICE_CLASS_DESCRIPTION VARCHAR(1024),
    CONSTRAINT service_classes_pk PRIMARY KEY(SERVICE_CLASS_ID)
);

comment on table SERVICE_CLASSES is
    'Dictionary of service classes';
comment on column SERVICE_CLASSES.SERVICE_CLASS_NAME is
    'Full name of service (like restore android)';
comment on column SERVICE_CLASSES.SERVICE_CLASS_DESCRIPTION is
    'Full description of service';


CREATE TABLE MASTERS
(
    MASTER_ID NUMBER(12) NOT NULL,
    MASTER_NAME VARCHAR(256),
    MASTER_TAX NUMBER(16, 2),
    CONSTRAINT masters_pk PRIMARY KEY(MASTER_ID)
);

comment on table MASTERS is 'Dictionary of masters';
comment on column MASTERS.MASTER_NAME is 'Full name of master';
comment on column MASTERS.MASTER_TAX is 'Tax of master per repair';


CREATE TABLE SHOPS
(
    SHOP_ID NUMBER(12) NOT NULL,
    SHOP_NAME VARCHAR(256) NOT NULL,
    SHOP_ADDRESS VARCHAR(256) NOT NULL,
    CITY_ID NUMBER(12) NOT NULL,
    SHOP_PHONE NUMBER(16),
    CONSTRAINT shops_pk PRIMARY KEY(SHOP_ID)
);

comment on table SHOPS is 'Dictionary of shops.';
comment on column SHOPS.SHOP_NAME is 'Full name of shop';
comment on column SHOPS.SHOP_ADDRESS is 'Full address of shop';
comment on column SHOPS.CITY_ID is 'Reference on city';
comment on column SHOPS.SHOP_PHONE is 'Phone of shop';


CREATE TABLE CITIES
(
    CITY_ID NUMBER(12) NOT NULL,
    CITY_NAME NUMBER(16),
    CONSTRAINT cities_pk PRIMARY KEY(CITY_ID)
);

comment on table CITIES is 'Dictionary of cities';
comment on column CITIES.CITY_NAME is 'Name of city';


CREATE TABLE GOODS_SUPPLY
(
    SUPPLY_ID NUMBER(12) NOT NULL,
    SUPPLY_DATE DATE NOT NULL,
    PROVIDER_ID NUMBER(12),
    CASHIER_ID NUMBER(12),
    SHOP_ID NUMBER(12),
    CONSTRAINT goods_supply_pk PRIMARY KEY(SUPPLY_ID)
);

comment on table GOODS_SUPPLY is
    'Supplies of sets of items';
comment on column GOODS_SUPPLY.SUPPLY_DATE is 'Date of supply';
comment on column GOODS_SUPPLY.PROVIDER_ID is 'Reference on provider';
comment on column GOODS_SUPPLY.CASHIER_ID is
    'Reference on cashier that accepted supply';
comment on column GOODS_SUPPLY.SHOP_ID is
    'Reference on shop where supply was accepted';


CREATE TABLE GOODS_SUPPLY_ITEMS
(
    ITEM_ID NUMBER(12) NOT NULL,
    SUPPLY_ID NUMBER(12) NOT NULL,
    ITEM_CLASS_ID NUMBER(12) NOT NULL,
    ITEMS_INPUT_AMOUNT NUMBER(16),
    ITEM_INPUT_PRICE NUMBER(16, 2),
    CONSTRAINT goods_supply_items_pk PRIMARY KEY(ITEM_ID)
);

comment on table GOODS_SUPPLY_ITEMS is 'Content of supplies';
comment on column GOODS_SUPPLY_ITEMS.SUPPLY_ID is
    'Reference on supply that contain such item';
comment on column GOODS_SUPPLY_ITEMS.ITEM_CLASS_ID is
    'Reference on item type';
comment on column GOODS_SUPPLY_ITEMS.ITEMS_INPUT_AMOUNT is
    'Input amount of items of such type';
comment on column GOODS_SUPPLY_ITEMS.ITEM_INPUT_PRICE is
    'Input price of one item of such type';


CREATE TABLE DETAIL_CLASSES
(
    DETAIL_CLASS_ID NUMBER(12) NOT NULL,
    DETAIL_CLASS_NAME VARCHAR(256),
    CONSTRAINT detail_classes_pk PRIMARY KEY(DETAIL_CLASS_ID)
);

comment on table DETAIL_CLASSES is 'Dictionary of details types';
comment on column DETAIL_CLASSES.DETAIL_CLASS_NAME is
    'Full name of detail type';


CREATE TABLE GOODS_STORAGE
(
    ITEM_ID NUMBER(12) NOT NULL,
    START_DATE DATE NOT NULL,
    ITEMS_AMOUNT NUMBER(16) NOT NULL,
    PRICE NUMBER(16, 2) NOT NULL,
    CONSTRAINT goods_storage_pk PRIMARY KEY(ITEM_ID, START_DATE)
);

comment on table GOODS_STORAGE is 'All items in storage';
comment on column GOODS_STORAGE.ITEM_ID is
    'A part of PK, reference to item type from supply';
comment on column GOODS_STORAGE.START_DATE is
    'A part of PK, date of beginning of such condition';
comment on column GOODS_STORAGE.ITEMS_AMOUNT is
    'Amount of such items';
comment on column GOODS_STORAGE.PRICE is
    'A price from START_DATE';

CREATE TABLE DETAILS_SUPPLY
(
    SUPPLY_ID NUMBER(12) NOT NULL,
    SUPPLY_DATE DATE,
    PROVIDER_ID NUMBER(12),
    CASHIER_ID NUMBER(12),
    SHOP_ID NUMBER(12),
    CONSTRAINT details_supply_pk PRIMARY KEY(SUPPLY_ID)
);

comment on table DETAILS_SUPPLY is 'Supplies of sets of details';
comment on column DETAILS_SUPPLY.SUPPLY_DATE is 'Date of supply';
comment on column DETAILS_SUPPLY.PROVIDER_ID is 'Reference to provider';
comment on column DETAILS_SUPPLY.CASHIER_ID is
    'Reference to cashier that accepted';
comment on column DETAILS_SUPPLY.SHOP_ID is
    'Reference to shop where the supply was accepted';

CREATE TABLE DETAILS_SUPPLY_ITEMS
(
    DETAIL_ID NUMBER(12) NOT NULL,
    SUPPLY_ID NUMBER(12),
    DETAIL_CLASS_ID NUMBER(12),
    DETAIL_INPUT_AMOUNT NUMBER(16),
    DETAIL_INPUT_PRICE NUMBER(16, 2),
    CONSTRAINT details_supply_items_pk PRIMARY KEY(DETAIL_ID)
);

comment on table DETAILS_SUPPLY_ITEMS is 'Content of supplies';
comment on column DETAILS_SUPPLY_ITEMS.SUPPLY_ID is
    'Reference to supply set that contain the detail';
comment on column DETAILS_SUPPLY_ITEMS.DETAIL_CLASS_ID is
    'Reference to detail type';
comment on column DETAILS_SUPPLY_ITEMS.DETAIL_INPUT_AMOUNT is
    'Amount of details in the supply';
comment on column DETAILS_SUPPLY_ITEMS.DETAIL_INPUT_PRICE is
    'Input price of detail';

CREATE TABLE DETAILS_STORAGE
(
    DETAIL_ID NUMBER(12) NOT NULL,
    START_DATE DATE NOT NULL,
    DETAILS_AMOUNT NUMBER(16),
    CONSTRAINT details_storage_pk PRIMARY KEY(DETAIL_ID, START_DATE)
);

comment on table DETAILS_STORAGE is 'All details in storage';
comment on column DETAILS_STORAGE.DETAIL_ID is
    'A part of PK that is reference to item from supply';
comment on column DETAILS_STORAGE.START_DATE is
    'A part of PK that is date of beginning of such condition';
comment on column DETAILS_STORAGE.DETAILS_AMOUNT is
    'Amount of detail from START_DATE';

CREATE TABLE SELLS
(
    SELL_ID NUMBER(12) NOT NULL,
    SELL_DATE DATE,
    CASHIER_ID NUMBER(12),
    SHOP_ID NUMBER(12),
    TOTAL_PRICE NUMBER(16, 2),
    CONSTRAINT sells_pk PRIMARY KEY(SELL_ID)
);

comment on table SELLS is 'Sell transactions';
comment on column SELLS.SELL_DATE is 'Date of transaction';
comment on column SELLS.CASHIER_ID is
    'Reference to cachier that accepted transaction';
comment on column SELLS.SHOP_ID is
    'Reference to shop where the transaction was';
comment on column SELLS.TOTAL_PRICE is 'Total price of transaction';


CREATE TABLE GOODS_SELLS_ITEMS
(
    ITEM_ID NUMBER(12) NOT NULL,
    SELL_ID NUMBER(12),
    ITEM_CLASS_ID NUMBER(12),
    ITEMS_AMOUNT NUMBER(16),
    ITEM_PRICE NUMBER(16, 2),
    CONSTRAINT goods_sells_items_pk PRIMARY KEY(ITEM_ID)
);

comment on table GOODS_SELLS_ITEMS is 'Items from transaction';
comment on column GOODS_SELLS_ITEMS.SELL_ID is
    'Reference to sell transaction';
comment on column GOODS_SELLS_ITEMS.ITEM_CLASS_ID is
    'Referense to item type';
comment on column GOODS_SELLS_ITEMS.ITEMS_AMOUNT is
    'Amount of items that were sold';
comment on column GOODS_SELLS_ITEMS.ITEM_PRICE is
    'Price per item';

CREATE TABLE CLIENTS
(
    CLIENT_ID NUMBER(12) NOT NULL,
    CLIENT_NAME VARCHAR(256),
    CLIENT_RATE NUMBER(16),
    CLIENT_PHONE VARCHAR(256),
    CONSTRAINT clients_pk PRIMARY KEY(CLIENT_ID)
);

comment on table CLIENTS is 'Dictionary of clients for repair agreement';
comment on column CLIENTS.CLIENT_NAME is 'Full name of client';
comment on column CLIENTS.CLIENT_RATE is 'Rate of the client due to his history';
comment on column CLIENTS.CLIENT_PHONE is 'Phone of client';

CREATE TABLE SERVICES_SELLS
(
    SERVICE_ID NUMBER(12) NOT NULL,
    SELL_ID NUMBER(12),
    SERVICE_CLASS_ID NUMBER(12),
    SERVICE_PRICE NUMBER(16, 2),
    CONSTRAINT services_sells_pk PRIMARY KEY(SERVICE_ID)
);

comment on table SERVICES_SELLS is 'All the services from transaction';
comment on column SERVICES_SELLS.SELL_ID is
    'Reference to the transaction';
comment on column SERVICES_SELLS.SERVICE_CLASS_ID is
    'Reference to the service type';
comment on column SERVICES_SELLS.SERVICE_PRICE is
    'Price';

CREATE TABLE SERVICES_PRICES
(
    SERVICE_CLASS_ID NUMBER(12) NOT NULL,
    START_DATE DATE NOT NULL,
    PRICE NUMBER(16, 2),
    CONSTRAINT services_prices_pk PRIMARY KEY(SERVICE_CLASS_ID, START_DATE)
);

comment on table SERVICES_PRICES is 'Prices on services';
comment on column SERVICES_PRICES.START_DATE is 'Date of beginning';
comment on column SERVICES_PRICES.PRICE is 'Price since START_DATE';

CREATE TABLE REPAIR_INVOICES
(
    REPAIR_ID NUMBER(12) NOT NULL,
    INVOICE_DATE DATE,
    DEVICE_MODEL VARCHAR(256),
    DEVICE_STATE VARCHAR(256),
    ON_GUARANTEE Number(2),
    DEVICE_PHOTO_DIR VARCHAR(1024),
    DIAGNOSIS_ID NUMBER(12),
    IS_CANCELED NUMBER(2),
    FINISH_DATE DATE,
    IS_PAID Number(2),
    TAKE_DATE DATE,
    TOTAL_PRICE NUMBER(16, 2),
    TOTAL_COSTS NUMBER(16, 2),
    SHOP_ID NUMBER(12),
    CASHIER_ID NUMBER(12),
    CLIENT_ID NUMBER(12),
    MASTER_ID NUMBER(12),
    CONSTRAINT repair_invoices_pk PRIMARY KEY(REPAIR_ID)
);

comment on table REPAIR_INVOICES is 'Agreements of repair';
comment on column REPAIR_INVOICES.INVOICE_DATE is 'Date of acception';
comment on column REPAIR_INVOICES.DEVICE_STATE is
    'A condition of device';

CREATE TABLE DIAGNOSES
(
    DIAGNOSIS_ID NUMBER(12) NOT NULL,
    DIAGNOSIS_NAME VARCHAR(256),
    DIAGNOSIS_DESCRIPTION VARCHAR(1024),
    ESTIMATED_PRICE NUMBER(16, 2),
    ESTIMATED_EXEC_TERM NUMBER(16),
    CONSTRAINT diagnoses_pk PRIMARY KEY(DIAGNOSIS_ID)
);

CREATE TABLE DETAILS_USED
(
    DETAIL_ID NUMBER(12) NOT NULL,
    REPAIR_ID NUMBER(12),
    DETAILS_AMOUNT NUMBER(16),
    CONSTRAINT details_used_pk PRIMARY KEY(DETAIL_ID, REPAIR_ID)
);


-- =============================================================================


-- Create FKs
ALTER TABLE SHOPS
    ADD    FOREIGN KEY (CITY_ID)
    REFERENCES CITIES(CITY_ID)
;

ALTER TABLE GOODS_SUPPLY
    ADD    FOREIGN KEY (SHOP_ID)
    REFERENCES SHOPS(SHOP_ID)
;

ALTER TABLE GOODS_SUPPLY
    ADD    FOREIGN KEY (CASHIER_ID)
    REFERENCES CASHIERS(CASHIER_ID)
;

ALTER TABLE GOODS_SUPPLY
    ADD    FOREIGN KEY (PROVIDER_ID)
    REFERENCES PROVIDERS(PROVIDER_ID)
;

ALTER TABLE GOODS_SUPPLY_ITEMS
    ADD    FOREIGN KEY (ITEM_CLASS_ID)
    REFERENCES ITEM_CLASSES(ITEM_CLASS_ID)
;

ALTER TABLE GOODS_SUPPLY_ITEMS
    ADD    FOREIGN KEY (SUPPLY_ID)
    REFERENCES GOODS_SUPPLY(SUPPLY_ID)
;

ALTER TABLE DETAILS_SUPPLY
    ADD    FOREIGN KEY (PROVIDER_ID)
    REFERENCES PROVIDERS(PROVIDER_ID)
;

ALTER TABLE DETAILS_SUPPLY
    ADD    FOREIGN KEY (CASHIER_ID)
    REFERENCES CASHIERS(CASHIER_ID)
;

ALTER TABLE DETAILS_SUPPLY
    ADD    FOREIGN KEY (SHOP_ID)
    REFERENCES SHOPS(SHOP_ID)
;

ALTER TABLE GOODS_STORAGE
    ADD    FOREIGN KEY (ITEM_ID)
    REFERENCES GOODS_SUPPLY_ITEMS(ITEM_ID)
;

ALTER TABLE DETAILS_SUPPLY_ITEMS
    ADD    FOREIGN KEY (SUPPLY_ID)
    REFERENCES DETAILS_SUPPLY(SUPPLY_ID)
;

ALTER TABLE DETAILS_SUPPLY_ITEMS
    ADD    FOREIGN KEY (DETAIL_CLASS_ID)
    REFERENCES DETAIL_CLASSES(DETAIL_CLASS_ID)
;

ALTER TABLE DETAILS_STORAGE
    ADD    FOREIGN KEY (DETAIL_ID)
    REFERENCES DETAILS_SUPPLY_ITEMS(DETAIL_ID)
;

ALTER TABLE SELLS
    ADD    FOREIGN KEY (CASHIER_ID)
    REFERENCES CASHIERS(CASHIER_ID)
;

ALTER TABLE SELLS
    ADD    FOREIGN KEY (SHOP_ID)
    REFERENCES SHOPS(SHOP_ID)
;

ALTER TABLE GOODS_SELLS_ITEMS
    ADD    FOREIGN KEY (SELL_ID)
    REFERENCES SELLS(SELL_ID)
;

ALTER TABLE GOODS_SELLS_ITEMS
    ADD    FOREIGN KEY (ITEM_CLASS_ID)
    REFERENCES ITEM_CLASSES(ITEM_CLASS_ID)
;

ALTER TABLE SERVICES_SELLS
    ADD    FOREIGN KEY (SELL_ID)
    REFERENCES SELLS(SELL_ID)
;

ALTER TABLE SERVICES_SELLS
    ADD    FOREIGN KEY (SERVICE_CLASS_ID)
    REFERENCES SERVICE_CLASSES(SERVICE_CLASS_ID)
;

ALTER TABLE SERVICES_PRICES
    ADD    FOREIGN KEY (SERVICE_CLASS_ID)
    REFERENCES SERVICE_CLASSES(SERVICE_CLASS_ID)
;

ALTER TABLE REPAIR_INVOICES
    ADD    FOREIGN KEY (SHOP_ID)
    REFERENCES SHOPS(SHOP_ID)
;

ALTER TABLE REPAIR_INVOICES
    ADD    FOREIGN KEY (CASHIER_ID)
    REFERENCES CASHIERS(CASHIER_ID)
;

ALTER TABLE REPAIR_INVOICES
    ADD    FOREIGN KEY (CLIENT_ID)
    REFERENCES CLIENTS(CLIENT_ID)
;

ALTER TABLE REPAIR_INVOICES
    ADD    FOREIGN KEY (MASTER_ID)
    REFERENCES MASTERS(MASTER_ID)
;

ALTER TABLE REPAIR_INVOICES
    ADD    FOREIGN KEY (DIAGNOSIS_ID)
    REFERENCES DIAGNOSES(DIAGNOSIS_ID)
;

ALTER TABLE DETAILS_USED
    ADD    FOREIGN KEY (REPAIR_ID)
    REFERENCES REPAIR_INVOICES(REPAIR_ID)
;

ALTER TABLE GOODS_SELLS_ITEMS
    ADD    FOREIGN KEY (ITEM_ID)
    REFERENCES GOODS_SUPPLY_ITEMS(ITEM_ID)
;

ALTER TABLE DETAILS_USED
    ADD    FOREIGN KEY (DETAIL_ID)
    REFERENCES DETAILS_SUPPLY_ITEMS(DETAIL_ID)
;


-- Create Indexes

-- Create Triggers

-- update total price of sell after adding the services which were provided
create or replace trigger TR_TOTAL_PRICE_SERVICES_UPDATE
    after insert or update or delete on SERVICES_SELLS
    for each row

    -- null can be on insert or delete
    when ( nvl(NEW.SERVICE_PRICE, 0) != nvl(OLD.SERVICE_PRICE, 0) )

    declare
        v_difference number := nvl(:NEW.SERVICE_PRICE, 0) - nvl(:OLD.SERVICE_PRICE, 0);
    begin
        update SELLS
        set
            SELLS.TOTAL_PRICE = SELLS.TOTAL_PRICE + v_difference
        where
            -- if NEW.SELL_ID is null then it was a delete
            SELLS.SELL_ID = nvl(:NEW.SELL_ID, :OLD.SELL_ID);
    end;


-- update total price of sell after adding the items which were sold
create or replace trigger TR_TOTAL_PRICE_GOODS_UPDATE
    after insert or update or delete on GOODS_SELLS_ITEMS
    for each row

    -- if price or amount was changed
    -- null can be after insert/delete
    when ( nvl(NEW.ITEM_PRICE, 0) != nvl(OLD.ITEM_PRICE, 0)
           or nvl(NEW.ITEMS_AMOUNT, 0) != nvl(OLD.ITEMS_AMOUNT, 0))

    declare
        v_nvl_new_price  number := nvl(:NEW.ITEMS_AMOUNT, 0);
        v_nvl_new_amount number := nvl(:NEW.ITEM_PRICE, 0);

        v_nvl_old_price  number := nvl(:OLD.ITEMS_AMOUNT, 0);
        v_nvl_old_amount number := nvl(:OLD.ITEM_PRICE, 0);

        v_difference number := v_nvl_new_amount * v_nvl_new_price
                                   - v_nvl_old_amount * v_nvl_old_price;
    begin
        update SELLS
        set
            SELLS.TOTAL_PRICE = SELLS.TOTAL_PRICE + v_difference
        where
            -- if NEW.SELL_ID is null then it was a delete
            SELLS.SELL_ID = nvl(:NEW.SELL_ID, :OLD.SELL_ID);
    end;


-- update storage of goods after each supply
create or replace trigger TR_GOODS_STORAGE
    after insert on GOODS_SUPPLY_ITEMS
    for each row

    declare

    begin
        insert into GOODS_STORAGE (
            GOODS_STORAGE.ITEM_ID,
            GOODS_STORAGE.START_DATE,
            GOODS_STORAGE.ITEMS_AMOUNT,
            GOODS_STORAGE.PRICE
        ) values (
            :NEW.ITEM_ID,
            sysdate,
            :NEW.ITEMS_INPUT_AMOUNT,
            :NEW.ITEM_INPUT_PRICE
        );

    end;

-- update storage of details after each supply
create or replace trigger TR_DETAILS_STORAGE
    after insert on DETAILS_SUPPLY_ITEMS
    for each row

    declare
    begin
        insert into DETAILS_STORAGE (
            DETAIL_ID,
            START_DATE,
            DETAILS_AMOUNT
        ) values (
            :NEW.DETAIL_ID,
            sysdate,
            :NEW.DETAIL_INPUT_AMOUNT
        );
    end;


-- check whether there are enough items for sale before the
-- confirmation of sell and update amount of items at the storage after
create or replace trigger TR_SELL_GOODS
    before insert on GOODS_SELLS_ITEMS
    for each row

    declare
        type number_table is table of number         index by binary_integer;

        v_price number := :NEW.ITEM_PRICE;
        v_item_id number := :NEW.ITEM_ID;
        v_required_amount number := :NEW.ITEMS_AMOUNT;

        arr_tmp number_table;

        v_available_amount number;
    begin


        select gs.ITEMS_AMOUNT
            bulk collect
        into arr_tmp
        from GOODS_STORAGE gs
        where gs.ITEM_ID = v_item_id
          and gs.START_DATE = (
            select max(gs.START_DATE)
            from GOODS_STORAGE gs
            where gs.ITEM_ID = v_item_id
        );

        if (arr_tmp.COUNT > 0) then
            v_available_amount := arr_tmp(1);
        else
            v_available_amount := 0;
        end if;

        if (v_required_amount > v_available_amount) then
            raise_application_error(-20101,'There is no ' || v_required_amount
                        || ' of product_' || v_item_id || ' on the storage.'
                        || 'There are only ' || v_available_amount || ' such items.');
        else
            insert into GOODS_STORAGE (
                ITEM_ID,
                START_DATE,
                ITEMS_AMOUNT,
                PRICE
            ) values (
                v_item_id,
                sysdate,
                v_available_amount - v_required_amount,
                v_price
            );
        end if;
    end;

