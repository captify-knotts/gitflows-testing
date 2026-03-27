-- =====================================================
-- C3 Database Baseline Migration - exporters_internal schema
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
-- Name: exporters_internal; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS exporters_internal;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: conversion_pixel_export_status; Type: TABLE; Schema: exporters_internal; Owner: -
--

CREATE TABLE exporters_internal.conversion_pixel_export_status (
    conversion_pixel_id integer NOT NULL,
    entity text NOT NULL,
    status text NOT NULL,
    error_reason text,
    create_dt timestamp without time zone DEFAULT now() NOT NULL,
    update_dt timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE conversion_pixel_export_status; Type: COMMENT; Schema: exporters_internal; Owner: -
--

COMMENT ON TABLE exporters_internal.conversion_pixel_export_status IS 'Used to track the status of conversion pixel export to xandr';


--
-- Name: COLUMN conversion_pixel_export_status.entity; Type: COMMENT; Schema: exporters_internal; Owner: -
--

COMMENT ON COLUMN exporters_internal.conversion_pixel_export_status.entity IS 'Conversion pixel entity (conversion-pixel or pixel-segment) which is exported';


--
-- Name: segment_export_status; Type: TABLE; Schema: exporters_internal; Owner: -
--

CREATE TABLE exporters_internal.segment_export_status (
    captify_segment_id integer NOT NULL,
    dsp_name text NOT NULL,
    status text NOT NULL,
    error_reason text,
    create_dt timestamp without time zone DEFAULT now() NOT NULL,
    update_dt timestamp without time zone DEFAULT now() NOT NULL,
    id_type public.id_type DEFAULT 'dsp_id'::public.id_type NOT NULL
);


--
-- Name: ttd_marketplace_pricing_history; Type: TABLE; Schema: exporters_internal; Owner: -
--

CREATE TABLE exporters_internal.ttd_marketplace_pricing_history (
    id integer NOT NULL,
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
-- Name: TABLE ttd_marketplace_pricing_history; Type: COMMENT; Schema: exporters_internal; Owner: -
--

COMMENT ON TABLE exporters_internal.ttd_marketplace_pricing_history IS 'Table to track the history of pricing setup on TTD marketplace';


--
-- Name: COLUMN ttd_marketplace_pricing_history.provider_element_id; Type: COMMENT; Schema: exporters_internal; Owner: -
--

COMMENT ON COLUMN exporters_internal.ttd_marketplace_pricing_history.provider_element_id IS '-217: standard category; -218: custom category';


--
-- Name: ttd_marketplace_pricing_history_id_seq; Type: SEQUENCE; Schema: exporters_internal; Owner: -
--

CREATE SEQUENCE exporters_internal.ttd_marketplace_pricing_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ttd_marketplace_pricing_history_id_seq; Type: SEQUENCE OWNED BY; Schema: exporters_internal; Owner: -
--

ALTER SEQUENCE exporters_internal.ttd_marketplace_pricing_history_id_seq OWNED BY exporters_internal.ttd_marketplace_pricing_history.id;


--
-- Name: ttd_marketplace_segment_data_element_mapping_history; Type: TABLE; Schema: exporters_internal; Owner: -
--

CREATE TABLE exporters_internal.ttd_marketplace_segment_data_element_mapping_history (
    id integer NOT NULL,
    ttd_segment_id text NOT NULL,
    data_element_id integer NOT NULL,
    create_dt timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE ttd_marketplace_segment_data_element_mapping_history; Type: COMMENT; Schema: exporters_internal; Owner: -
--

COMMENT ON TABLE exporters_internal.ttd_marketplace_segment_data_element_mapping_history IS 'Table to maintain the history of ttd segment to data element mapping';


--
-- Name: COLUMN ttd_marketplace_segment_data_element_mapping_history.data_element_id; Type: COMMENT; Schema: exporters_internal; Owner: -
--

COMMENT ON COLUMN exporters_internal.ttd_marketplace_segment_data_element_mapping_history.data_element_id IS '-217: standard category; -218: custom category';


--
-- Name: ttd_marketplace_segment_data_element_mapping_history_id_seq; Type: SEQUENCE; Schema: exporters_internal; Owner: -
--

CREATE SEQUENCE exporters_internal.ttd_marketplace_segment_data_element_mapping_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ttd_marketplace_segment_data_element_mapping_history_id_seq; Type: SEQUENCE OWNED BY; Schema: exporters_internal; Owner: -
--

ALTER SEQUENCE exporters_internal.ttd_marketplace_segment_data_element_mapping_history_id_seq OWNED BY exporters_internal.ttd_marketplace_segment_data_element_mapping_history.id;


--
-- Name: ttd_marketplace_segment_sharing_history; Type: TABLE; Schema: exporters_internal; Owner: -
--

CREATE TABLE exporters_internal.ttd_marketplace_segment_sharing_history (
    id integer NOT NULL,
    captify_segment_id integer NOT NULL,
    partner_id text NOT NULL,
    operation text NOT NULL,
    status text NOT NULL,
    error_reason text,
    create_dt timestamp without time zone DEFAULT now() NOT NULL,
    update_dt timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE ttd_marketplace_segment_sharing_history; Type: COMMENT; Schema: exporters_internal; Owner: -
--

COMMENT ON TABLE exporters_internal.ttd_marketplace_segment_sharing_history IS 'Table to track the history of segments sharing with partners on TTD marketplace';


--
-- Name: ttd_marketplace_segment_sharing_history_id_seq; Type: SEQUENCE; Schema: exporters_internal; Owner: -
--

CREATE SEQUENCE exporters_internal.ttd_marketplace_segment_sharing_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ttd_marketplace_segment_sharing_history_id_seq; Type: SEQUENCE OWNED BY; Schema: exporters_internal; Owner: -
--

ALTER SEQUENCE exporters_internal.ttd_marketplace_segment_sharing_history_id_seq OWNED BY exporters_internal.ttd_marketplace_segment_sharing_history.id;


--
-- Name: ttd_marketplace_pricing_history id; Type: DEFAULT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.ttd_marketplace_pricing_history ALTER COLUMN id SET DEFAULT nextval('exporters_internal.ttd_marketplace_pricing_history_id_seq'::regclass);


--
-- Name: ttd_marketplace_segment_data_element_mapping_history id; Type: DEFAULT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.ttd_marketplace_segment_data_element_mapping_history ALTER COLUMN id SET DEFAULT nextval('exporters_internal.ttd_marketplace_segment_data_element_mapping_history_id_seq'::regclass);


--
-- Name: ttd_marketplace_segment_sharing_history id; Type: DEFAULT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.ttd_marketplace_segment_sharing_history ALTER COLUMN id SET DEFAULT nextval('exporters_internal.ttd_marketplace_segment_sharing_history_id_seq'::regclass);


--
-- Name: conversion_pixel_export_status conversion_pixel_export_status_pkey; Type: CONSTRAINT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.conversion_pixel_export_status
    ADD CONSTRAINT conversion_pixel_export_status_pkey PRIMARY KEY (conversion_pixel_id, entity);


--
-- Name: segment_export_status segment_export_status_pkey; Type: CONSTRAINT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.segment_export_status
    ADD CONSTRAINT segment_export_status_pkey PRIMARY KEY (captify_segment_id, dsp_name, id_type);


--
-- Name: ttd_marketplace_pricing_history ttd_marketplace_pricing_history_pkey; Type: CONSTRAINT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.ttd_marketplace_pricing_history
    ADD CONSTRAINT ttd_marketplace_pricing_history_pkey PRIMARY KEY (id);


--
-- Name: ttd_marketplace_segment_data_element_mapping_history ttd_marketplace_segment_data_element_mapping_history_pkey; Type: CONSTRAINT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.ttd_marketplace_segment_data_element_mapping_history
    ADD CONSTRAINT ttd_marketplace_segment_data_element_mapping_history_pkey PRIMARY KEY (id);


--
-- Name: ttd_marketplace_segment_sharing_history ttd_marketplace_segment_sharing_history_pkey; Type: CONSTRAINT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.ttd_marketplace_segment_sharing_history
    ADD CONSTRAINT ttd_marketplace_segment_sharing_history_pkey PRIMARY KEY (id);


--
-- Name: conversion_pixel_export_status conversion_pixel_export_status_conversion_pixel_id_fkey; Type: FK CONSTRAINT; Schema: exporters_internal; Owner: -
--

ALTER TABLE ONLY exporters_internal.conversion_pixel_export_status
    ADD CONSTRAINT conversion_pixel_export_status_conversion_pixel_id_fkey FOREIGN KEY (conversion_pixel_id) REFERENCES public.conversion_pixel(id) ON DELETE CASCADE;

