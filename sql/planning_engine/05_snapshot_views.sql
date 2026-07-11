-- ======================================================
-- SNAPSHOT VIEWS
-- ======================================================
--
-- Returns the latest valid Master Plan and Roster
-- snapshots for each analysis month based on:
--
-- MAX(reference_month) <= analysis_month
--
-- Ensures historical planning assumptions are preserved
-- in workload and capacity calculations.
-- ======================================================
CREATE OR REPLACE VIEW vw_actual_masterplan AS

WITH analysis_months AS (

    SELECT DISTINCT

        MAKE_DATE(
            calendar_year,
            calendar_month,
            1
        ) AS analysis_month

    FROM dim_date

)

SELECT

    am.analysis_month,

    mp.masterplan_id,

    mp.project_number,

    mp.project_name,

    mp.combination_id,

    mp.need_date,

    mp.reference_month

FROM analysis_months am

INNER JOIN raw_masterplan mp

    ON mp.reference_month = (

        SELECT MAX(sub.reference_month)

        FROM raw_masterplan sub

        WHERE sub.reference_month <= am.analysis_month

    );
	
CREATE OR REPLACE VIEW vw_actual_roster AS

WITH analysis_months AS (

    SELECT DISTINCT

        MAKE_DATE(
            calendar_year,
            calendar_month,
            1
        ) AS analysis_month

    FROM dim_date

)

SELECT

    am.analysis_month,

    r.operator_id,

    r.operator_name,

    r.workcenter_id,

    r.shift_id,

    r.reference_month

FROM analysis_months am

INNER JOIN raw_roster r

    ON r.reference_month = (

        SELECT MAX(sub.reference_month)

        FROM raw_roster sub

        WHERE sub.reference_month <= am.analysis_month

    );