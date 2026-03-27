-- =====================================================
-- C3 Database Baseline Migration - stats schema
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
-- Name: stats; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS stats;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: stats_property_device_uus_daily; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_property_device_uus_daily (
    day timestamp without time zone NOT NULL,
    mediagroup_id integer,
    property_id integer NOT NULL,
    device_type_id integer NOT NULL,
    appnexus_uus bigint NOT NULL,
    dbm_uus bigint NOT NULL
);


--
-- Name: dbm_lookups_statuses; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.dbm_lookups_statuses (
    dateandtime date NOT NULL,
    partnerid integer NOT NULL,
    entitytype character varying(24) NOT NULL,
    processedpartcount smallint DEFAULT 0 NOT NULL,
    isdbsaved smallint DEFAULT 0 NOT NULL,
    isdbsaved_dt timestamp without time zone,
    CONSTRAINT entities_const CHECK (((entitytype)::text = ANY ((ARRAY['Advertiser'::character varying, 'InsertionOrder'::character varying, 'LineItem'::character varying, 'InventorySource'::character varying, 'Creative'::character varying, 'Pixel'::character varying, 'Browser'::character varying, 'DeviceCriteria'::character varying, 'GeoLocation'::character varying, 'Language'::character varying, 'SupportedExchange'::character varying])::text[])))
);


--
-- Name: COLUMN dbm_lookups_statuses.partnerid; Type: COMMENT; Schema: stats; Owner: -
--

COMMENT ON COLUMN stats.dbm_lookups_statuses.partnerid IS '0 - public entities.
 623234 - Captify Technologies Ltd entities.
 707895 - Captify Media GMBH entities.';


--
-- Name: COLUMN dbm_lookups_statuses.entitytype; Type: COMMENT; Schema: stats; Owner: -
--

COMMENT ON COLUMN stats.dbm_lookups_statuses.entitytype IS '{Advertiser, InsertionOrder, LineItem, InventorySource, Creative, Pixel, Browser, DeviceCriteria, GeoLocation, Language, SupportedExchange}:
 Advertiser, InsertionOrder, LineItem, InventorySource, Creative, Pixel - entities of a partner. They are needed as lookup information.
 Browser, DeviceCriteria, GeoLocation, Language, SupportedExchange - public entities, common for all partners. They are needed as lookup information.';


--
-- Name: COLUMN dbm_lookups_statuses.processedpartcount; Type: COMMENT; Schema: stats; Owner: -
--

COMMENT ON COLUMN stats.dbm_lookups_statuses.processedpartcount IS '{0, 1+}:
 0 - some error has happened while processing.
 1+ - number of copied files(parts). For advTotal only 1 meaning that the advertiser was processed without any errors.';


--
-- Name: COLUMN dbm_lookups_statuses.isdbsaved; Type: COMMENT; Schema: stats; Owner: -
--

COMMENT ON COLUMN stats.dbm_lookups_statuses.isdbsaved IS 'Currently is used for the status of saving to the DB of DBM Lookup information:
-1 - Error status after the run. It is reset to zero each time before the job starts running.
 0 - The entity has not been processed yet.
 1 - The entity has been processed successfully.';


--
-- Name: property_live_date; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.property_live_date (
    property_id integer NOT NULL,
    datetime timestamp without time zone NOT NULL
);


--
-- Name: report_keywords; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.report_keywords (
    reportname character varying(50),
    is1party boolean,
    reporttype character varying(10),
    periodstartdate date,
    groupname character varying(100),
    totalkws bigint,
    totaluus integer,
    purekws bigint,
    pureukws bigint,
    purekwsuus integer,
    lastupdate timestamp without time zone
);


--
-- Name: stats_api_line_item_daily_an; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_api_line_item_daily_an (
    day timestamp without time zone,
    dsp_line_item integer,
    c3_line_item_id integer,
    impressions integer,
    viewable_imps integer,
    avg_viewability_rate double precision,
    clicks integer,
    total_conversions integer,
    gross_adv_revenue numeric(18,8),
    net_adv_revenue numeric(18,8),
    media_cost numeric(18,8),
    auction_service_fees_usd numeric(18,8),
    month integer,
    completed_views integer
);


--
-- Name: COLUMN stats_api_line_item_daily_an.gross_adv_revenue; Type: COMMENT; Schema: stats; Owner: -
--

COMMENT ON COLUMN stats.stats_api_line_item_daily_an.gross_adv_revenue IS 'In case of CPCV line item, revenue coming from DSP is replaced by cpm * completed_view';


--
-- Name: COLUMN stats_api_line_item_daily_an.net_adv_revenue; Type: COMMENT; Schema: stats; Owner: -
--

COMMENT ON COLUMN stats.stats_api_line_item_daily_an.net_adv_revenue IS 'In case of CPCV line item, revenue coming from DSP is replaced by cpm * completed_view';


--
-- Name: stats_api_line_item_daily_dbm; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_api_line_item_daily_dbm (
    day timestamp without time zone,
    dsp_line_item integer,
    c3_line_item_id integer,
    impressions integer,
    viewable_imps integer,
    avg_viewability_rate double precision,
    clicks integer,
    total_conversions integer,
    gross_adv_revenue numeric(18,8),
    net_adv_revenue numeric(18,8),
    media_cost numeric(18,8),
    month integer,
    completed_views integer
);


--
-- Name: stats_api_line_item_daily_ttd; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_api_line_item_daily_ttd (
    day timestamp without time zone NOT NULL,
    dsp_line_item character varying(10) NOT NULL,
    c3_line_item_id integer,
    impressions integer,
    viewable_imps integer,
    avg_viewability_rate double precision,
    clicks integer,
    total_conversions integer,
    gross_adv_revenue numeric(18,8),
    net_adv_revenue numeric(18,8),
    media_cost numeric(18,8),
    month integer NOT NULL,
    completed_views integer,
    auction_service_fees_adv_curr numeric(18,8)
);


--
-- Name: stats_api_line_item_daily; Type: VIEW; Schema: stats; Owner: -
--

CREATE VIEW stats.stats_api_line_item_daily AS
 SELECT stats_api_line_item_daily_an.day,
    (stats_api_line_item_daily_an.dsp_line_item)::character varying AS dsp_line_item,
    stats_api_line_item_daily_an.c3_line_item_id,
    stats_api_line_item_daily_an.impressions,
    stats_api_line_item_daily_an.viewable_imps,
    stats_api_line_item_daily_an.avg_viewability_rate,
    stats_api_line_item_daily_an.clicks,
    stats_api_line_item_daily_an.total_conversions,
    stats_api_line_item_daily_an.gross_adv_revenue,
    stats_api_line_item_daily_an.net_adv_revenue,
    stats_api_line_item_daily_an.media_cost,
    stats_api_line_item_daily_an.auction_service_fees_usd,
    0.0 AS auction_service_fees_adv_curr,
    1 AS dsp_source_id,
    stats_api_line_item_daily_an.completed_views
   FROM stats.stats_api_line_item_daily_an
UNION ALL
 SELECT stats_api_line_item_daily_dbm.day,
    (stats_api_line_item_daily_dbm.dsp_line_item)::character varying AS dsp_line_item,
    stats_api_line_item_daily_dbm.c3_line_item_id,
    stats_api_line_item_daily_dbm.impressions,
    stats_api_line_item_daily_dbm.viewable_imps,
    stats_api_line_item_daily_dbm.avg_viewability_rate,
    stats_api_line_item_daily_dbm.clicks,
    stats_api_line_item_daily_dbm.total_conversions,
    stats_api_line_item_daily_dbm.gross_adv_revenue,
    stats_api_line_item_daily_dbm.net_adv_revenue,
    stats_api_line_item_daily_dbm.media_cost,
    0.0 AS auction_service_fees_usd,
    0.0 AS auction_service_fees_adv_curr,
    2 AS dsp_source_id,
    stats_api_line_item_daily_dbm.completed_views
   FROM stats.stats_api_line_item_daily_dbm
UNION ALL
 SELECT stats_api_line_item_daily_ttd.day,
    stats_api_line_item_daily_ttd.dsp_line_item,
    stats_api_line_item_daily_ttd.c3_line_item_id,
    stats_api_line_item_daily_ttd.impressions,
    stats_api_line_item_daily_ttd.viewable_imps,
    stats_api_line_item_daily_ttd.avg_viewability_rate,
    stats_api_line_item_daily_ttd.clicks,
    stats_api_line_item_daily_ttd.total_conversions,
    stats_api_line_item_daily_ttd.gross_adv_revenue,
    stats_api_line_item_daily_ttd.net_adv_revenue,
    stats_api_line_item_daily_ttd.media_cost,
    0.0 AS auction_service_fees_usd,
    stats_api_line_item_daily_ttd.auction_service_fees_adv_curr,
    3 AS dsp_source_id,
    stats_api_line_item_daily_ttd.completed_views
   FROM stats.stats_api_line_item_daily_ttd;


--
-- Name: stats_api_video_data_dbm; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_api_video_data_dbm (
    month integer,
    day timestamp without time zone,
    dsp_line_item integer,
    c3_line_item_id integer,
    country text,
    region_id integer,
    creative_id bigint,
    device_type text,
    impressions integer,
    not_measurable_imps integer,
    measurable_imps integer,
    viewable_imps integer,
    avg_viewability_rate double precision,
    clicks integer,
    total_conversions integer,
    gross_adv_revenue numeric(18,8),
    net_adv_revenue numeric(18,8),
    media_cost numeric(18,8),
    first_quartile_video_views integer,
    midpoint_video_views integer,
    third_quartile_video_views integer,
    completed_views integer
);


--
-- Name: stats_audience_planner; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_audience_planner (
    segment_id integer,
    dsp_source_id smallint NOT NULL,
    searches bigint,
    uus bigint,
    geocountry character varying(2)
);


--
-- Name: stats_conversion_pixel_fires; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_conversion_pixel_fires (
    appnexus_pixel_id bigint,
    conversion_count bigint,
    first_fired_dt timestamp without time zone NOT NULL,
    http_referer text DEFAULT ''::text,
    create_dt timestamp without time zone NOT NULL
);


--
-- Name: stats_creative_delivery; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_creative_delivery (
    day date NOT NULL,
    line_item_id integer,
    creative_id integer,
    dsp_source_id smallint NOT NULL,
    impressions integer,
    clicks integer,
    conversions integer,
    revenue numeric(18,8),
    ctr numeric(18,8),
    cpa numeric(18,8),
    strategy_id integer,
    net_revenue_adv_curr numeric(18,8),
    net_revenue_gbp numeric(18,8),
    total_costs_adv_curr numeric(18,8),
    total_costs_gbp numeric(18,8)
);


--
-- Name: stats_dsp_daily_processed_days; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_dsp_daily_processed_days (
    day date,
    table_name character varying(64),
    dsp_source_id smallint,
    files_hash integer,
    insert_date timestamp without time zone DEFAULT now()
);


--
-- Name: stats_line_item_dsp_property_daily; Type: TABLE; Schema: stats; Owner: -
--

CREATE TABLE stats.stats_line_item_dsp_property_daily (
    day date,
    advertiser_id integer,
    insertion_order_id integer,
    line_item_id integer,
    budget_interval_id integer,
    property_id integer,
    dsp_source_id smallint NOT NULL,
    device_type character varying(20),
    impressions integer,
    clicks integer,
    conversions integer,
    gross_revenue_adv_curr numeric(18,8),
    gross_revenue_gbp numeric(18,8),
    net_revenue_adv_curr numeric(18,8),
    net_revenue_gbp numeric(18,8),
    media_costs_dsp_curr numeric(18,8),
    media_costs_gbp numeric(18,8),
    data_costs_mediagroup_curr numeric(18,8),
    data_costs_gbp numeric(18,8),
    agency_rebate_adv_curr numeric(18,8),
    agency_rebate_gbp numeric(18,8),
    auction_service_fees_dsp_curr numeric(18,8),
    auction_service_fees_gbp numeric(18,8),
    total_costs_adv_curr numeric(18,8),
    total_costs_gbp numeric(18,8),
    ad_serving_fees_adv_curr numeric(18,8),
    ad_serving_fees_gbp numeric(18,8),
    viewable_impressions integer,
    measurable_impressions integer,
    device_type_id integer,
    legal_entity_day date,
    third_party_costs_gbp numeric(18,8)
);


--
-- Name: stats_property_device_uus_daily property_device_per_day; Type: CONSTRAINT; Schema: stats; Owner: -
--

ALTER TABLE ONLY stats.stats_property_device_uus_daily
    ADD CONSTRAINT property_device_per_day UNIQUE (day, property_id, device_type_id);


--
-- Name: property_live_date property_live_date_pkey; Type: CONSTRAINT; Schema: stats; Owner: -
--

ALTER TABLE ONLY stats.property_live_date
    ADD CONSTRAINT property_live_date_pkey PRIMARY KEY (property_id);


--
-- Name: dbm_lookups_statuses unique_const; Type: CONSTRAINT; Schema: stats; Owner: -
--

ALTER TABLE ONLY stats.dbm_lookups_statuses
    ADD CONSTRAINT unique_const UNIQUE (dateandtime, partnerid, entitytype);


--
-- Name: stats_conversion_pixel_fires_appnexus_pixel_id_idx; Type: INDEX; Schema: stats; Owner: -
--

CREATE UNIQUE INDEX stats_conversion_pixel_fires_appnexus_pixel_id_idx ON stats.stats_conversion_pixel_fires USING btree (appnexus_pixel_id);


--
-- Name: stats_creative_delivery_ci_idx; Type: INDEX; Schema: stats; Owner: -
--

CREATE INDEX stats_creative_delivery_ci_idx ON stats.stats_creative_delivery USING btree (creative_id);


--
-- Name: stats_creative_delivery_li_idx; Type: INDEX; Schema: stats; Owner: -
--

CREATE INDEX stats_creative_delivery_li_idx ON stats.stats_creative_delivery USING btree (line_item_id);


--
-- Name: stats_line_item_dsp_property_day_bi_idx; Type: INDEX; Schema: stats; Owner: -
--

CREATE INDEX stats_line_item_dsp_property_day_bi_idx ON stats.stats_line_item_dsp_property_daily USING btree (budget_interval_id);


--
-- Name: stats_line_item_dsp_property_day_idx; Type: INDEX; Schema: stats; Owner: -
--

CREATE INDEX stats_line_item_dsp_property_day_idx ON stats.stats_line_item_dsp_property_daily USING brin (day);


--
-- Name: stats_line_item_dsp_property_day_io_idx; Type: INDEX; Schema: stats; Owner: -
--

CREATE INDEX stats_line_item_dsp_property_day_io_idx ON stats.stats_line_item_dsp_property_daily USING btree (insertion_order_id);


--
-- Name: stats_line_item_dsp_property_day_li_idx; Type: INDEX; Schema: stats; Owner: -
--

CREATE INDEX stats_line_item_dsp_property_day_li_idx ON stats.stats_line_item_dsp_property_daily USING btree (line_item_id);

