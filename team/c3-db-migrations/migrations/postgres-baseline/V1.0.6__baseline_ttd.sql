-- =====================================================
-- C3 Database Baseline Migration - ttd schema
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
-- Name: ttd; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS ttd;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ad_formats; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.ad_formats (
    id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    width integer NOT NULL,
    height integer NOT NULL,
    is_display_rtb_eligible boolean NOT NULL,
    inventory_type character varying(16) NOT NULL
);


--
-- Name: raw_ad_groups; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.raw_ad_groups (
    id character varying(256) NOT NULL,
    campaign_id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(2000),
    is_enabled boolean NOT NULL,
    is_high_fill_rate boolean NOT NULL,
    rtb_attributes_json json,
    high_fill_attributes_json json,
    created_at_utc timestamp without time zone,
    are_future_koa_features_enabled boolean NOT NULL,
    predictive_clearing_enabled boolean NOT NULL,
    use_identity_alliance boolean NOT NULL
);


--
-- Name: ad_group_rtb_attributes; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.ad_group_rtb_attributes AS
 SELECT expanded.ad_group_id,
    expanded.campaign_id,
    (expanded.base_bid_cmp ->> 'Amount'::text) AS base_bid_cpm_amount,
    (expanded.base_bid_cmp ->> 'CurrencyCode'::text) AS base_bid_cpm_currency_code,
    (expanded.max_bid_cpm ->> 'Amount'::text) AS max_bid_cpm_amount,
    (expanded.max_bid_cpm ->> 'CurrencyCode'::text) AS max_bid_cpm_currency_code,
    expanded.is_use_clicks_as_conversions_enabled,
    expanded.is_use_secondary_conversions_enabled,
    expanded.koa_optimizations_version,
    expanded.deprecate_auto_opt_switch,
    expanded.dimensional_bidding_auto_optimization_settings
   FROM ( SELECT a.id AS ad_group_id,
            a.campaign_id,
            (a.rtb_attributes_json -> 'BaseBidCPM'::text) AS base_bid_cmp,
            (a.rtb_attributes_json -> 'MaxBidCPM'::text) AS max_bid_cpm,
            (a.rtb_attributes_json ->> 'IsUseClicksAsConversionsEnabled'::text) AS is_use_clicks_as_conversions_enabled,
            (a.rtb_attributes_json ->> 'IsUseSecondaryConversionsEnabled'::text) AS is_use_secondary_conversions_enabled,
            (a.rtb_attributes_json ->> 'KoaOptimizationsVersion'::text) AS koa_optimizations_version,
            (a.rtb_attributes_json ->> 'DeprecateAutoOptSwitch'::text) AS deprecate_auto_opt_switch,
            array_to_string(ARRAY( SELECT json_array_elements_text(json_array_elements((a.rtb_attributes_json -> 'DimensionalBiddingAutoOptimizationSettings'::text))) AS json_array_elements_text), ','::text) AS dimensional_bidding_auto_optimization_settings
           FROM ttd.raw_ad_groups a) expanded;


--
-- Name: ad_group_rtb_attributes_audience_targeting; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.ad_group_rtb_attributes_audience_targeting AS
 SELECT (expanded.val ->> 'AudienceExcluderEnabled'::text) AS audience_excluder_enabled,
    (expanded.val ->> 'AudienceRetargetingEnabled'::text) AS audience_retargeting_enabled,
    ((expanded.val -> 'AudienceRetargetingSettings'::text) ->> 'CustomizeRetargetingAudience'::text) AS audience_retargeting_settings_customize_retargeting_audience,
    array_to_string(ARRAY( SELECT json_array_elements_text(((expanded.val -> 'AudienceRetargetingSettings'::text) -> 'FirstPartyDataIds'::text)) AS json_array_elements_text), ','::text) AS audience_retargeting_settings_first_party_data_ids,
    ((expanded.val -> 'AudienceExcluderFee'::text) ->> 'PercentOfMediaCostRate'::text) AS audience_excluder_fee_percent_of_media_cost_rate,
    ((expanded.val -> 'AudienceExcluderFee'::text) ->> 'PercentOfDataCostRate'::text) AS audience_excluder_fee_percent_of_data_cost_rate,
    (((expanded.val -> 'AudienceExcluderFee'::text) -> 'CPMRate'::text) ->> 'Amount'::text) AS audience_excluder_fee_cpm_rate_amount,
    (((expanded.val -> 'AudienceExcluderFee'::text) -> 'CPMRate'::text) ->> 'CurrencyCode'::text) AS audience_excluder_fee_cpm_rate_currency_code,
    (((expanded.val -> 'AudienceExcluderFee'::text) -> 'CPMRateInAdvertiserCurrency'::text) ->> 'Amount'::text) AS audience_excluder_fee_cpm_rate_in_advertiser_currency_amount,
    (((expanded.val -> 'AudienceExcluderFee'::text) -> 'CPMRateInAdvertiserCurrency'::text) ->> 'CurrencyCode'::text) AS audience_excluder_fee_cpm_rate_in_advertiser_currency_currency_,
    (((expanded.val -> 'AudienceExcluderFee'::text) -> 'CPCRate'::text) ->> 'Amount'::text) AS audience_excluder_fee_cpc_rate_amount,
    (((expanded.val -> 'AudienceExcluderFee'::text) -> 'CPCRate'::text) ->> 'CurrencyCode'::text) AS audience_excluder_fee_cpc_rate_currency_code,
    (((expanded.val -> 'AudienceExcluderFee'::text) -> 'CPCRateInAdvertiserCurrency'::text) ->> 'Amount'::text) AS audience_excluder_fee_cpc_rate_in_advertiser_currency_amount,
    (((expanded.val -> 'AudienceExcluderFee'::text) -> 'CPCRateInAdvertiserCurrency'::text) ->> 'CurrencyCode'::text) AS audience_excluder_fee_cpc_rate_in_advertiser_currency_currency_,
    (expanded.val ->> 'TargetTrackableUsersEnabled'::text) AS target_trackable_users_enabled,
    (expanded.val ->> 'TargetDemographicSettingsEnabled'::text) AS target_demographic_settings_enabled,
    ((expanded.val -> 'TargetDemographicSettings'::text) ->> 'DataRateType'::text) AS target_demographic_settings_dataratetype,
    ((expanded.val -> 'TargetDemographicSettings'::text) ->> 'CountryCodesample'::text) AS target_demographic_settings_country_codesample,
    ((expanded.val -> 'TargetDemographicSettings'::text) ->> 'Gender'::text) AS target_demographic_settings_gender,
    ((expanded.val -> 'TargetDemographicSettings'::text) ->> 'StartAge'::text) AS target_demographic_settings_start_age,
    ((expanded.val -> 'TargetDemographicSettings'::text) ->> 'EndAge'::text) AS target_demographic_settings_end_age,
    (expanded.val ->> 'TargetInterestSettingsEnabled'::text) AS target_interest_settings_enabled,
    ((expanded.val -> 'TargetInterestSettings'::text) ->> 'CategoryId'::text) AS target_interest_settings_category_id,
    ((expanded.val -> 'TargetInterestSettings'::text) ->> 'CategoryName'::text) AS target_interest_settings_caregory_name,
    ((expanded.val -> 'TargetTrackableUsersFee'::text) ->> 'PercentOfMediaCostRate'::text) AS target_trackable_users_fee_percent_of_media_cost_rate,
    ((expanded.val -> 'TargetTrackableUsersFee'::text) ->> 'PercentOfDataCostRate'::text) AS target_trackable_users_fee_percent_of_data_cost_rate,
    (((expanded.val -> 'TargetTrackableUsersFee'::text) -> 'CPMRate'::text) ->> 'Amount'::text) AS target_trackable_users_fee_cpm_rate_amount,
    (((expanded.val -> 'TargetTrackableUsersFee'::text) -> 'CPMRate'::text) ->> 'CurrencyCode'::text) AS target_trackable_users_fee_cpm_rate_currency_code,
    (((expanded.val -> 'TargetTrackableUsersFee'::text) -> 'CPMRateInAdvertiserCurrency'::text) ->> 'Amount'::text) AS target_trackable_users_fee_cpm_rate_in_advertiser_currency_amou,
    (((expanded.val -> 'TargetTrackableUsersFee'::text) -> 'CPMRateInAdvertiserCurrency'::text) ->> 'CurrencyCode'::text) AS target_trackable_users_fee_cpm_rate_in_advertiser_currency_code,
    (((expanded.val -> 'TargetTrackableUsersFee'::text) -> 'CPCRate'::text) ->> 'Amount'::text) AS target_trackable_users_fee_cpc_rate_amount,
    (((expanded.val -> 'TargetTrackableUsersFee'::text) -> 'CPCRate'::text) ->> 'CurrencyCode'::text) AS target_trackable_users_fee_cpc_rate_currency_code,
    (((expanded.val -> 'TargetTrackableUsersFee'::text) -> 'CPCRateInAdvertiserCurrency'::text) ->> 'Amount'::text) AS target_trackable_users_fee_cpc_rate_in_advertiser_currency_amou,
    (((expanded.val -> 'TargetTrackableUsersFee'::text) -> 'CPCRateInAdvertiserCurrency'::text) ->> 'CurrencyCode'::text) AS target_trackable_users_fee_cpc_rate_in_advertiser_currency_curr,
    (expanded.val ->> 'CrossDeviceVendorListForAudience'::text) AS cross_device_vendor_list_for_audience,
    (expanded.val ->> 'AudienceId'::text) AS audience_id,
    (expanded.val ->> 'RecencyExclusionWindowInMinutes'::text) AS recency_exclusion_window_in_minutes,
    (expanded.val ->> 'AudiencePredictorEnabled'::text) AS audience_predictor_enabled
   FROM ( SELECT (raw_ad_groups.rtb_attributes_json -> 'AudienceTargeting'::text) AS val
           FROM ttd.raw_ad_groups) expanded;


--
-- Name: ad_group_rtb_attributes_budget_settings; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.ad_group_rtb_attributes_budget_settings AS
 SELECT expanded.ad_group_id,
    expanded.campaign_id,
    ((expanded.val -> 'Budget'::text) ->> 'Amount'::text) AS budget_amount,
    ((expanded.val -> 'Budget'::text) ->> 'CurrencyCode'::text) AS budget_currency_code,
    (expanded.val -> 'BudgetInImpressions'::text) AS budget_in_impressions,
    ((expanded.val -> 'DailyBudget'::text) ->> 'Amount'::text) AS daily_budget_amount,
    ((expanded.val -> 'DailyBudget'::text) ->> 'CurrencyCode'::text) AS daily_budget_currency_code,
    (expanded.val -> 'DailyBudgetInImpressions'::text) AS daily_budget_in_impressions,
    (expanded.val -> 'PacingEnabled'::text) AS pacing_enabled,
    (expanded.val -> 'PacingMode'::text) AS pacing_mode,
    (expanded.val -> 'AutoAllocatorPriority'::text) AS auto_allocator_priority
   FROM ( SELECT raw_ad_groups.id AS ad_group_id,
            raw_ad_groups.campaign_id,
            (raw_ad_groups.rtb_attributes_json -> 'BudgetSettings'::text) AS val
           FROM ttd.raw_ad_groups) expanded;


--
-- Name: ad_group_rtb_attributes_campaign_creative; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.ad_group_rtb_attributes_campaign_creative AS
 SELECT raw_ad_groups.id AS ad_group_id,
    raw_ad_groups.campaign_id,
    json_array_elements_text((raw_ad_groups.rtb_attributes_json -> 'CreativeIds'::text)) AS creative_id
   FROM ttd.raw_ad_groups;


--
-- Name: ad_group_rtb_attributes_contract_targeting; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.ad_group_rtb_attributes_contract_targeting AS
 SELECT (expanded.val ->> 'AllowOpenMarketBiddingWhenTargetingContracts'::text) AS allow_open_market_bidding_when_targeting_contracts,
    (expanded.val ->> 'UseContractFloorPriceAsBaseBid'::text) AS use_contract_floor_price_as_base_bid,
    (expanded.val ->> 'ContractFloorPricePercentageIncrease'::text) AS contract_floor_price_percentage_increase,
    array_to_string(ARRAY( SELECT json_array_elements((expanded.val -> 'DeliveryProfileAdjustments'::text)) AS json_array_elements), ','::text) AS delivery_profile_adjustments
   FROM ( SELECT (raw_ad_groups.rtb_attributes_json -> 'ContractTargeting'::text) AS val
           FROM ttd.raw_ad_groups) expanded;


--
-- Name: ad_groups; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.ad_groups AS
 SELECT raw_ad_groups.id,
    raw_ad_groups.campaign_id,
    raw_ad_groups.name,
    raw_ad_groups.description,
    raw_ad_groups.is_enabled,
    raw_ad_groups.is_high_fill_rate,
    raw_ad_groups.created_at_utc,
    raw_ad_groups.are_future_koa_features_enabled,
    raw_ad_groups.predictive_clearing_enabled,
    raw_ad_groups.use_identity_alliance
   FROM ttd.raw_ad_groups;


--
-- Name: additional_fees; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.additional_fees (
    advertiser_id character varying(256) NOT NULL,
    owner_type character varying(256) NOT NULL,
    owner_id character varying(256) NOT NULL,
    fee_type character varying(256) NOT NULL,
    description character varying(256),
    amount numeric NOT NULL,
    start_date_utc timestamp without time zone NOT NULL
);


--
-- Name: ads_txt_seller_types; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.ads_txt_seller_types (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: advertisers; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.advertisers (
    id character varying(256) NOT NULL,
    partner_id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(2000),
    currency_code character varying(3) NOT NULL,
    attribution_click_lookback_window_in_seconds integer NOT NULL,
    attribution_impression_lookback_window_in_seconds integer NOT NULL,
    click_dedup_window_in_seconds integer NOT NULL,
    conversion_dedup_window_in_seconds integer NOT NULL,
    industry_category_id bigint,
    keywords character varying(4000)
);


--
-- Name: audience_excluded_data_groups; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.audience_excluded_data_groups (
    audience_id character varying(256) NOT NULL,
    data_group_id character varying(256) NOT NULL
);


--
-- Name: audience_included_data_groups; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.audience_included_data_groups (
    audience_id character varying(256) NOT NULL,
    data_group_id character varying(256) NOT NULL
);


--
-- Name: audiences; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.audiences (
    id character varying(256) NOT NULL,
    advertiser_id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(2000)
);


--
-- Name: browsers; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.browsers (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: raw_campaigns; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.raw_campaigns (
    id character varying(256) NOT NULL,
    advertiser_id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(2000),
    campaign_type character varying(64) NOT NULL,
    budget_amount numeric NOT NULL,
    budget_currency_code character varying(256) NOT NULL,
    budget_in_impressions bigint,
    start_date timestamp without time zone NOT NULL,
    end_date timestamp without time zone,
    auto_allocator_enabled boolean NOT NULL,
    auto_prioritization_enabled boolean NOT NULL,
    pacing_mode character varying(256) NOT NULL,
    custom_cpa_type character varying(256) NOT NULL,
    custom_cpa_click_weight numeric,
    custom_cpa_view_through_weight numeric,
    current_and_future_additional_fee_cards_json json NOT NULL,
    campaign_conversion_reporting_columns_json json NOT NULL,
    created_at_utc timestamp without time zone,
    campaign_flights_json json NOT NULL
);


--
-- Name: campaign_conversion_reporting_columns; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.campaign_conversion_reporting_columns AS
 SELECT expanded.campaign_id,
    expanded.advertiser_id,
    (expanded.val ->> 'IncludeInCustomCPA'::text) AS include_in_custom_cpa,
    (expanded.val ->> 'TrackingTagId'::text) AS tracking_tag_id,
    (expanded.val ->> 'TrackingTagName'::text) AS tracking_tag_name,
    (expanded.val ->> 'ReportingColumnId'::text) AS reporting_column_id,
    (expanded.val ->> 'CrossDeviceAttributionModelId'::text) AS cross_device_attribution_model_id,
    (expanded.val ->> 'Weight'::text) AS weight
   FROM ( SELECT raw_campaigns.id AS campaign_id,
            raw_campaigns.advertiser_id,
            json_array_elements(raw_campaigns.campaign_conversion_reporting_columns_json) AS val
           FROM ttd.raw_campaigns) expanded;


--
-- Name: campaign_current_and_future_additional_fee_cards; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.campaign_current_and_future_additional_fee_cards AS
 SELECT expanded2.campaign_id,
    expanded2.advertiser_id,
    expanded2.start_date_utc,
    expanded2.owner_id,
    expanded2.owner_type,
    (expanded2.fees ->> 'Amount'::text) AS amount,
    (expanded2.fees ->> 'Description'::text) AS description,
    (expanded2.fees ->> 'FeeType'::text) AS fee_type
   FROM ( SELECT expanded1.campaign_id,
            expanded1.advertiser_id,
            (expanded1.val ->> 'StartDateUtc'::text) AS start_date_utc,
            (expanded1.val ->> 'OwnerId'::text) AS owner_id,
            (expanded1.val ->> 'OwnerType'::text) AS owner_type,
            json_array_elements((expanded1.val -> 'Fees'::text)) AS fees
           FROM ( SELECT c.id AS campaign_id,
                    c.advertiser_id,
                    json_array_elements(c.current_and_future_additional_fee_cards_json) AS val
                   FROM ttd.raw_campaigns c) expanded1) expanded2;


--
-- Name: campaign_flights; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.campaign_flights AS
 SELECT expanded.advertiser_id,
    ((expanded.val ->> 'CampaignFlightId'::text))::bigint AS campaign_flight_id,
    (expanded.val ->> 'CampaignId'::text) AS campaign_id,
    ((expanded.val ->> 'StartDateInclusiveUTC'::text))::timestamp without time zone AS start_date_inclusive_utc,
    ((expanded.val ->> 'EndDateExclusiveUTC'::text))::timestamp without time zone AS end_date_exclusive_utc,
    (expanded.val ->> 'BudgetInAdvertiserCurrency'::text) AS budget_in_advertiser_currency,
    (expanded.val ->> 'BudgetInImpressions'::text) AS budget_in_impressions,
    (expanded.val ->> 'DailyTargetInAdvertiserCurrency'::text) AS daily_target_in_advertiser_currency,
    (expanded.val ->> 'DailyTargetInImpressions'::text) AS daily_target_in_impressions
   FROM ( SELECT c.id AS campaign_id,
            c.advertiser_id,
            json_array_elements(c.campaign_flights_json) AS val
           FROM ttd.raw_campaigns c) expanded;


--
-- Name: campaigns; Type: VIEW; Schema: ttd; Owner: -
--

CREATE VIEW ttd.campaigns AS
 SELECT raw_campaigns.id,
    raw_campaigns.advertiser_id,
    raw_campaigns.name,
    raw_campaigns.description,
    raw_campaigns.campaign_type,
    raw_campaigns.budget_amount,
    raw_campaigns.budget_currency_code,
    raw_campaigns.budget_in_impressions,
    raw_campaigns.start_date,
    raw_campaigns.end_date,
    raw_campaigns.auto_allocator_enabled,
    raw_campaigns.auto_prioritization_enabled,
    raw_campaigns.pacing_mode,
    raw_campaigns.custom_cpa_type,
    raw_campaigns.custom_cpa_click_weight,
    raw_campaigns.custom_cpa_view_through_weight,
    raw_campaigns.created_at_utc
   FROM ttd.raw_campaigns;


--
-- Name: channels; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.channels (
    id character varying(20) NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: contract_groups; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.contract_groups (
    id character varying(256) NOT NULL,
    name character varying(256),
    description character varying(2000),
    owner_partner_id character varying(256) NOT NULL,
    bid_list_id bigint NOT NULL
);


--
-- Name: contract_in_groups; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.contract_in_groups (
    contract_group_id character varying(256) NOT NULL,
    contract_id character varying(256) NOT NULL
);


--
-- Name: contracts; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.contracts (
    id character varying(256) NOT NULL,
    owner_partner_id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(65535),
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    currency_code character varying(3) NOT NULL
);


--
-- Name: creatives; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.creatives (
    id character varying(256) NOT NULL,
    advertiser_id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(2000),
    creative_type character varying(32) NOT NULL,
    flight_start_date_utc timestamp without time zone,
    flight_end_date_utc timestamp without time zone,
    availability character varying(32) NOT NULL,
    created_at_utc timestamp without time zone,
    last_updated_at_utc timestamp without time zone,
    share_link character varying(2000),
    will_this_be_served_in_china boolean NOT NULL,
    political_data_id character varying(256),
    image_attributes_image_content character varying(256),
    image_attributes_right_media_offer_type_id bigint,
    image_attributes_width integer,
    image_attributes_height integer,
    image_attributes_image_url character varying(2000),
    image_attributes_third_party_impression_tracking_url character varying(2000),
    image_attributes_third_party_impression_tracking_url2 character varying(2000),
    image_attributes_third_party_impression_tracking_url3 character varying(2000),
    image_attributes_is_securable boolean,
    image_attributes_clickthrough_url character varying(2000),
    image_attributes_landing_page_url character varying(2000),
    image_attributes_ad_server_name character varying(256),
    image_attributes_ad_server_creative_id character varying(256)
);


--
-- Name: currencies; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.currencies (
    currency_code character varying(3) NOT NULL,
    currency_name character varying(256) NOT NULL,
    currency_name_plural character varying(256)
);


--
-- Name: data_group_first_parties; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.data_group_first_parties (
    data_group_id character varying(256) NOT NULL,
    first_party_id bigint NOT NULL
);


--
-- Name: data_groups; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.data_groups (
    id character varying(256) NOT NULL,
    advertiser_id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(2000)
);


--
-- Name: device_make_models; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.device_make_models (
    device_make_id integer NOT NULL,
    device_model_id integer NOT NULL,
    device_make_name character varying(1000),
    device_model_name character varying(1000),
    device_model_marketing_name character varying(1000)
);


--
-- Name: device_types; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.device_types (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    deprecated boolean NOT NULL
);


--
-- Name: dynamic_parameter_retargetings; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.dynamic_parameter_retargetings (
    advertiser_id character varying(256) NOT NULL,
    rule_id character varying(256) NOT NULL,
    tracking_tag_id character varying(256) NOT NULL,
    segment_name character varying(256) NOT NULL,
    evaluated_parameter character varying(256) NOT NULL,
    function_id integer NOT NULL,
    string_parameter character varying(256),
    numeric_parameter numeric,
    secondary_numeric_parameter numeric,
    created_at timestamp without time zone NOT NULL,
    last_updated_at timestamp without time zone NOT NULL,
    is_archived_true boolean NOT NULL
);


--
-- Name: event_types; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.event_types (
    id integer NOT NULL,
    type character varying(100) NOT NULL,
    definition character varying(256) NOT NULL
);


--
-- Name: first_party_data; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.first_party_data (
    id bigint NOT NULL,
    name character varying(4096) NOT NULL,
    data_type character varying(64) NOT NULL,
    look_alike_model_eligibility character varying(256) NOT NULL,
    first_party_data_id bigint,
    last_request_date_utc timestamp without time zone,
    last_generation_date_utc timestamp without time zone,
    look_alike_model_build_status character varying(256),
    look_alike_model_result_status character varying(256),
    imported_audience_count bigint,
    received_ids_count bigint NOT NULL,
    active_ids_count bigint NOT NULL,
    active_ids_in_app_count bigint NOT NULL,
    active_ids_web_count bigint NOT NULL,
    active_ids_connected_tv_count bigint NOT NULL,
    active_persons_count bigint NOT NULL,
    active_household_count bigint NOT NULL
);


--
-- Name: matched_fold_positions; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.matched_fold_positions (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: operational_system_families; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.operational_system_families (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: operational_systems; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.operational_systems (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: partners; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.partners (
    id character varying(256) NOT NULL,
    name character varying(256) NOT NULL
);


--
-- Name: sellers; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.sellers (
    seller_name character varying(256) NOT NULL,
    seller_domain character varying(256),
    alias_to_seller_domain character varying(256),
    seller_status character varying(256) NOT NULL,
    is_targetable boolean NOT NULL
);


--
-- Name: site_lists; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.site_lists (
    id character varying(256) NOT NULL,
    advertiser_id character varying(256) NOT NULL,
    name character varying(256) NOT NULL,
    description character varying(2000),
    is_deleted boolean NOT NULL,
    site_list_line_count bigint NOT NULL,
    permissions character varying(32) NOT NULL
);


--
-- Name: supply_vendors; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.supply_vendors (
    id bigint NOT NULL,
    name character varying(256) NOT NULL
);


--
-- Name: temperature_buckets_in_celsius; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.temperature_buckets_in_celsius (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: tracking_loads; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.tracking_loads (
    entity_name character varying(256) NOT NULL,
    last_loaded timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: tracking_tags; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.tracking_tags (
    advertiser_id character varying(256) NOT NULL,
    tracking_tag_id character varying(256) NOT NULL,
    tracking_tag_name character varying(256) NOT NULL,
    tracking_tag_type character varying(256) NOT NULL,
    tracking_tag_location character varying(256),
    revenue character varying(256),
    currency character varying(256),
    container_tag_body character varying(256),
    first_party_data_id bigint NOT NULL,
    tracking_tag_category character varying(256) NOT NULL,
    tracking_tag_availability character varying(256) NOT NULL,
    offline_data_provider_id character varying(256),
    universal_pixel_name character varying(256),
    hit_count_7_day bigint NOT NULL,
    tag_redirect_uri character varying(256),
    household_enabled boolean NOT NULL,
    image_tag character varying(256),
    i_frame_tag character varying(256)
);


--
-- Name: tracking_versions; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.tracking_versions (
    entity_id character varying(256) NOT NULL,
    entity_name character varying(256) NOT NULL,
    tracking_version bigint NOT NULL
);


--
-- Name: universal_pixel_activities; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.universal_pixel_activities (
    advertiser_id character varying(256) NOT NULL,
    universal_pixel_id character varying(256) NOT NULL,
    universal_pixel_name character varying(256) NOT NULL,
    total_hit_count_1_day bigint NOT NULL,
    total_hit_count_7_day bigint NOT NULL,
    total_hit_count_30_day bigint NOT NULL
);


--
-- Name: universal_pixel_mappings; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.universal_pixel_mappings (
    advertiser_id character varying(256) NOT NULL,
    universal_pixel_id character varying(256) NOT NULL,
    universal_pixel_name character varying(256) NOT NULL,
    mapping_type character varying(256) NOT NULL,
    url character varying(256),
    household_extension_enabled boolean NOT NULL,
    revenue character varying(256),
    currency character varying(256),
    tracking_tag_id character varying(256) NOT NULL,
    universal_pixel_mapping_name character varying(256) NOT NULL,
    universal_pixel_mapping_type character varying(256) NOT NULL,
    description character varying(256) NOT NULL
);


--
-- Name: user_hours_of_week; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.user_hours_of_week (
    id integer NOT NULL,
    value character varying(100) NOT NULL
);


--
-- Name: video_player_sizes; Type: TABLE; Schema: ttd; Owner: -
--

CREATE TABLE ttd.video_player_sizes (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


--
-- Name: ad_formats ad_formats_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.ad_formats
    ADD CONSTRAINT ad_formats_pkey PRIMARY KEY (id);


--
-- Name: additional_fees additional_fees_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.additional_fees
    ADD CONSTRAINT additional_fees_pkey PRIMARY KEY (advertiser_id, owner_type, owner_id, fee_type, start_date_utc);


--
-- Name: ads_txt_seller_types ads_txt_seller_types_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.ads_txt_seller_types
    ADD CONSTRAINT ads_txt_seller_types_pkey PRIMARY KEY (id);


--
-- Name: advertisers advertisers_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.advertisers
    ADD CONSTRAINT advertisers_pkey PRIMARY KEY (id);


--
-- Name: audience_excluded_data_groups audience_excluded_data_groups_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.audience_excluded_data_groups
    ADD CONSTRAINT audience_excluded_data_groups_pkey PRIMARY KEY (audience_id, data_group_id);


--
-- Name: audience_included_data_groups audience_included_data_groups_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.audience_included_data_groups
    ADD CONSTRAINT audience_included_data_groups_pkey PRIMARY KEY (audience_id, data_group_id);


--
-- Name: audiences audiences_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.audiences
    ADD CONSTRAINT audiences_pkey PRIMARY KEY (id);


--
-- Name: browsers browsers_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.browsers
    ADD CONSTRAINT browsers_pkey PRIMARY KEY (id);


--
-- Name: channels channels_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.channels
    ADD CONSTRAINT channels_pkey PRIMARY KEY (id);


--
-- Name: contract_groups contract_groups_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.contract_groups
    ADD CONSTRAINT contract_groups_pkey PRIMARY KEY (id);


--
-- Name: contract_in_groups contract_in_groups_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.contract_in_groups
    ADD CONSTRAINT contract_in_groups_pkey PRIMARY KEY (contract_group_id, contract_id);


--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);


--
-- Name: creatives creatives_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.creatives
    ADD CONSTRAINT creatives_pkey PRIMARY KEY (id);


--
-- Name: currencies currencies_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.currencies
    ADD CONSTRAINT currencies_pkey PRIMARY KEY (currency_code);


--
-- Name: data_group_first_parties data_group_first_parties_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.data_group_first_parties
    ADD CONSTRAINT data_group_first_parties_pkey PRIMARY KEY (data_group_id, first_party_id);


--
-- Name: data_groups data_groups_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.data_groups
    ADD CONSTRAINT data_groups_pkey PRIMARY KEY (id);


--
-- Name: device_make_models device_make_models_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.device_make_models
    ADD CONSTRAINT device_make_models_pkey PRIMARY KEY (device_make_id, device_model_id);


--
-- Name: device_types device_types_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.device_types
    ADD CONSTRAINT device_types_pkey PRIMARY KEY (id);


--
-- Name: dynamic_parameter_retargetings dynamic_parameter_retargetings_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.dynamic_parameter_retargetings
    ADD CONSTRAINT dynamic_parameter_retargetings_pkey PRIMARY KEY (advertiser_id, rule_id);


--
-- Name: event_types event_types_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.event_types
    ADD CONSTRAINT event_types_pkey PRIMARY KEY (id);


--
-- Name: first_party_data first_party_data_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.first_party_data
    ADD CONSTRAINT first_party_data_pkey PRIMARY KEY (id);


--
-- Name: matched_fold_positions matched_fold_positions_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.matched_fold_positions
    ADD CONSTRAINT matched_fold_positions_pkey PRIMARY KEY (id);


--
-- Name: operational_system_families operational_system_families_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.operational_system_families
    ADD CONSTRAINT operational_system_families_pkey PRIMARY KEY (id);


--
-- Name: operational_systems operational_systems_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.operational_systems
    ADD CONSTRAINT operational_systems_pkey PRIMARY KEY (id);


--
-- Name: partners partners_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- Name: raw_ad_groups raw_ad_groups_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.raw_ad_groups
    ADD CONSTRAINT raw_ad_groups_pkey PRIMARY KEY (id);


--
-- Name: raw_campaigns raw_campaigns_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.raw_campaigns
    ADD CONSTRAINT raw_campaigns_pkey PRIMARY KEY (id);


--
-- Name: sellers sellers_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.sellers
    ADD CONSTRAINT sellers_pkey PRIMARY KEY (seller_name);


--
-- Name: site_lists site_lists_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.site_lists
    ADD CONSTRAINT site_lists_pkey PRIMARY KEY (id);


--
-- Name: supply_vendors supply_vendors_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.supply_vendors
    ADD CONSTRAINT supply_vendors_pkey PRIMARY KEY (id);


--
-- Name: temperature_buckets_in_celsius temperature_buckets_in_celsius_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.temperature_buckets_in_celsius
    ADD CONSTRAINT temperature_buckets_in_celsius_pkey PRIMARY KEY (id);


--
-- Name: tracking_loads tracking_loads_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.tracking_loads
    ADD CONSTRAINT tracking_loads_pkey PRIMARY KEY (entity_name);


--
-- Name: tracking_tags tracking_tags_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.tracking_tags
    ADD CONSTRAINT tracking_tags_pkey PRIMARY KEY (advertiser_id, tracking_tag_id);


--
-- Name: tracking_versions tracking_versions_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.tracking_versions
    ADD CONSTRAINT tracking_versions_pkey PRIMARY KEY (entity_id, entity_name);


--
-- Name: universal_pixel_activities universal_pixel_activities_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.universal_pixel_activities
    ADD CONSTRAINT universal_pixel_activities_pkey PRIMARY KEY (advertiser_id, universal_pixel_id);


--
-- Name: universal_pixel_mappings universal_pixel_mappings_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.universal_pixel_mappings
    ADD CONSTRAINT universal_pixel_mappings_pkey PRIMARY KEY (advertiser_id, universal_pixel_id, mapping_type, tracking_tag_id);


--
-- Name: user_hours_of_week user_hours_of_week_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.user_hours_of_week
    ADD CONSTRAINT user_hours_of_week_pkey PRIMARY KEY (id);


--
-- Name: video_player_sizes video_player_sizes_pkey; Type: CONSTRAINT; Schema: ttd; Owner: -
--

ALTER TABLE ONLY ttd.video_player_sizes
    ADD CONSTRAINT video_player_sizes_pkey PRIMARY KEY (id);

