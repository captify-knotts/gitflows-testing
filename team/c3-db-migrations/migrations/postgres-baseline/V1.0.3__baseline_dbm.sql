-- =====================================================
-- C3 Database Baseline Migration - dbm schema
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
-- Name: dbm; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS dbm;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: advertiser; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.advertiser (
    id bigint NOT NULL,
    name text NOT NULL,
    active boolean,
    integration_code text NOT NULL,
    partner_id bigint NOT NULL,
    currency_code character varying(3) NOT NULL,
    timezone_code character varying(100) NOT NULL,
    landing_page_url text,
    dcm_configuration smallint NOT NULL,
    enable_oba_tags boolean NOT NULL,
    oba_custom_company_id integer,
    oba_custom_notice_id integer,
    hash_code integer NOT NULL
);


--
-- Name: browser; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.browser (
    id bigint NOT NULL,
    name text NOT NULL,
    is_mobile boolean NOT NULL,
    hash_code integer NOT NULL
);


--
-- Name: creative; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.creative (
    id bigint NOT NULL,
    name text NOT NULL,
    active boolean,
    integration_code text NOT NULL,
    advertiser_id bigint NOT NULL,
    dcm_placement_id bigint NOT NULL,
    width_pixels integer NOT NULL,
    height_pixels integer NOT NULL,
    creative_type integer NOT NULL,
    hash_code integer NOT NULL
);


--
-- Name: device_criteria; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.device_criteria (
    id bigint NOT NULL,
    name text NOT NULL,
    criteria_type smallint NOT NULL,
    is_mobile boolean NOT NULL,
    mobile_brand_name text,
    mobile_model_name text,
    mobile_make_model_id bigint,
    operating_system_id bigint,
    device_type integer,
    hash_code integer NOT NULL
);


--
-- Name: geolocation; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.geolocation (
    id bigint NOT NULL,
    country_code character varying(2) NOT NULL,
    region_code character varying(16),
    city_name character varying(100),
    postal_code character varying(35),
    dma_code integer,
    hash_code integer NOT NULL
);


--
-- Name: insertion_order; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.insertion_order (
    id bigint NOT NULL,
    name text NOT NULL,
    active boolean,
    integration_code text NOT NULL,
    advertiser_id bigint NOT NULL,
    start_time_usec timestamp without time zone,
    end_time_usec timestamp without time zone,
    max_impressions bigint,
    max_spend_advertiser_micros bigint,
    pacing_type smallint NOT NULL,
    pacing_max_impressions bigint,
    pacing_max_spend_advertiser_micros bigint,
    pacing_distribution bigint,
    fr_cap_max_impressions bigint,
    fr_cap_time_unit smallint,
    fr_cap_time_range integer,
    hash_code integer NOT NULL
);


--
-- Name: inventory_source; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.inventory_source (
    id bigint NOT NULL,
    unclassified boolean NOT NULL,
    inventory_name text,
    exchange_id bigint NOT NULL,
    external_id character varying(100),
    min_cpm_micros bigint,
    min_cpm_currency_code character varying(3),
    hash_code integer NOT NULL
);


--
-- Name: language; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.language (
    id bigint NOT NULL,
    code character varying(5) NOT NULL
);


--
-- Name: line_item; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.line_item (
    id bigint NOT NULL,
    name text NOT NULL,
    active boolean,
    integration_code text NOT NULL,
    line_item_type smallint NOT NULL,
    insertion_order_id bigint NOT NULL,
    max_cpm_advertiser_micros bigint NOT NULL,
    performance_goal smallint NOT NULL,
    goal_advertiser_micros bigint,
    start_time_usec timestamp without time zone,
    end_time_usec timestamp without time zone,
    max_impressions bigint,
    max_spend_advertiser_micros bigint,
    pacing_type smallint NOT NULL,
    pacing_max_impressions bigint,
    pacing_max_spend_advertiser_micros bigint,
    pacing_distribution bigint,
    fr_cap_max_impressions bigint,
    fr_cap_time_unit smallint,
    fr_cap_time_range integer,
    hash_code integer NOT NULL
);


--
-- Name: line_item_cost_tracking_pixels; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.line_item_cost_tracking_pixels (
    line_item_id bigint NOT NULL,
    pixel_id bigint NOT NULL,
    view_window_minutes integer NOT NULL,
    click_window_minutes integer NOT NULL
);


--
-- Name: line_item_creative; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.line_item_creative (
    line_item_id bigint NOT NULL,
    creative_id bigint NOT NULL
);


--
-- Name: line_item_segment; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.line_item_segment (
    line_item_id bigint,
    segment_id bigint NOT NULL,
    parameter character varying(128) NOT NULL,
    union_order_number smallint NOT NULL,
    excluded boolean NOT NULL
);


--
-- Name: pixel; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.pixel (
    id bigint NOT NULL,
    name text NOT NULL,
    active boolean,
    integration_code text NOT NULL,
    advertiser_id bigint NOT NULL,
    partner_id bigint NOT NULL,
    dcm_floodlight_id bigint NOT NULL,
    allow_google_redirect boolean NOT NULL,
    allow_rm_redirect boolean NOT NULL,
    remarketing_enabled boolean,
    is_secure boolean,
    hash_code integer NOT NULL
);


--
-- Name: supported_exchange; Type: TABLE; Schema: dbm; Owner: -
--

CREATE TABLE dbm.supported_exchange (
    id bigint NOT NULL,
    inventory_name text NOT NULL,
    hash_code integer NOT NULL
);


--
-- Name: advertiser advertiser_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.advertiser
    ADD CONSTRAINT advertiser_pkey PRIMARY KEY (id);


--
-- Name: browser browser_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.browser
    ADD CONSTRAINT browser_pkey PRIMARY KEY (id);


--
-- Name: creative creative_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.creative
    ADD CONSTRAINT creative_pkey PRIMARY KEY (id);


--
-- Name: line_item_cost_tracking_pixels dbm_dbm_line_item_cost_tracking_pixels_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.line_item_cost_tracking_pixels
    ADD CONSTRAINT dbm_dbm_line_item_cost_tracking_pixels_pkey PRIMARY KEY (line_item_id, pixel_id);


--
-- Name: line_item_creative dbm_dbm_line_item_creative_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.line_item_creative
    ADD CONSTRAINT dbm_dbm_line_item_creative_pkey PRIMARY KEY (line_item_id, creative_id);


--
-- Name: device_criteria device_criteria_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.device_criteria
    ADD CONSTRAINT device_criteria_pkey PRIMARY KEY (id);


--
-- Name: geolocation geolocation_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.geolocation
    ADD CONSTRAINT geolocation_pkey PRIMARY KEY (id);


--
-- Name: insertion_order insertion_order_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.insertion_order
    ADD CONSTRAINT insertion_order_pkey PRIMARY KEY (id);


--
-- Name: language language_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);


--
-- Name: line_item line_item_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.line_item
    ADD CONSTRAINT line_item_pkey PRIMARY KEY (id);


--
-- Name: pixel pixel_pkey; Type: CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.pixel
    ADD CONSTRAINT pixel_pkey PRIMARY KEY (id);


--
-- Name: line_item_cost_tracking_pixels line_item_cost_tracking_pixels_line_item_id_fkey; Type: FK CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.line_item_cost_tracking_pixels
    ADD CONSTRAINT line_item_cost_tracking_pixels_line_item_id_fkey FOREIGN KEY (line_item_id) REFERENCES dbm.line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: line_item_creative line_item_creative_line_item_id_fkey; Type: FK CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.line_item_creative
    ADD CONSTRAINT line_item_creative_line_item_id_fkey FOREIGN KEY (line_item_id) REFERENCES dbm.line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: line_item_segment line_item_segment_line_item_id_fkey; Type: FK CONSTRAINT; Schema: dbm; Owner: -
--

ALTER TABLE ONLY dbm.line_item_segment
    ADD CONSTRAINT line_item_segment_line_item_id_fkey FOREIGN KEY (line_item_id) REFERENCES dbm.line_item(id) ON UPDATE CASCADE ON DELETE CASCADE;

