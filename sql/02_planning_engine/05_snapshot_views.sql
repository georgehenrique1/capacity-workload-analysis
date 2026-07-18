-- ======================================================
-- SNAPSHOT VIEWS
-- ======================================================
--
-- Workload calculations always use the latest available
-- Master Plan version.
--
-- Capacity calculations preserve historical workforce
-- assumptions by selecting the latest valid Roster
-- snapshot for each analysis month based on:
--
-- MAX(reference_month) <= analysis_month
--
-- This approach evaluates future demand using the most
-- recent forecast while maintaining historical capacity
-- evolution throughout the planning horizon.
-- ======================================================
CREATE OR REPLACE VIEW vw_latest_masterplan AS (

	SELECT * FROM raw_masterplan
WHERE reference_month = (
	SELECT MAX(reference_month)
	FROM raw_masterplan
)
	
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