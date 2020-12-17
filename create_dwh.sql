-- Excusa. Quod scripsi, scripsi
-- by David Zashkolnyi
-- 10.11.2020

CREATE TABLE DWH_REPAIR_INVOICES
(
    DWH_REPAIR_ID NUMBER(12) NOT NULL,
    SOURCE_ID NUMBER(12) NOT NULL,
    SOURCE_ROW_ID VARCHAR(128) NOT NULL,
    INVOICE_DATE DATE,
    DEVICE_MODEL VARCHAR(256),
    DEVICE_STATE VARCHAR(256),
    ON_GUARANTEE Number(2),
    DEVICE_PHOTO_DIR VARCHAR(1024),
    DWH_DIAGNOSIS_ID NUMBER(12),
    ESTIMATED_PRICE NUMBER(16, 2),
    ESTIMATED_EXEC_TERM NUMBER(12),
    IS_CANCELED NUMBER(2),
    FINISH_DATE DATE,
    IS_PAID Number(2),
    TAKE_DATE DATE,
    TOTAL_PRICE NUMBER(16, 2),
    DWH_DETAIL_ID NUMBER(12),
    DWH_DETAIL_CLASS_NAME NUMBER(12),
    DETAILS_AMOUNT NUMBER(12),
    DETAIL_INPUT_PRICE NUMBER(12),
    DWH_DETAIL_PROVIDER_ID NUMBER(12),
    DWH_SHOP_ID NUMBER(12),
    DWH_CASHIER_ID NUMBER(12),
    DWH_CLIENT_ID NUMBER(12),
    DWH_MASTER_ID NUMBER(12),
    CONSTRAINT dwh_repair_invoices_pk PRIMARY KEY(DWH_REPAIR_ID)
);


CREATE TABLE DWH_SOURCES
(
    SOURCE_ID NUMBER(12),
    SOURCE_NAME VARCHAR(128),
    CONSTRAINT dwh_sources_pk PRIMARY KEY (SOURCE_ID)
);

CREATE TABLE DWH_CASHIERS
(
    DWH_CASHIER_ID NUMBER(12) NOT NULL,
    DWH_CASHIER_NAME VARCHAR(256),
    DWH_CASHIER_TAX NUMBER(16, 2),
    CONSTRAINT dwh_cashiers_pk PRIMARY KEY(DWH_CASHIER_ID)
);

create table DWH_CASHIERS_ID (
    DWH_CASHIER_ID number(12),
    DWH_SOURCE_ID  number(12),
    EXT_ID         varchar(128),
    CONSTRAINT dwh_cahiers_id_pk PRIMARY KEY (DWH_CASHIER_ID, DWH_SOURCE_ID),
    foreign key (DWH_CASHIER_ID) references DWH_CASHIERS(DWH_CASHIER_ID),
    foreign key (DWH_SOURCE_ID) references DWH_SOURCES(SOURCE_ID)
);


CREATE TABLE DWH_MASTERS
(
    DWH_MASTER_ID NUMBER(12) NOT NULL,
    DWH_MASTER_NAME VARCHAR(256),
    DWH_MASTER_TAX NUMBER(16, 2),
    CONSTRAINT dwh_masters_pk PRIMARY KEY(DWH_MASTER_ID)
);

create table DWH_MASTERS_ID (
    DWH_MASTER_ID number(12),
    DWH_SOURCE_ID  number(12),
    EXT_ID        varchar(128),
    CONSTRAINT dwh_masters_id_pk PRIMARY KEY (DWH_MASTER_ID, DWH_SOURCE_ID),
    foreign key (DWH_MASTER_ID) references DWH_MASTERS(DWH_MASTER_ID),
    foreign key (DWH_SOURCE_ID) references DWH_SOURCES(SOURCE_ID)
);

CREATE TABLE DWH_CITIES
(
    DWH_CITY_ID NUMBER(12) NOT NULL,
    DWH_CITY_NAME NUMBER(16),
    CONSTRAINT dwh_cities_pk PRIMARY KEY(DWH_CITY_ID)
);

create table DWH_CITIES_ID (
    DWH_CITY_ID   number(12),
    DWH_SOURCE_ID number(12),
    EXT_ID      varchar(128),
    CONSTRAINT dwh_city_id_pk PRIMARY KEY (DWH_CITY_ID, DWH_SOURCE_ID),
    foreign key (DWH_CITY_ID) references DWH_CITIES(DWH_CITY_ID),
    foreign key (DWH_SOURCE_ID) references DWH_SOURCES(SOURCE_ID)
);

CREATE TABLE DWH_SHOPS
(
    DWH_SHOP_ID NUMBER(12) NOT NULL,
    DWH_SHOP_NAME VARCHAR(256) NOT NULL,
    DWH_SHOP_ADDRESS VARCHAR(256) NOT NULL,
    DWH_CITY_ID NUMBER(12) NOT NULL,
    CONSTRAINT dwh_shops_pk PRIMARY KEY(DWH_SHOP_ID),
    foreign key (DWH_CITY_ID) references DWH_CITIES(DWH_CITY_ID)
);

create table DWH_SHOPS_ID (
      DWH_SHOP_ID number(12),
      DWH_SOURCE_ID  number(12),
      EXT_ID         varchar(128),
      CONSTRAINT dwh_shops_id_pk PRIMARY KEY (DWH_SHOP_ID, DWH_SOURCE_ID),
      foreign key (DWH_SHOP_ID) references DWH_SHOPS(DWH_SHOP_ID),
      foreign key (DWH_SOURCE_ID) references DWH_SOURCES(SOURCE_ID)
);


create table DWH_PROVIDERS (
   DWH_PROVIDER_ID number(12),
   DWH_PROVIDER_NAME varchar(128),
   constraint dwh_providers_pk primary key (DWH_PROVIDER_ID)
);

create table DWH_PROVIDERS_ID (
    DWH_PROVIDER_ID number(12),
    DWH_SOURCE_ID number(12),
    EXT_ID varchar(128),
    constraint dwh_providers_id_pk primary key (DWH_PROVIDER_ID, DWH_SOURCE_ID),
    foreign key (DWH_PROVIDER_ID) references DWH_PROVIDERS(DWH_PROVIDER_ID),
    foreign key (DWH_SOURCE_ID) references DWH_SOURCES(SOURCE_ID)
);



create table DWH_DETAILS (
    DWH_DETAIL_ID NUMBER(12),
    DWH_DETAIL_CLASS_NAME Varchar(128),
    DWH_PROVIDER_ID NUMBER(12),
    DWH_CASHIER_ID NUMBER(12),
    DWH_SHOP_ID NUMBER(12),
    CONSTRAINT dwh_details_pk PRIMARY KEY (DWH_DETAIL_ID),
    foreign key (DWH_PROVIDER_ID) references DWH_PROVIDERS(DWH_PROVIDER_ID),
    foreign key (DWH_SHOP_ID) references DWH_SHOPS(DWH_SHOP_ID),
    foreign key (DWH_CASHIER_ID) references DWH_CASHIERS(DWH_CASHIER_ID)
);

create table DWH_DETAILS_ID (
    DWH_DETAIL_ID number(12),
    DWH_SOURCE_ID number(12),
    EXT_ID VARCHAR(128),
    CONSTRAINT dwh_details_id_pk PRIMARY KEY (DWH_DETAIL_ID, DWH_SOURCE_ID),
    foreign key (DWH_DETAIL_ID) references DWH_DETAILS(DWH_DETAIL_ID),
    foreign key (DWH_SOURCE_ID) references DWH_SOURCES(SOURCE_ID)
);


create table DWH_CLIENTS (
    DWH_CLIENT_ID number(12),
    DWH_CLIENT_NAME varchar(128),
    CLIENT_RATE number(16, 2),
    constraint dwh_clients_pk primary key (DWH_CLIENT_ID)
);

create table DWH_CLIENTS_ID (
    DWH_CLIENT_ID number(12),
    DWH_SOURCE_ID number(12),
    EXT_ID varchar(128),
    constraint dwh_clients_id_pk primary key (DWH_CLIENT_ID, DWH_SOURCE_ID),
    foreign key (DWH_SOURCE_ID) references DWH_SOURCES(SOURCE_ID),
    foreign key (DWH_CLIENT_ID) references DWH_CLIENTS(DWH_CLIENT_ID)
);


alter table DWH_REPAIR_INVOICES
    add foreign key (DWH_DETAIL_ID) references DWH_DETAILS(DWH_DETAIL_ID);

alter table DWH_REPAIR_INVOICES
    add foreign key (DWH_CASHIER_ID) references DWH_CASHIERS(DWH_CASHIER_ID);

alter table DWH_REPAIR_INVOICES
    add foreign key (DWH_SHOP_ID) references DWH_SHOPS(DWH_SHOP_ID);

alter table DWH_REPAIR_INVOICES
    add foreign key (DWH_CLIENT_ID) references DWH_CLIENTS(DWH_CLIENT_ID);