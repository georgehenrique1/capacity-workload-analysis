-- ======================================================
-- CAPACITY VS WORKLOAD
-- ======================================================
--
-- Consolidates monthly workload and capacity metrics
-- at Analysis Month + Work Center level.
--
-- Provides utilization, capacity gap, status and risk
-- indicators for manufacturing planning and bottleneck
-- analysis.
--
-- Sources:
-- - planning_engine.vw_monthly_workload
-- - planning_engine.vw_monthly_capacity
-- ======================================================
CREATE SCHEMA IF NOT EXISTS analytics;
CREATE OR REPLACE VIEW analytics.vw_capacity_workload AS (
with capacity_workload_base as (
	SELECT
		mc.reference_month,
		mc.analysis_month,
		mc.workdays,
		mc.total_days,
		mc.workcenter_id,
		mc.headcount,
		mc.manned_capacity,
		mw.required_manned_hours,
		ROUND((mw.required_manned_hours/mc.manned_capacity),2) AS manned_utilization_pct,
		(mc.manned_capacity - mw.required_manned_hours) AS manned_capacity_gap,
		CASE
			WHEN mw.required_manned_hours > mc.manned_capacity 
				THEN 'Deficit'
			ELSE
				'Available'
		END as manned_capacity_status,
		mc.installed_capacity,
		mw.required_installed_hours,
		ROUND((mw.required_installed_hours/mc.installed_capacity),2) AS installed_utilization_pct,
		(mc.installed_capacity - mw.required_installed_hours) AS installed_capacity_gap,
			CASE
			WHEN mw.required_installed_hours > mc.installed_capacity 
				THEN 'Deficit'
			ELSE
				'Available'
		END as installed_capacity_status
	FROM 
		planning_engine.vw_monthly_capacity mc
	LEFT JOIN
		planning_engine.vw_monthly_workload mw ON mc.analysis_month = mw.analysis_month
								AND mc.workcenter_id = mw.workcenter_id)
SELECT
	*,
	CASE
    WHEN manned_utilization_pct >= 1.10
        THEN 'Critical'
    WHEN manned_utilization_pct >= 1.00
        THEN 'High'
    WHEN manned_utilization_pct >= 0.85
        THEN 'Medium'
    ELSE 'Low'
END AS manned_capacity_risk,
	CASE
    WHEN installed_utilization_pct >= 1.10
        THEN 'Critical'
    WHEN installed_utilization_pct >= 1.00
        THEN 'High'
    WHEN installed_utilization_pct >= 0.85
        THEN 'Medium'
    ELSE 'Low'
END AS installed_capacity_risk
FROM capacity_workload_base)	