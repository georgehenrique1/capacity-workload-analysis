-- ======================================================
-- PLANNING ENGINE
-- WORKLOAD & CAPACITY CALCULATIONS
-- ======================================================
--
-- OVERVIEW
--
-- The Planning Engine is responsible for transforming
-- planning inputs into monthly workload and capacity
-- requirements.
--
-- WORKLOAD LOGIC
--
-- • Workload is always calculated using the latest
--   available Master Plan snapshot.
--
-- • Internal Start Date is calculated as:
--
--   Need Date - Lead Time
--
-- • Routing Hours determine the workload generated for
--   each Work Center.
--
-- • Detailed Workload:
--   Project + Combination + Work Center
--
-- • Monthly Workload:
--   Analysis Month + Work Center
--
--
-- CAPACITY LOGIC
--
-- • Capacity preserves historical workforce snapshots.
--
-- • Roster snapshots follow:
--
--   MAX(reference_month) <= analysis_month
--
-- • Manned Capacity is calculated as:
--
--   Headcount
--   * Net Shift Hours
--   * Efficiency
--   * Workdays
--
-- • Installed Capacity is calculated as:
--
--   Daily Installed Capacity
--   * Calendar Days
--
-- • Detailed Capacity:
--   Analysis Month + Work Center + Shift
--
-- • Monthly Capacity:
--   Analysis Month + Work Center
-- ======================================================



-- ======================================================
-- VW_DETAILED_WORKLOAD
-- ======================================================
--
-- Purpose:
-- Returns workload requirements at the most detailed
-- planning level.
--
-- Granularity:
-- Project + Combination + Work Center
-- ======================================================

CREATE OR REPLACE VIEW vw_detailed_workload AS

WITH workload_base AS (

    SELECT

        mp.reference_month,

        mp.masterplan_id,

        mp.project_number,

        mp.project_name,

        mp.combination_id,

        mp.need_date,

        (
            mp.need_date
            - lr.leadtime_days
        ) AS internal_start_date

    FROM vw_latest_masterplan mp

    INNER JOIN leadtime_rules lr

        ON mp.combination_id = lr.combination_id

)

SELECT

    wb.reference_month,

    wb.masterplan_id,

    wb.project_number,

    wb.project_name,

    wb.combination_id,

    wb.need_date,

    wb.internal_start_date,

    d.calendar_month,

    d.calendar_year,

    rh.workcenter_id,

    rh.manned_hours AS required_manned_hours,

    rh.installed_hours AS required_installed_hours

FROM workload_base wb

INNER JOIN routing_hours rh

    ON wb.combination_id = rh.combination_id

INNER JOIN dim_date d

    ON wb.internal_start_date = d.calendar_day;



-- ======================================================
-- VW_MONTHLY_WORKLOAD
-- ======================================================
--
-- Purpose:
-- Aggregates workload requirements by month and
-- Work Center.
--
-- Granularity:
-- Analysis Month + Work Center
-- ======================================================

CREATE OR REPLACE VIEW vw_monthly_workload AS

SELECT

    reference_month,

    DATE_TRUNC(
        'month',
        internal_start_date
    )::DATE AS analysis_month,

    workcenter_id,

    SUM(required_manned_hours) AS required_manned_hours,

    SUM(required_installed_hours) AS required_installed_hours

FROM vw_detailed_workload

GROUP BY

    reference_month,

    DATE_TRUNC(
        'month',
        internal_start_date
    )::DATE,

    workcenter_id;



-- ======================================================
-- VW_DETAILED_CAPACITY
-- ======================================================
--
-- Purpose:
-- Calculates workforce capacity at shift level,
-- preserving roster snapshots over time.
--
-- Granularity:
-- Analysis Month + Work Center + Shift
-- ======================================================

CREATE OR REPLACE VIEW vw_detailed_capacity AS

WITH calendar_base AS (

    SELECT

        DATE_TRUNC(
            'month',
            calendar_day
        )::DATE AS analysis_month,

        COUNT(*) FILTER (
            WHERE is_workday = TRUE
        ) AS workdays,

        COUNT(*) AS total_days

    FROM dim_date

    GROUP BY

        DATE_TRUNC(
            'month',
            calendar_day
        )::DATE

),

headcount AS (

    SELECT

        analysis_month,

        workcenter_id,

        shift_id,

        reference_month,

        COUNT(*) AS headcount

    FROM vw_actual_roster

    GROUP BY

        analysis_month,

        workcenter_id,

        shift_id,

        reference_month

)

SELECT

    h.reference_month,

    h.analysis_month,

    cb.workdays,

    cb.total_days,

    h.workcenter_id,

    h.shift_id,

    h.headcount,

    ROUND(

        h.headcount
        * (s.workhours - s.breaks)
        * s.efficiency
        * cb.workdays,

        2

    ) AS manned_capacity,

    ROUND(

        wc.daily_installed_capacity
        * cb.total_days
        / 3.0,

        2

    ) AS installed_capacity

FROM headcount h

INNER JOIN calendar_base cb

    ON h.analysis_month = cb.analysis_month

INNER JOIN dim_shift s

    ON h.shift_id = s.shift_id

INNER JOIN dim_workcenter wc

    ON h.workcenter_id = wc.workcenter_id;



-- ======================================================
-- VW_MONTHLY_CAPACITY
-- ======================================================
--
-- Purpose:
-- Aggregates capacity calculations to the same
-- granularity used by vw_monthly_workload,
-- enabling direct Capacity vs Workload comparisons.
--
-- Granularity:
-- Analysis Month + Work Center
-- ======================================================

CREATE OR REPLACE VIEW vw_monthly_capacity AS

SELECT

    reference_month,

    analysis_month,

    MAX(workdays) AS workdays,

    MAX(total_days) AS total_days,

    workcenter_id,

    SUM(headcount) AS headcount,

    SUM(manned_capacity) AS manned_capacity,

    SUM(installed_capacity) AS installed_capacity

FROM vw_detailed_capacity

GROUP BY

    reference_month,

    analysis_month,

    workcenter_id;