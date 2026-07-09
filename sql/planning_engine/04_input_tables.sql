-- ======================================================
-- PLANNING ENGINE
-- INPUT TABLES
--
-- Source files:
-- raw_masterplan.csv
-- raw_roster.csv
-- ======================================================

-- ======================================================
-- RAW_MASTERPLAN
-- ======================================================

CREATE TABLE IF NOT EXISTS raw_masterplan (

    masterplan_id SERIAL PRIMARY KEY,

    project_number TEXT NOT NULL,

    project_name TEXT NOT NULL,

    combination_id INTEGER NOT NULL,

    need_date DATE NOT NULL,

    reference_month DATE NOT NULL,

    CONSTRAINT fk_masterplan_combination
        FOREIGN KEY (combination_id)
        REFERENCES dim_combination (combination_id),

    CONSTRAINT uq_masterplan
        UNIQUE (
            project_number,
            combination_id,
            reference_month
        )

);

-- ======================================================
-- RAW_ROSTER
-- ======================================================

CREATE TABLE IF NOT EXISTS raw_roster (

    operator_id INTEGER NOT NULL,

    operator_name TEXT NOT NULL,

    workcenter_id INTEGER NOT NULL,

    shift_id INTEGER NOT NULL,

    reference_month DATE NOT NULL,

    CONSTRAINT pk_roster
        PRIMARY KEY (
            operator_id,
            reference_month
        ),

    CONSTRAINT fk_roster_workcenter
        FOREIGN KEY (workcenter_id)
        REFERENCES dim_workcenter (workcenter_id),

    CONSTRAINT fk_roster_shift
        FOREIGN KEY (shift_id)
        REFERENCES dim_shift (shift_id)

);