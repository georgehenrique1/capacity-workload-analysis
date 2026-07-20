-- ======================================================
-- CAPACITY VS WORKLOAD
-- ======================================================
--
-- Consolidates monthly workload and capacity metrics
-- at Analysis Month + Work Center level.
--
-- Provides indicators for manufacturing planning and
-- bottleneck analysis.
--
-- Sources:
-- - planning_engine.vw_monthly_workload
-- - planning_engine.vw_monthly_capacity
-- ======================================================

CREATE SCHEMA IF NOT EXISTS analytics;

CREATE OR REPLACE VIEW analytics.vw_capacity_workload AS

SELECT

    mc.reference_month,

    mc.analysis_month,

    mc.workdays,

    mc.total_days,

    mc.workcenter_id,

    mc.headcount,

    -- MANPOWER CAPACITY

    mc.manned_capacity,

    COALESCE(
        mw.required_manned_hours,
        0
    ) AS required_manned_hours,

    (
        mc.manned_capacity
        - COALESCE(
            mw.required_manned_hours,
            0
        )
    ) AS manned_capacity_gap,

    CASE

        WHEN COALESCE(
            mw.required_manned_hours,
            0
        ) > mc.manned_capacity

            THEN 'Deficit'

        ELSE 'Available'

    END AS manned_capacity_status,

    -- INSTALLED CAPACITY

    mc.installed_capacity,

    COALESCE(
        mw.required_installed_hours,
        0
    ) AS required_installed_hours,

    (
        mc.installed_capacity
        - COALESCE(
            mw.required_installed_hours,
            0
        )
    ) AS installed_capacity_gap,

    CASE

        WHEN COALESCE(
            mw.required_installed_hours,
            0
        ) > mc.installed_capacity

            THEN 'Deficit'

        ELSE 'Available'

    END AS installed_capacity_status

FROM planning_engine.vw_monthly_capacity mc

LEFT JOIN planning_engine.vw_monthly_workload mw

    ON mc.analysis_month = mw.analysis_month

   AND mc.workcenter_id = mw.workcenter_id;

   select * from analytics.vw_capacity_workload