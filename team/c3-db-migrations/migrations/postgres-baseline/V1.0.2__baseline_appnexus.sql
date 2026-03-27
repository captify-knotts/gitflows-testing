-- =====================================================
-- C3 Database Baseline Migration - appnexus schema
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

--
-- Name: appnexus; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS appnexus;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: browsers; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.browsers (
    id integer NOT NULL,
    name character varying(100),
    platform_type character varying(100),
    browser_family_id integer,
    last_modified timestamp(0) without time zone
);


--
-- Name: budget_intervals; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.budget_intervals (
    id integer NOT NULL,
    line_item_id integer,
    start_date timestamp(0) without time zone,
    end_date timestamp(0) without time zone,
    lifetime_budget numeric(12,2),
    lifetime_budget_imps bigint,
    lifetime_pacing boolean,
    enable_pacing boolean,
    daily_budget numeric(12,2),
    daily_budget_imps bigint
);


--
-- Name: campaign_creatives; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.campaign_creatives (
    campaign_id integer NOT NULL,
    creative_id integer NOT NULL
);


--
-- Name: campaigns; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.campaigns (
    id bigint NOT NULL,
    state character varying(8),
    parent_inactive boolean,
    code character varying(100),
    name character varying(255),
    short_name character varying(50),
    advertiser_id bigint,
    profile_id bigint,
    line_item_id bigint,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    timezone character varying(64),
    last_modified timestamp without time zone,
    supply_type character varying(64),
    supply_type_action character varying(8),
    inventory_type character varying(9),
    roadblock_creatives boolean,
    roadblock_type character varying(20),
    comments character varying(2000),
    click_url character varying(1000),
    remaining_days bigint,
    total_days bigint,
    first_run timestamp without time zone,
    last_run timestamp without time zone,
    creative_distribution_type character varying(14),
    weight bigint,
    lifetime_budget double precision,
    lifetime_budget_imps bigint,
    daily_budget double precision,
    daily_budget_imps bigint,
    learn_budget double precision,
    learn_budget_imps bigint,
    learn_budget_daily_cap double precision,
    learn_budget_daily_imps bigint,
    enable_pacing boolean,
    lifetime_pacing boolean,
    lifetime_pacing_span bigint,
    priority bigint,
    cadence_modifier_enabled boolean,
    cpm_bid_type character varying(12),
    base_bid double precision,
    min_bid double precision,
    max_bid double precision,
    bid_margin double precision,
    cpc_goal double precision,
    ecp_learn_divisor character varying(64),
    projected_learn_events bigint,
    learn_threshold bigint,
    max_learn_bid bigint,
    cadence_type character varying(10),
    defer_to_li_prediction boolean,
    optimization_version character varying(16),
    learn_override_type character varying(20),
    base_cpm_bid_value double precision,
    bid_multiplier double precision,
    impression_limit bigint,
    campaign_type character varying(64),
    is_archived boolean,
    archived_on timestamp without time zone
);


--
-- Name: change_log; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.change_log (
    user_id integer,
    account_name character varying(100),
    change_date date,
    resource_id integer,
    service character varying(30),
    changed_field character varying(60),
    change_option character varying(7),
    transaction_id character varying(36),
    old_value text,
    new_value text
);


--
-- Name: raw_content_category; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.raw_content_category (
    id integer NOT NULL,
    name character varying(100),
    last_modified timestamp without time zone
);


--
-- Name: raw_site; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.raw_site (
    id integer NOT NULL,
    url character varying(2048),
    content_categories character varying(8000),
    primary_content_category_id integer,
    last_modified timestamp without time zone
);


--
-- Name: content_category; Type: VIEW; Schema: appnexus; Owner: -
--

CREATE VIEW appnexus.content_category AS
 SELECT DISTINCT t.id,
    t.name
   FROM ( SELECT raw_content_category.id,
            raw_content_category.name
           FROM appnexus.raw_content_category
        UNION
         SELECT ((t_1.category ->> 'id'::text))::integer AS id,
            (t_1.category ->> 'name'::text) AS name
           FROM ( SELECT json_array_elements((raw_site.content_categories)::json) AS category
                   FROM appnexus.raw_site) t_1) t;


--
-- Name: conversion_pixels; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.conversion_pixels (
    id integer NOT NULL,
    name character varying(255),
    state boolean,
    advertiser_id integer,
    created_on timestamp(0) without time zone,
    last_modified timestamp(0) without time zone
);


--
-- Name: creatives; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.creatives (
    id bigint NOT NULL,
    name character varying(400),
    code character varying(100),
    advertiser_id bigint,
    publisher_id bigint,
    format character varying(100),
    width integer,
    height integer,
    last_modified timestamp(0) without time zone,
    state character varying(20),
    audit_status character varying(16),
    is_expired boolean
);


--
-- Name: deal_type; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.deal_type (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: deals; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.deals (
    id integer NOT NULL,
    code character varying(100),
    name character varying(255),
    deal_type bigint,
    seller_id integer,
    start_date timestamp(0) without time zone,
    end_date timestamp(0) without time zone,
    last_modified timestamp(0) without time zone,
    currency character varying(255),
    seller_name character varying(100)
);


--
-- Name: device_models; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.device_models (
    id integer NOT NULL,
    name character varying(100),
    device_make_id integer,
    device_make_name character varying(100),
    device_type character varying(100),
    screen_width integer,
    screen_height integer,
    code character varying(100),
    last_modified timestamp(0) without time zone
);


--
-- Name: dict_device_type; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.dict_device_type (
    id smallint NOT NULL,
    name character varying(20) NOT NULL
);


--
-- Name: dict_mdss_exposure_type; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.dict_mdss_exposure_type (
    id integer NOT NULL,
    name character varying(5) NOT NULL
);


--
-- Name: TABLE dict_mdss_exposure_type; Type: COMMENT; Schema: appnexus; Owner: -
--

COMMENT ON TABLE appnexus.dict_mdss_exposure_type IS 'Xandr segment exposure type in Member Data Sharing Service';


--
-- Name: insertion_orders; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.insertion_orders (
    id integer NOT NULL,
    name character varying(256),
    code character varying(50),
    state character varying(20),
    advertiser_id integer,
    last_modified timestamp without time zone
);


--
-- Name: line_item_creatives; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.line_item_creatives (
    line_item_id bigint NOT NULL,
    creative_id bigint NOT NULL
);


--
-- Name: line_items; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.line_items (
    id integer NOT NULL,
    advertiser_id integer,
    insertion_order_id integer,
    name character varying(256),
    code character varying(100),
    state character varying(20),
    revenue_type character varying(50),
    revenue_value numeric(12,2),
    target_type character varying(50),
    target_amount numeric(12,2),
    currency character varying(10),
    io_flights_mode boolean,
    last_modified timestamp(0) without time zone,
    start_date timestamp(0) without time zone,
    end_date timestamp(0) without time zone,
    lifetime_budget numeric(12,2),
    lifetime_budget_imps bigint,
    lifetime_pacing boolean,
    enable_pacing boolean,
    daily_budget numeric(12,2),
    daily_budget_imps bigint,
    profile_id bigint,
    line_item_type character varying(32),
    is_archived boolean,
    archived_on timestamp without time zone
);


--
-- Name: mdss_segment; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.mdss_segment (
    xandr_sharing_id integer NOT NULL,
    xandr_segment_id bigint NOT NULL,
    segment_name character varying(255),
    create_timestamp timestamp without time zone NOT NULL,
    update_timestamp timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE mdss_segment; Type: COMMENT; Schema: appnexus; Owner: -
--

COMMENT ON TABLE appnexus.mdss_segment IS 'List of Segments in Xandr MDSS record';


--
-- Name: mdss_sharing; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.mdss_sharing (
    xandr_id integer NOT NULL,
    buyer_member_id integer NOT NULL,
    segment_exposure integer,
    create_timestamp timestamp without time zone NOT NULL,
    update_timestamp timestamp without time zone NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE mdss_sharing; Type: COMMENT; Schema: appnexus; Owner: -
--

COMMENT ON TABLE appnexus.mdss_sharing IS 'List of Xandr MDSS records';


--
-- Name: operating_system_family; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.operating_system_family (
    id integer NOT NULL,
    name character varying(512),
    last_modified timestamp without time zone
);


--
-- Name: operating_systems; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.operating_systems (
    id integer NOT NULL,
    name character varying(100),
    platform_type character varying(100),
    os_family_id integer,
    os_family_name character varying(100),
    last_modified timestamp(0) without time zone
);


--
-- Name: profile_segments; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.profile_segments (
    profile_id integer NOT NULL,
    segment_id integer NOT NULL,
    boolean_operator character varying(3),
    code character varying(150),
    name character varying(255),
    action character varying(3),
    start_minutes integer,
    expire_minutes integer,
    other_less integer,
    other_greater integer,
    other_equals integer
);


--
-- Name: profiles; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.profiles (
    id integer NOT NULL,
    last_modified timestamp(0) without time zone,
    segment_boolean_operator character varying(3),
    device_type_action character varying(3),
    device_type_targets character varying(1000),
    supply_type_action character varying(3),
    supply_type_targets character varying(36),
    device_model_action character varying(3),
    device_model_targets character varying(30000),
    browser_action character varying(3),
    browser_targets character varying(1000),
    carrier_action character varying(3),
    carrier_targets character varying(1000),
    daypart_targets character varying(1000),
    daypart_timezone character varying(32),
    country_action character varying(3),
    country_targets character varying(1000),
    region_action character varying(3),
    region_targets character varying(10000),
    city_action character varying(3),
    city_targets character varying(10000),
    max_lifetime_imps integer,
    max_day_imps integer,
    min_minutes_per_imp integer,
    require_cookie_for_freq_cap boolean,
    max_hour_imps integer,
    max_week_imps integer,
    max_month_imps integer,
    is_archived boolean,
    archived_on timestamp without time zone
);


--
-- Name: segments; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.segments (
    id integer NOT NULL,
    advertiser_id integer,
    short_name character varying(512),
    state character varying(20) NOT NULL,
    last_modified timestamp(0) without time zone
);


--
-- Name: sellers; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.sellers (
    seller_id integer NOT NULL,
    seller_name character varying(140),
    last_updated_ts timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: site; Type: VIEW; Schema: appnexus; Owner: -
--

CREATE VIEW appnexus.site AS
 SELECT rs.id,
    rs.url,
    (json_array_elements((rs.content_categories)::json) ->> 'id'::text) AS content_category_id,
    rs.primary_content_category_id
   FROM appnexus.raw_site rs
  WHERE (rs.content_categories IS NOT NULL)
UNION
 SELECT rs.id,
    rs.url,
    NULL::text AS content_category_id,
    rs.primary_content_category_id
   FROM appnexus.raw_site rs
  WHERE (rs.content_categories IS NULL);


--
-- Name: split_segment; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.split_segment (
    line_item_id integer NOT NULL,
    split_id integer,
    segment_id integer,
    last_modified timestamp without time zone NOT NULL
);


--
-- Name: splits; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.splits (
    id integer,
    line_item_id integer NOT NULL,
    name character varying,
    is_default boolean DEFAULT false,
    active boolean DEFAULT false,
    split_order integer,
    allocation_percent double precision,
    bid_modifier double precision,
    expected_value double precision
);


--
-- Name: users; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.users (
    id bigint NOT NULL,
    first_name character varying(128),
    last_name character varying(128),
    username character varying(256),
    email character varying(256),
    read_only boolean,
    api_login boolean,
    is_admin boolean,
    state character varying(8),
    last_modified timestamp(0) without time zone
);


--
-- Name: video_feed_imp_type; Type: TABLE; Schema: appnexus; Owner: -
--

CREATE TABLE appnexus.video_feed_imp_type (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: insertion_orders appnexus_insertion_orders_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.insertion_orders
    ADD CONSTRAINT appnexus_insertion_orders_pkey PRIMARY KEY (id);


--
-- Name: line_item_creatives appnexus_line_item_creatives_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.line_item_creatives
    ADD CONSTRAINT appnexus_line_item_creatives_pkey PRIMARY KEY (line_item_id, creative_id);


--
-- Name: sellers appnexus_sellers_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.sellers
    ADD CONSTRAINT appnexus_sellers_pkey PRIMARY KEY (seller_id);


--
-- Name: browsers browsers_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.browsers
    ADD CONSTRAINT browsers_pkey PRIMARY KEY (id);


--
-- Name: budget_intervals budget_intervals_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.budget_intervals
    ADD CONSTRAINT budget_intervals_pkey PRIMARY KEY (id);


--
-- Name: campaign_creatives campaign_creatives_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.campaign_creatives
    ADD CONSTRAINT campaign_creatives_pkey PRIMARY KEY (campaign_id, creative_id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: conversion_pixels conversion_pixels_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.conversion_pixels
    ADD CONSTRAINT conversion_pixels_pkey PRIMARY KEY (id);


--
-- Name: creatives creatives_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.creatives
    ADD CONSTRAINT creatives_pkey PRIMARY KEY (id);


--
-- Name: deal_type deal_type_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.deal_type
    ADD CONSTRAINT deal_type_pkey PRIMARY KEY (id);


--
-- Name: deals deals_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.deals
    ADD CONSTRAINT deals_pkey PRIMARY KEY (id);


--
-- Name: device_models device_models_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.device_models
    ADD CONSTRAINT device_models_pkey PRIMARY KEY (id);


--
-- Name: dict_device_type dict_device_type_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.dict_device_type
    ADD CONSTRAINT dict_device_type_pkey PRIMARY KEY (id);


--
-- Name: dict_mdss_exposure_type dict_mdss_exposure_type_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.dict_mdss_exposure_type
    ADD CONSTRAINT dict_mdss_exposure_type_pkey PRIMARY KEY (id);


--
-- Name: dict_mdss_exposure_type id_name; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.dict_mdss_exposure_type
    ADD CONSTRAINT id_name UNIQUE (id, name);


--
-- Name: line_items line_items_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.line_items
    ADD CONSTRAINT line_items_pkey PRIMARY KEY (id);


--
-- Name: mdss_segment mdss_segment_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.mdss_segment
    ADD CONSTRAINT mdss_segment_pkey PRIMARY KEY (xandr_sharing_id, xandr_segment_id);


--
-- Name: mdss_sharing mdss_sharing_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.mdss_sharing
    ADD CONSTRAINT mdss_sharing_pkey PRIMARY KEY (xandr_id);


--
-- Name: operating_system_family operating_system_family_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.operating_system_family
    ADD CONSTRAINT operating_system_family_pkey PRIMARY KEY (id);


--
-- Name: operating_systems operating_systems_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.operating_systems
    ADD CONSTRAINT operating_systems_pkey PRIMARY KEY (id);


--
-- Name: profile_segments profile_segments_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.profile_segments
    ADD CONSTRAINT profile_segments_pkey PRIMARY KEY (profile_id, segment_id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: raw_content_category raw_content_category_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.raw_content_category
    ADD CONSTRAINT raw_content_category_pkey PRIMARY KEY (id);


--
-- Name: raw_site raw_site_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.raw_site
    ADD CONSTRAINT raw_site_pkey PRIMARY KEY (id);


--
-- Name: segments segments_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.segments
    ADD CONSTRAINT segments_pkey PRIMARY KEY (id);


--
-- Name: split_segment split_segment_split_id_line_item_id_segment_id_key; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.split_segment
    ADD CONSTRAINT split_segment_split_id_line_item_id_segment_id_key UNIQUE (split_id, line_item_id, segment_id);


--
-- Name: splits split_split_id_line_item_id_key; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.splits
    ADD CONSTRAINT split_split_id_line_item_id_key UNIQUE (id, line_item_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: video_feed_imp_type video_feed_imp_type_pkey; Type: CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.video_feed_imp_type
    ADD CONSTRAINT video_feed_imp_type_pkey PRIMARY KEY (id);


--
-- Name: appnexus_budget_intervals_line_item_id_index; Type: INDEX; Schema: appnexus; Owner: -
--

CREATE INDEX appnexus_budget_intervals_line_item_id_index ON appnexus.budget_intervals USING btree (line_item_id);


--
-- Name: appnexus_split_segment_no_segments; Type: INDEX; Schema: appnexus; Owner: -
--

CREATE UNIQUE INDEX appnexus_split_segment_no_segments ON appnexus.split_segment USING btree (line_item_id, last_modified) WHERE ((split_id IS NULL) AND (segment_id IS NULL));


--
-- Name: operating_systems operating_system_dsp_mapping_update_trigger; Type: TRIGGER; Schema: appnexus; Owner: -
--

CREATE TRIGGER operating_system_dsp_mapping_update_trigger AFTER INSERT ON appnexus.operating_systems FOR EACH STATEMENT EXECUTE FUNCTION public.operating_system_dsp_mapping_update();


--
-- Name: mdss_segment mdss_segment_xandr_sharing_id_fkey; Type: FK CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.mdss_segment
    ADD CONSTRAINT mdss_segment_xandr_sharing_id_fkey FOREIGN KEY (xandr_sharing_id) REFERENCES appnexus.mdss_sharing(xandr_id) ON DELETE CASCADE;


--
-- Name: mdss_sharing mdss_sharing_segment_exposure_fkey; Type: FK CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.mdss_sharing
    ADD CONSTRAINT mdss_sharing_segment_exposure_fkey FOREIGN KEY (segment_exposure) REFERENCES appnexus.dict_mdss_exposure_type(id);


--
-- Name: raw_site raw_site_primary_content_category_id_fkey; Type: FK CONSTRAINT; Schema: appnexus; Owner: -
--

ALTER TABLE ONLY appnexus.raw_site
    ADD CONSTRAINT raw_site_primary_content_category_id_fkey FOREIGN KEY (primary_content_category_id) REFERENCES appnexus.raw_content_category(id);


