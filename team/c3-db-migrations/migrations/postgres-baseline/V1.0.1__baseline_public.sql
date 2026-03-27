-- =====================================================
-- C3 Database Baseline Migration - public schema
-- Generated from pristine database state
-- Image: migrations-pristine-496.1227.ACT-245.6449.dca2e99
-- Date: 2026-01-09
-- =====================================================
-- WARNING: This migration should NOT be executed on existing databases!
-- For existing databases, manually insert into flyway_schema_history
-- See: BASELINE_FLYWAY_INSERTS.sql
-- =====================================================

--
-- PostgreSQL database dump
--


-- Dumped from database version 15.15
-- Dumped by pg_dump version 15.15

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS public;

CREATE TYPE public.id_type AS ENUM (
    'dsp_id',
    'id5',
    'uid20'
);

SET default_tablespace = '';

SET default_table_access_method = heap;

-- Name: operating_system_dsp_mapping_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.operating_system_dsp_mapping_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  insert into dict_operating_system_dsp_mapping
  select
	an_os.id,
	mapping.dsp_source_id,
	mapping.operating_system_id
  from appnexus.operating_systems an_os join dict_os_family_dsp_mapping mapping
   on an_os.os_family_id = mapping.dsp_os_family_id and mapping.dsp_source_id = 1
  where an_os.id not in (select dsp_operating_system_id from dict_operating_system_dsp_mapping where dsp_source_id = 1);
  RETURN NULL;
END;
$$;


--
-- Name: line_item; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_item (
    id integer NOT NULL,
    insertion_order integer,
    advertiser integer,
    name character varying(100),
    code character varying(50),
    state character varying(20),
    li_type integer,
    gross_budget numeric(12,2),
    cpm numeric(12,4),
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    target_amount numeric(12,2),
    other_info character varying(255),
    create_update_dt timestamp without time zone DEFAULT now() NOT NULL,
    create_update_by character varying(100),
    target_type integer,
    post_view_window numeric(12,2),
    post_click_window numeric(12,2),
    version integer DEFAULT 1 NOT NULL,
    discount numeric(12,2),
    visible_to_agency boolean DEFAULT false NOT NULL,
    upweight numeric(12,2),
    adop integer,
    pricing_model integer,
    li_media_type integer,
    is_appnexus_dsp boolean DEFAULT false,
    is_dbm_dsp boolean DEFAULT false,
    dbm_io_id bigint,
    auto_optimise boolean DEFAULT false,
    rebate bigint,
    media_type_format integer,
    true_net_budget numeric(12,2),
    agency_report_name character varying(200),
    creation_dt timestamp without time zone DEFAULT now(),
    is_new boolean DEFAULT true NOT NULL,
    viewability_goals integer,
    video_type integer,
    margin_goal integer DEFAULT 55 NOT NULL,
    whitelist_id integer,
    appnexus_lineitem_type integer,
    secondary_target_amount numeric(12,2) DEFAULT NULL::numeric,
    secondary_target_type integer,
    performance_type integer,
    billing_type integer,
    rebooking integer,
    latency character varying,
    viewability_partner_id integer DEFAULT 1,
    format_provider_id integer DEFAULT 2 NOT NULL,
    create_update_by_id integer,
    archive boolean DEFAULT false,
    delivery_type integer,
    CONSTRAINT gross_budget_positive_check CHECK ((gross_budget >= (0)::numeric))
);



CREATE SEQUENCE public.sel_agency_id
    START WITH 10802
    INCREMENT BY 100
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

--
-- Name: sel_agency; Type: TABLE; Schema: public; Owner: -
--
-- not needed, drop, but check in repo
CREATE TABLE public.sel_agency (
    id integer DEFAULT nextval('public.sel_agency_id'::regclass) NOT NULL,
    group_id integer,
    name character varying(100) NOT NULL,
    tier integer DEFAULT 0,
    hidden boolean DEFAULT false,
    rebate numeric(12,2),
    financial_contact character varying(100),
    financial_email character varying(100),
    financial_phone character varying(100),
    vat_rate numeric(6,3),
    vat_number character varying(100),
    registration_number character varying(100),
    payment_type integer,
    line_1 character varying(100),
    line_2 character varying(100),
    postcode character varying(100),
    region character varying(100),
    city character varying(100),
    country character varying(100),
    billing_type_id integer,
    id_currency integer,
    discount_agency numeric(12,2),
    legal_entity integer NOT NULL,
    discount_pricing numeric(12,2) DEFAULT 0 NOT NULL
);

--
-- Name: insertion_order; Type: TABLE; Schema: public; Owner: -
--
-- todo, drop but check in repo
CREATE TABLE public.insertion_order (
    id integer NOT NULL,
    appnexus_id integer,
    advertiser integer,
    appnexus_advertiser integer,
    name character varying(100),
    code character varying(50),
    state character varying(20),
    client_io character varying(200),
    gross_budget numeric(12,2),
    discount numeric(12,2),
    other_info text,
    create_update_dt timestamp without time zone DEFAULT now() NOT NULL,
    create_update_by character varying(100),
    approved boolean DEFAULT false,
    upload_dt timestamp without time zone,
    version integer DEFAULT 1 NOT NULL,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    adop integer,
    revenue_type integer,
    visible_to_all_sales boolean DEFAULT false NOT NULL,
    legal_entity integer,
    flights_mode boolean DEFAULT false,
    is_complete boolean DEFAULT true NOT NULL,
    is_pixels_required boolean DEFAULT true NOT NULL,
    viewability_goals integer,
    clients_work text,
    clients_target_audience text,
    clients_plan text,
    is_monthly boolean,
    client_strategy integer,
    true_net_budget numeric(12,2),
    creation_dt timestamp without time zone DEFAULT now(),
    is_new boolean DEFAULT true NOT NULL,
    credit_notes_url text,
    credit_notes_name character varying,
    rebooking integer,
    agency_id integer DEFAULT 1002 NOT NULL,
    viewability_standard integer DEFAULT 1 NOT NULL,
    create_update_by_id integer,
    legal_entity_sub_office integer,
    currency integer,
    rebate bigint,
    sales_activation integer,
    sales_planning integer,
    agency_psi integer,
    delivery_type character varying(10),
    CONSTRAINT gross_budget_positive_check CHECK ((gross_budget >= (0)::numeric)),
    CONSTRAINT insertion_order_delivery_type_check CHECK (((delivery_type)::text = ANY ((ARRAY['standard'::character varying, 'cookieless'::character varying])::text[])))
);

--
-- Name: conversion_pixel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversion_pixel (
    id integer NOT NULL,
    pixel_name text NOT NULL,
    appnexus_name text,
    url text NOT NULL,
    is_revenue boolean DEFAULT false,
    is_order_id boolean DEFAULT false,
    is_pixel_hub boolean DEFAULT false,
    advertiser integer,
    appnexus_advertiser_id integer,
    version integer DEFAULT 0,
    appnexus_last_modified timestamp without time zone,
    appnexus_segment_id bigint,
    appnexus_segment_version integer DEFAULT 0,
    appnexus_segment_upload_dt timestamp without time zone,
    appnexus_conversion_id bigint,
    appnexus_conversion_version integer DEFAULT 0,
    appnexus_conversion_upload_dt timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    is_new boolean DEFAULT true NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    category_id integer,
    create_update_dt timestamp without time zone DEFAULT now() NOT NULL,
    created_by integer,
    post_view_interval_value integer,
    post_view_interval_units character varying(7),
    post_click_interval_value integer,
    post_click_interval_units character varying(7),
    piggyback_pixel_url text,
    piggyback_pixel_type character varying(3),
    CONSTRAINT conversion_pixel_piggyback_pixel_type_check CHECK (((piggyback_pixel_type)::text = ANY ((ARRAY['js'::character varying, 'img'::character varying])::text[]))),
    CONSTRAINT conversion_pixel_post_click_interval_units_check CHECK (((post_click_interval_units)::text = ANY ((ARRAY['minutes'::character varying, 'hours'::character varying, 'days'::character varying])::text[]))),
    CONSTRAINT conversion_pixel_post_view_interval_units_check CHECK (((post_view_interval_units)::text = ANY ((ARRAY['minutes'::character varying, 'hours'::character varying, 'days'::character varying])::text[])))
);


--
-- Name: conversion_pixel_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conversion_pixel_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversion_pixel_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conversion_pixel_id_seq OWNED BY public.conversion_pixel.id;


--
-- Name: dict_browser; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dict_browser (
    id smallint NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: COLUMN dict_browser.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dict_browser.id IS 'Captify identifier for the browser';


--
-- Name: dict_device_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dict_device_type (
    id smallint NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: dict_iso_countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dict_iso_countries (
    alpha2 character varying(2) NOT NULL,
    alpha3 character varying(3) NOT NULL,
    english_name text NOT NULL
);


--
-- Name: TABLE dict_iso_countries; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.dict_iso_countries IS 'ISO-3166 country codes with english name and alpha-3 codes';


--
-- Name: COLUMN dict_iso_countries.alpha2; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dict_iso_countries.alpha2 IS 'ISO-3166 alpha-2 country code';


--
-- Name: COLUMN dict_iso_countries.alpha3; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dict_iso_countries.alpha3 IS 'Corresponding ISO-3166 alpha-3 country code';


--
-- Name: COLUMN dict_iso_countries.english_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dict_iso_countries.english_name IS 'Name of the country in english';


--
-- Name: dict_operating_system; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dict_operating_system (
    id smallint NOT NULL,
    name character varying(50) NOT NULL
);


--
-- Name: COLUMN dict_operating_system.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dict_operating_system.id IS 'Captify identifier for the operating system';


--
-- Name: dict_property_pixel_category; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dict_property_pixel_category (
    id integer NOT NULL,
    name character varying(50),
    appnexus_id integer NOT NULL
);


--
-- Name: COLUMN dict_property_pixel_category.appnexus_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dict_property_pixel_category.appnexus_id IS 'Appnexus pixel conversion event id. See https://wiki.xandr.com/display/api/Conversion+Pixel+Service#ConversionPixelService-PixelConversionEvent';


--
-- Name: dict_property_pixel_category_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dict_property_pixel_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dict_property_pixel_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dict_property_pixel_category_id_seq OWNED BY public.dict_property_pixel_category.id;


--
-- Name: dict_region; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dict_region (
    id integer NOT NULL,
    code character varying(7) NOT NULL,
    name character varying(80) NOT NULL,
    country_id integer,
    appnexus_id integer NOT NULL,
    appnexus_code character varying(4),
    deleted boolean DEFAULT false NOT NULL
);


--
-- Name: dict_region_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dict_region_id_seq
    START WITH 10001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dict_region_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dict_region_id_seq OWNED BY public.dict_region.id;

--
-- Name: insertion_order_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.insertion_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: insertion_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.insertion_order_id_seq OWNED BY public.insertion_order.id;

--
-- Name: legal_entity_segment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.legal_entity_segment (
    id bigint NOT NULL,
    legal_entity_id integer NOT NULL,
    segment_id integer NOT NULL,
    ext_id bigint NOT NULL,
    export_version integer,
    export_dt timestamp without time zone,
    create_update_dt timestamp without time zone
);


--
-- Name: legal_entity_segment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.legal_entity_segment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: legal_entity_segment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.legal_entity_segment_id_seq OWNED BY public.legal_entity_segment.id;


--
-- Name: line_item_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.line_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: line_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.line_item_id_seq OWNED BY public.line_item.id;


--
-- Name: line_item_pixel; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_item_pixel (
    line_item_id integer NOT NULL,
    pixel_id integer NOT NULL
);


--
-- Name: line_item_trade_desk_insertion_order; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.line_item_trade_desk_insertion_order (
    line_item_id integer,
    trade_desk_id character varying(255)
);


--
-- Name: TABLE line_item_trade_desk_insertion_order; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.line_item_trade_desk_insertion_order IS 'Table for one-to-many relation between 1 C3 line item and many Insertion orders from the Trade Desk';


--
-- Name: COLUMN line_item_trade_desk_insertion_order.trade_desk_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.line_item_trade_desk_insertion_order.trade_desk_id IS 'Insertion Order ID from the Trade Desk system';


--
-- Name: liveramp_1p_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.liveramp_1p_segment_mapping (
    captify_id integer NOT NULL,
    liveramp_id bigint NOT NULL,
    create_dt timestamp without time zone DEFAULT now(),
    id_type public.id_type DEFAULT 'dsp_id'::public.id_type
);


--
-- Name: TABLE liveramp_1p_segment_mapping; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.liveramp_1p_segment_mapping IS 'Mapping table between Captify and Liveramp first party data segment id';


--
-- Name: magnite_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.magnite_segment_mapping (
    id integer NOT NULL,
    captify_id integer,
    magnite_id bigint NOT NULL,
    upload_enabled boolean DEFAULT false NOT NULL,
    id_type public.id_type DEFAULT 'dsp_id'::public.id_type
);


--
-- Name: openx_contextual_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openx_contextual_segment_mapping (
    captify_id integer NOT NULL,
    upload_enabled boolean DEFAULT true NOT NULL,
    update_date timestamp without time zone
);


--
-- Name: TABLE openx_contextual_segment_mapping; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.openx_contextual_segment_mapping IS 'Table to store the data about OpenX contextual segments';


--
-- Name: openx_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.openx_segment_mapping (
    id integer NOT NULL,
    captify_id integer,
    upload_enabled boolean DEFAULT false NOT NULL,
    id_type public.id_type DEFAULT 'dsp_id'::public.id_type
);


--
-- Name: openx_segment_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.openx_segment_mapping_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: openx_segment_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.openx_segment_mapping_id_seq OWNED BY public.openx_segment_mapping.id;

--
-- Name: pubmatic_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pubmatic_segment_mapping (
    id integer NOT NULL,
    captify_id integer,
    pubmatic_id bigint,
    data_provider_id integer,
    id_type public.id_type DEFAULT 'dsp_id'::public.id_type
);


--
-- Name: COLUMN pubmatic_segment_mapping.data_provider_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.pubmatic_segment_mapping.data_provider_id IS 'Data Provider Id, supported values: PROD: 239 (cookie-based) or 684 (cookieless); QA: 408 (cookie-based) or 535 (cookieless)';


--
-- Name: pubmatic_segment_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pubmatic_segment_mapping_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pubmatic_segment_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pubmatic_segment_mapping_id_seq OWNED BY public.pubmatic_segment_mapping.id;

--
-- Name: schema_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_version (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: schema_version_repeatable; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_version_repeatable (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: schema_version_utility; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_version_utility (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


--
-- Name: segment_active_dates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.segment_active_dates (
    segment_id integer,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone NOT NULL
);


--
-- Name: TABLE segment_active_dates; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.segment_active_dates IS 'Table to see what segment is active in the period of dates.';


--
-- Name: segment_group; Type: TABLE; Schema: public; Owner: -
--
-- todo drop but check in repo
CREATE TABLE public.segment_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    update_by integer,
    create_by integer NOT NULL,
    self_serve_type integer,
    dbm_tag character varying(1000),
    type integer NOT NULL,
    country_id integer
);


--
-- Name: segment_group_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.segment_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: segment_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.segment_group_id_seq OWNED BY public.segment_group.id;


--
-- Name: segment_group_segment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.segment_group_segment (
    id integer NOT NULL,
    segment_id integer NOT NULL,
    segment_group_id integer NOT NULL
);


--
-- Name: segment_group_segment_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.segment_group_segment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: segment_group_segment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.segment_group_segment_id_seq OWNED BY public.segment_group_segment.id;


--
-- Name: segment_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.segment_metadata (
    segment_id integer NOT NULL,
    segment_type character varying(50) NOT NULL,
    create_update_dt timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE segment_metadata; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.segment_metadata IS 'A&I table to have segment -> metadata for internal usage';


--
-- Name: segment_metadata_last_import; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.segment_metadata_last_import (
    service_name character varying(20) NOT NULL,
    last_import_timestamp timestamp without time zone NOT NULL
);


--
-- Name: TABLE segment_metadata_last_import; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.segment_metadata_last_import IS 'A&I table to save last import timestamp from SegmentAPI';


--
-- Name: sel_agency_group_id; Type: SEQUENCE; Schema: public; Owner: -
--
-- todo drop
CREATE SEQUENCE public.sel_agency_group_id
    START WITH 10201
    INCREMENT BY 100
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sel_country; Type: TABLE; Schema: public; Owner: -
--
-- todo drop
CREATE TABLE public.sel_country (
    id integer NOT NULL,
    code character varying(10),
    name character varying(90),
    appnexus_id integer,
    deleted boolean DEFAULT false NOT NULL,
    is_gdpr boolean DEFAULT false NOT NULL
);


--
-- Name: sel_country_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--
-- todo drop
CREATE SEQUENCE public.sel_country_id_seq
    START WITH 1001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sel_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--
-- todo drop
ALTER SEQUENCE public.sel_country_id_seq OWNED BY public.sel_country.id;


--
-- Name: sel_currency_id; Type: SEQUENCE; Schema: public; Owner: -
--
-- todo drop
CREATE SEQUENCE public.sel_currency_id
    START WITH 408
    INCREMENT BY 100
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sel_currency; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sel_currency (
    id integer DEFAULT nextval('public.sel_currency_id'::regclass) NOT NULL,
    name character varying(100),
    code character varying(100),
    hidden boolean DEFAULT false,
    is_default boolean DEFAULT false,
    symbol character varying(5) DEFAULT ' '::character varying NOT NULL,
    locale character varying(5) DEFAULT ' '::character varying NOT NULL
);


--
-- Name: sel_legal_entity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sel_legal_entity (
    id integer NOT NULL,
    name character varying(100) DEFAULT ''::character varying,
    dbm_partner_id bigint,
    office_name character varying(128) NOT NULL,
    timezone text DEFAULT 'Etc/UTC'::text,
    country character varying(2) NOT NULL,
    default_language character varying(2) NOT NULL
);


--
-- Name: COLUMN sel_legal_entity.country; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sel_legal_entity.country IS 'ISO 3166 alpha2 country code';


--
-- Name: COLUMN sel_legal_entity.default_language; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.sel_legal_entity.default_language IS 'ISO 639-1 alpha2 code of the default language';


--
-- Name: sel_legal_entity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sel_legal_entity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sel_legal_entity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sel_legal_entity_id_seq OWNED BY public.sel_legal_entity.id;


--
-- Name: sel_lineitem_media_type_format_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--
-- todo drop
CREATE SEQUENCE public.sel_lineitem_media_type_format_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sel_lineitem_media_type_id; Type: SEQUENCE; Schema: public; Owner: -
--
-- todo drop
CREATE SEQUENCE public.sel_lineitem_media_type_id
    START WITH 425
    INCREMENT BY 100
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sel_lineitem_target_type_id; Type: SEQUENCE; Schema: public; Owner: -
--
-- todo drop
CREATE SEQUENCE public.sel_lineitem_target_type_id
    START WITH 709
    INCREMENT BY 100
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sel_lineitem_type_id; Type: SEQUENCE; Schema: public; Owner: -
--
-- todo drop
CREATE SEQUENCE public.sel_lineitem_type_id
    START WITH 607
    INCREMENT BY 100
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sel_revenue_type_id; Type: SEQUENCE; Schema: public; Owner: -
--
-- todo drop
CREATE SEQUENCE public.sel_revenue_type_id
    START WITH 606
    INCREMENT BY 100
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.strategy_dbm (
    id integer NOT NULL,
    dbm_strategy_id bigint NOT NULL,
    name text NOT NULL,
    line_item_id integer
);


--
-- Name: TABLE strategy_dbm; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.strategy_dbm IS 'Strategy table for DBM to unify AN campaigns and DBM LIs for attribution etc.';


--
-- Name: COLUMN strategy_dbm.line_item_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.strategy_dbm.line_item_id IS 'C3 Line Item Id';


--
-- Name: ttd_dmp_identity_segment_export_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ttd_dmp_identity_segment_export_history (
    captify_id integer,
    export_date timestamp without time zone DEFAULT now(),
    override_segment_name text,
    buyable boolean NOT NULL
);


--
-- Name: TABLE ttd_dmp_identity_segment_export_history; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ttd_dmp_identity_segment_export_history IS 'Table that tracks the history of segment exports to TheTradeDesk Data Management Platform.';


--
-- Name: ttd_dmp_identity_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ttd_dmp_identity_segment_mapping (
    id integer NOT NULL,
    captify_id integer NOT NULL,
    ttd_id bigint NOT NULL,
    upload_enabled boolean DEFAULT true NOT NULL
);


--
-- Name: TABLE ttd_dmp_identity_segment_mapping; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ttd_dmp_identity_segment_mapping IS 'Mapping table between Captify and TheTradeDesk Data Marketplace identity segment ids';


--
-- Name: ttd_dmp_identity_segment_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ttd_dmp_identity_segment_mapping_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ttd_dmp_identity_segment_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ttd_dmp_identity_segment_mapping_id_seq OWNED BY public.ttd_dmp_identity_segment_mapping.id;


--
-- Name: ttd_marketplace_contextual_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ttd_marketplace_contextual_segment_mapping (
    captify_id integer NOT NULL,
    ttd_id character varying(30) NOT NULL,
    export_version integer DEFAULT 0 NOT NULL,
    create_dt timestamp without time zone DEFAULT now(),
    last_export_dt timestamp without time zone DEFAULT now(),
    upload_enabled boolean DEFAULT true
);


--
-- Name: TABLE ttd_marketplace_contextual_segment_mapping; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ttd_marketplace_contextual_segment_mapping IS 'Mapping table between Captify contextual segment id and TheTradeDesk marketplace segment id';


--
-- Name: ttd_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ttd_segment_mapping (
    captify_id integer,
    data_element_name character varying(300),
    id_type public.id_type DEFAULT 'dsp_id'::public.id_type
);


--
-- Name: ttd_segment_pricing_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ttd_segment_pricing_requests (
    captify_request_id bigint NOT NULL,
    provider_id text NOT NULL,
    provider_element_id text NOT NULL,
    brand_id text NOT NULL,
    rate_level text NOT NULL,
    partner_id text,
    rate_type text NOT NULL,
    cpm_rate_amount numeric,
    cpm_rate_currency_code text,
    percent_of_media_cost_rate numeric,
    status text NOT NULL,
    error_reason text,
    ttd_batch_id text,
    ttd_raw_response text,
    create_dt timestamp without time zone DEFAULT now() NOT NULL,
    update_dt timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE ttd_segment_pricing_requests; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.ttd_segment_pricing_requests IS 'Table to track the history of segment pricing rates requests to TTD';


--
-- Name: COLUMN ttd_segment_pricing_requests.provider_element_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.ttd_segment_pricing_requests.provider_element_id IS 'A unique ID that Captify set to identify segment in TTD;
    -217: for contextual standard category; -218: for contextual custom category;';


--
-- Name: tv_regions_mapping; Type: TABLE; Schema: public; Owner: -
--
--todo drop
CREATE TABLE public.tv_regions_mapping (
    region_id integer NOT NULL,
    tv_region_id integer NOT NULL
);


--
-- Name: xandr_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.xandr_segment_mapping (
    id integer NOT NULL,
    captify_id integer,
    xandr_id bigint,
    export_version integer,
    export_dt timestamp without time zone,
    create_update_dt timestamp without time zone,
    id_type public.id_type DEFAULT 'dsp_id'::public.id_type
);


--
-- Name: xandr_segment_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.xandr_segment_mapping_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: xandr_segment_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.xandr_segment_mapping_id_seq OWNED BY public.xandr_segment_mapping.id;


--
-- Name: xlsx_order_ids; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.xlsx_order_ids
    START WITH 4203
    INCREMENT BY 100
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zeotap_identity_segment_mapping; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.zeotap_identity_segment_mapping (
    captify_id integer NOT NULL,
    zeotap_segment_id character varying(255) NOT NULL,
    country_code character varying(2) NOT NULL,
    price integer NOT NULL,
    destination_id integer NOT NULL,
    mapping_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    upload_enabled boolean DEFAULT true NOT NULL
);


--
-- Name: conversion_pixel id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversion_pixel ALTER COLUMN id SET DEFAULT nextval('public.conversion_pixel_id_seq'::regclass);


--
-- Name: dict_property_pixel_category id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_property_pixel_category ALTER COLUMN id SET DEFAULT nextval('public.dict_property_pixel_category_id_seq'::regclass);


--
-- Name: dict_region id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_region ALTER COLUMN id SET DEFAULT nextval('public.dict_region_id_seq'::regclass);

--
-- Name: legal_entity_segment id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_entity_segment ALTER COLUMN id SET DEFAULT nextval('public.legal_entity_segment_id_seq'::regclass);


--
-- Name: line_item id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item ALTER COLUMN id SET DEFAULT nextval('public.line_item_id_seq'::regclass);


--
-- Name: magnite_segment_mapping id; Type: DEFAULT; Schema: public; Owner: -
--

--ALTER TABLE ONLY public.magnite_segment_mapping ALTER COLUMN id SET DEFAULT nextval('public.rubicon_segment_mapping_id_seq'::regclass);


--
-- Name: openx_segment_mapping id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openx_segment_mapping ALTER COLUMN id SET DEFAULT nextval('public.openx_segment_mapping_id_seq'::regclass);


--
-- Name: pubmatic_segment_mapping id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pubmatic_segment_mapping ALTER COLUMN id SET DEFAULT nextval('public.pubmatic_segment_mapping_id_seq'::regclass);


--
-- Name: segment_group id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_group ALTER COLUMN id SET DEFAULT nextval('public.segment_group_id_seq'::regclass);


--
-- Name: segment_group_segment id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_group_segment ALTER COLUMN id SET DEFAULT nextval('public.segment_group_segment_id_seq'::regclass);


--
-- Name: sel_country id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_country ALTER COLUMN id SET DEFAULT nextval('public.sel_country_id_seq'::regclass);


--
-- Name: sel_legal_entity id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_legal_entity ALTER COLUMN id SET DEFAULT nextval('public.sel_legal_entity_id_seq'::regclass);


--
-- Name: shared_conversion_pixel id; Type: DEFAULT; Schema: public; Owner: -
--

--ALTER TABLE ONLY public.shared_conversion_pixel ALTER COLUMN id SET DEFAULT nextval('public.shared_conversion_pixel_id_seq'::regclass);


--
-- Name: ttd_dmp_identity_segment_mapping id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ttd_dmp_identity_segment_mapping ALTER COLUMN id SET DEFAULT nextval('public.ttd_dmp_identity_segment_mapping_id_seq'::regclass);


--
-- Name: xandr_segment_mapping id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xandr_segment_mapping ALTER COLUMN id SET DEFAULT nextval('public.xandr_segment_mapping_id_seq'::regclass);


--
-- Name: xandr_segment_mapping captify_id_id_type_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xandr_segment_mapping
    ADD CONSTRAINT captify_id_id_type_unique UNIQUE (captify_id, id_type);


--
-- Name: conversion_pixel conversion_pixel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversion_pixel
    ADD CONSTRAINT conversion_pixel_pkey PRIMARY KEY (id);


--
-- Name: dict_browser dict_browser_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_browser
    ADD CONSTRAINT dict_browser_pkey PRIMARY KEY (id);


--
-- Name: dict_device_type dict_device_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_device_type
    ADD CONSTRAINT dict_device_type_pkey PRIMARY KEY (id);


--
-- Name: dict_iso_countries dict_iso_countries_alpha3_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_iso_countries
    ADD CONSTRAINT dict_iso_countries_alpha3_key UNIQUE (alpha3);


--
-- Name: dict_iso_countries dict_iso_countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_iso_countries
    ADD CONSTRAINT dict_iso_countries_pkey PRIMARY KEY (alpha2);


--
-- Name: dict_operating_system dict_operating_system_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_operating_system
    ADD CONSTRAINT dict_operating_system_pkey PRIMARY KEY (id);


--
-- Name: dict_property_pixel_category dict_property_pixel_category_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_property_pixel_category
    ADD CONSTRAINT dict_property_pixel_category_pkey PRIMARY KEY (id);


--
-- Name: dict_region dict_region_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_region
    ADD CONSTRAINT dict_region_pkey PRIMARY KEY (id);

--
-- Name: insertion_order insertion_order_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insertion_order
    ADD CONSTRAINT insertion_order_pkey PRIMARY KEY (id);


--
-- Name: keyphrase keyphrase_keyphrase_key; Type: CONSTRAINT; Schema: public; Owner: -
--

--ALTER TABLE ONLY public.keyphrase
--    ADD CONSTRAINT keyphrase_keyphrase_key UNIQUE (keyphrase);


--
-- Name: keyphrase keyphrase_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

--ALTER TABLE ONLY public.keyphrase
--    ADD CONSTRAINT keyphrase_pkey PRIMARY KEY (id);


--
-- Name: legal_entity_segment legal_entity_segment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_entity_segment
    ADD CONSTRAINT legal_entity_segment_pkey PRIMARY KEY (id);


--
-- Name: line_item_pixel line_item_pixel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_pixel
    ADD CONSTRAINT line_item_pixel_pkey PRIMARY KEY (line_item_id, pixel_id);


--
-- Name: line_item line_item_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item
    ADD CONSTRAINT line_item_pkey PRIMARY KEY (id);


--
-- Name: line_item_trade_desk_insertion_order line_item_trade_desk_insertion_order_trade_desk_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_trade_desk_insertion_order
    ADD CONSTRAINT line_item_trade_desk_insertion_order_trade_desk_id_key UNIQUE (trade_desk_id);


--
-- Name: liveramp_1p_segment_mapping liveramp_1p_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.liveramp_1p_segment_mapping
    ADD CONSTRAINT liveramp_1p_segment_mapping_pkey PRIMARY KEY (captify_id, liveramp_id);


--
-- Name: openx_contextual_segment_mapping openx_contextual_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openx_contextual_segment_mapping
    ADD CONSTRAINT openx_contextual_segment_mapping_pkey PRIMARY KEY (captify_id);


--
-- Name: openx_segment_mapping openx_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openx_segment_mapping
    ADD CONSTRAINT openx_segment_mapping_pkey PRIMARY KEY (id);


--
-- Name: pubmatic_segment_mapping pubmatic_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pubmatic_segment_mapping
    ADD CONSTRAINT pubmatic_segment_mapping_pkey PRIMARY KEY (id);

--
-- Name: magnite_segment_mapping rubicon_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magnite_segment_mapping
    ADD CONSTRAINT rubicon_segment_mapping_pkey PRIMARY KEY (id);


--
-- Name: schema_version schema_version_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_version
    ADD CONSTRAINT schema_version_pk PRIMARY KEY (installed_rank);


--
-- Name: schema_version_repeatable schema_version_repeatable_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_version_repeatable
    ADD CONSTRAINT schema_version_repeatable_pk PRIMARY KEY (installed_rank);


--
-- Name: schema_version_utility schema_version_utility_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_version_utility
    ADD CONSTRAINT schema_version_utility_pk PRIMARY KEY (installed_rank);


--
-- Name: segment_group segment_group_name_create_by_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_group
    ADD CONSTRAINT segment_group_name_create_by_key UNIQUE (name, create_by);


--
-- Name: segment_group segment_group_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_group
    ADD CONSTRAINT segment_group_pkey PRIMARY KEY (id);


--
-- Name: segment_group_segment segment_group_segment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_group_segment
    ADD CONSTRAINT segment_group_segment_pkey PRIMARY KEY (id);


--
-- Name: segment_group_segment segment_group_segment_segment_id_segment_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_group_segment
    ADD CONSTRAINT segment_group_segment_segment_id_segment_group_id_key UNIQUE (segment_id, segment_group_id);


--
-- Name: segment_metadata_last_import segment_metadata_last_import_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_metadata_last_import
    ADD CONSTRAINT segment_metadata_last_import_pkey PRIMARY KEY (service_name);


--
-- Name: segment_metadata segment_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_metadata
    ADD CONSTRAINT segment_metadata_pkey PRIMARY KEY (segment_id);


--
-- Name: sel_agency sel_agency_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_agency
    ADD CONSTRAINT sel_agency_pkey PRIMARY KEY (id);


--
-- Name: sel_country sel_country_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_country
    ADD CONSTRAINT sel_country_code_key UNIQUE (code);


--
-- Name: sel_country sel_country_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_country
    ADD CONSTRAINT sel_country_name_key UNIQUE (name);


--
-- Name: sel_country sel_country_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_country
    ADD CONSTRAINT sel_country_pkey PRIMARY KEY (id);


--
-- Name: sel_currency sel_currency_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_currency
    ADD CONSTRAINT sel_currency_pkey PRIMARY KEY (id);


--
-- Name: sel_legal_entity sel_legal_entity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_legal_entity
    ADD CONSTRAINT sel_legal_entity_pkey PRIMARY KEY (id);


--
-- Name: shared_conversion_pixel shared_conversion_pixel_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

--ALTER TABLE ONLY public.shared_conversion_pixel
--    ADD CONSTRAINT shared_conversion_pixel_pkey PRIMARY KEY (id);
--

--
-- Name: strategy_dbm strategy_dbm_dbm_strategy_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategy_dbm
    ADD CONSTRAINT strategy_dbm_dbm_strategy_id_key UNIQUE (dbm_strategy_id);


--
-- Name: strategy_dbm strategy_dbm_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.strategy_dbm
    ADD CONSTRAINT strategy_dbm_pkey PRIMARY KEY (id);


--
-- Name: ttd_dmp_identity_segment_mapping ttd_dmp_identity_segment_mapping_captify_id_ttd_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ttd_dmp_identity_segment_mapping
    ADD CONSTRAINT ttd_dmp_identity_segment_mapping_captify_id_ttd_id_key UNIQUE (captify_id, ttd_id);


--
-- Name: ttd_dmp_identity_segment_mapping ttd_dmp_identity_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ttd_dmp_identity_segment_mapping
    ADD CONSTRAINT ttd_dmp_identity_segment_mapping_pkey PRIMARY KEY (id);


--
-- Name: ttd_marketplace_contextual_segment_mapping ttd_marketplace_contextual_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ttd_marketplace_contextual_segment_mapping
    ADD CONSTRAINT ttd_marketplace_contextual_segment_mapping_pkey PRIMARY KEY (captify_id, ttd_id);


--
-- Name: tv_regions_mapping tv_regions_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tv_regions_mapping
    ADD CONSTRAINT tv_regions_mapping_pkey PRIMARY KEY (region_id);


--
-- Name: magnite_segment_mapping unique_captify_id_id_type_magnite; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magnite_segment_mapping
    ADD CONSTRAINT unique_captify_id_id_type_magnite UNIQUE (captify_id, id_type);


--
-- Name: openx_segment_mapping unique_captify_id_id_type_openx; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.openx_segment_mapping
    ADD CONSTRAINT unique_captify_id_id_type_openx UNIQUE (captify_id, id_type);


--
-- Name: ttd_segment_mapping unique_captify_id_id_type_tdd; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ttd_segment_mapping
    ADD CONSTRAINT unique_captify_id_id_type_tdd UNIQUE (captify_id, id_type);


--
-- Name: magnite_segment_mapping unique_captify_id_magnite_id_id_type; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.magnite_segment_mapping
    ADD CONSTRAINT unique_captify_id_magnite_id_id_type UNIQUE (captify_id, magnite_id, id_type);


--
-- Name: pubmatic_segment_mapping unique_captify_id_pubmatic_id_id_type; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pubmatic_segment_mapping
    ADD CONSTRAINT unique_captify_id_pubmatic_id_id_type UNIQUE (captify_id, pubmatic_id, id_type);


--
-- Name: legal_entity_segment unique_legal_entity_id_segment_id_ext_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_entity_segment
    ADD CONSTRAINT unique_legal_entity_id_segment_id_ext_id UNIQUE (legal_entity_id, segment_id, ext_id);


--
-- Name: xandr_segment_mapping xandr_id_id_type_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xandr_segment_mapping
    ADD CONSTRAINT xandr_id_id_type_unique UNIQUE (xandr_id, id_type);


--
-- Name: xandr_segment_mapping xandr_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.xandr_segment_mapping
    ADD CONSTRAINT xandr_segment_mapping_pkey PRIMARY KEY (id);


--
-- Name: zeotap_identity_segment_mapping zeotap_identity_segment_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.zeotap_identity_segment_mapping
    ADD CONSTRAINT zeotap_identity_segment_mapping_pkey PRIMARY KEY (captify_id);


--
-- Name: conversion_pixel_advertiser_segment_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX conversion_pixel_advertiser_segment_idx ON public.conversion_pixel USING btree (advertiser, appnexus_segment_id);


--
-- Name: dict_region_deleted_appnexus_code_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dict_region_deleted_appnexus_code_idx ON public.dict_region USING btree (deleted, appnexus_code);


--
-- Name: dict_region_deleted_appnexus_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dict_region_deleted_appnexus_id_idx ON public.dict_region USING btree (deleted, appnexus_id);


--
-- Name: dict_region_deleted_code_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dict_region_deleted_code_idx ON public.dict_region USING btree (deleted, code);


--
-- Name: dict_region_deleted_country_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX dict_region_deleted_country_id_idx ON public.dict_region USING btree (deleted, country_id);

--
-- Name: idx_insertion_order_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_insertion_order_code ON public.insertion_order USING btree (advertiser, code);


--
-- Name: idx_insertion_order_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_insertion_order_name ON public.insertion_order USING btree (advertiser, name);


--
-- Name: idx_line_item_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_line_item_code ON public.line_item USING btree (advertiser, code);


--
-- Name: idx_line_item_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_line_item_name ON public.line_item USING btree (insertion_order, name);


--
-- Name: idx_media_group_name; Type: INDEX; Schema: public; Owner: -
--

--CREATE UNIQUE INDEX idx_media_group_name ON public.media_group USING btree (name);


--
-- Name: insertion_order_advertiser_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX insertion_order_advertiser_idx ON public.insertion_order USING btree (advertiser);


--
-- Name: schema_version_repeatable_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX schema_version_repeatable_s_idx ON public.schema_version_repeatable USING btree (success);


--
-- Name: schema_version_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX schema_version_s_idx ON public.schema_version USING btree (success);


--
-- Name: schema_version_utility_s_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX schema_version_utility_s_idx ON public.schema_version_utility USING btree (success);


--
-- Name: sel_country_deleted_appnexus_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sel_country_deleted_appnexus_id_idx ON public.sel_country USING btree (deleted, appnexus_id);


--
-- Name: sel_country_deleted_code_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX sel_country_deleted_code_idx ON public.sel_country USING btree (deleted, code);


--
-- Name: insertion_order INSERTION_ORDER.LEGAL_ENTITY; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insertion_order
    ADD CONSTRAINT "INSERTION_ORDER.LEGAL_ENTITY" FOREIGN KEY (legal_entity) REFERENCES public.sel_legal_entity(id);
--

--
-- Name: conversion_pixel conversion_pixel_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversion_pixel
    ADD CONSTRAINT conversion_pixel_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.dict_property_pixel_category(id);


--
-- Name: dict_region dict_region_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dict_region
    ADD CONSTRAINT dict_region_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.sel_country(id);

--
-- Name: insertion_order insertion_order_agency_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insertion_order
    ADD CONSTRAINT insertion_order_agency_id_fkey FOREIGN KEY (agency_id) REFERENCES public.sel_agency(id);


--
-- Name: insertion_order insertion_order_currency_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insertion_order
    ADD CONSTRAINT insertion_order_currency_fkey FOREIGN KEY (currency) REFERENCES public.sel_currency(id);


--
-- Name: legal_entity_segment legal_entity_segment_legal_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.legal_entity_segment
    ADD CONSTRAINT legal_entity_segment_legal_entity_id_fkey FOREIGN KEY (legal_entity_id) REFERENCES public.sel_legal_entity(id) ON DELETE CASCADE;


--
-- Name: line_item line_item_insertion_order_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item
    ADD CONSTRAINT line_item_insertion_order_fkey FOREIGN KEY (insertion_order) REFERENCES public.insertion_order(id) ON DELETE CASCADE;


--
-- Name: line_item_pixel line_item_pixel_line_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_pixel
    ADD CONSTRAINT line_item_pixel_line_item_id_fkey FOREIGN KEY (line_item_id) REFERENCES public.line_item(id) ON DELETE CASCADE;


--
-- Name: line_item_pixel line_item_pixel_pixel_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_pixel
    ADD CONSTRAINT line_item_pixel_pixel_id_fkey FOREIGN KEY (pixel_id) REFERENCES public.conversion_pixel(id);


--
-- Name: line_item_trade_desk_insertion_order line_item_trade_desk_insertion_order_line_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.line_item_trade_desk_insertion_order
    ADD CONSTRAINT line_item_trade_desk_insertion_order_line_item_id_fkey FOREIGN KEY (line_item_id) REFERENCES public.line_item(id) ON DELETE CASCADE;
--

--
-- Name: segment_group segment_group_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.segment_group
    ADD CONSTRAINT segment_group_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.sel_country(id);


--
-- Name: sel_agency sel_agency_currency_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_agency
    ADD CONSTRAINT sel_agency_currency_fkey FOREIGN KEY (id_currency) REFERENCES public.sel_currency(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sel_agency sel_agency_legal_entity_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_agency
    ADD CONSTRAINT sel_agency_legal_entity_fkey FOREIGN KEY (legal_entity) REFERENCES public.sel_legal_entity(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sel_legal_entity sel_legal_entity_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sel_legal_entity
    ADD CONSTRAINT sel_legal_entity_country_fkey FOREIGN KEY (country) REFERENCES public.dict_iso_countries(alpha2);

--
-- PostgreSQL database dump complete
--


