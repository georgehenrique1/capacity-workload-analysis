-- ======================================================
-- PLANNING ENGINE
-- DIMENSIONS
--
-- Project: Capacity Workload Analysis
-- ======================================================

SET search_path TO planning_engine;

-- ======================================================
-- DIM_PRODUCT_TYPE
-- ======================================================

CREATE TABLE IF NOT EXISTS dim_product_type (

    product_type_id SERIAL PRIMARY KEY,

    product_type TEXT UNIQUE NOT NULL

);

INSERT INTO dim_product_type (product_type)
VALUES
    ('PT1'),
    ('PT2'),
    ('PT3')
ON CONFLICT DO NOTHING;

-- ======================================================
-- DIM_PRODUCTION_STAGE
-- ======================================================

CREATE TABLE IF NOT EXISTS dim_production_stage (

    production_stage_id SERIAL PRIMARY KEY,

    production_stage TEXT UNIQUE NOT NULL

);

INSERT INTO dim_production_stage (production_stage)
VALUES
    ('PS1'),
    ('PS2'),
    ('PS3')
ON CONFLICT DO NOTHING;

-- ======================================================
-- DIM_COMBINATION
-- ======================================================

CREATE TABLE IF NOT EXISTS dim_combination (

    combination_id SERIAL PRIMARY KEY,

    product_type_id INTEGER NOT NULL,

    production_stage_id INTEGER NOT NULL,

    CONSTRAINT fk_combination_product
        FOREIGN KEY (product_type_id)
        REFERENCES dim_product_type (product_type_id),

    CONSTRAINT fk_combination_stage
        FOREIGN KEY (production_stage_id)
        REFERENCES dim_production_stage (production_stage_id),

    CONSTRAINT uq_combination
        UNIQUE (
            product_type_id,
            production_stage_id
        )

);

INSERT INTO dim_combination (
    product_type_id,
    production_stage_id
)
SELECT
    pt.product_type_id,
    ps.production_stage_id
FROM dim_product_type pt
CROSS JOIN dim_production_stage ps
ON CONFLICT DO NOTHING;

-- ======================================================
-- DIM_WORKCENTER
-- ======================================================

CREATE TABLE IF NOT EXISTS dim_workcenter (

    workcenter_id SERIAL PRIMARY KEY,

    workcenter TEXT UNIQUE NOT NULL,

    daily_installed_capacity NUMERIC(6,2) NOT NULL

);

INSERT INTO dim_workcenter (
    workcenter,
    daily_installed_capacity
)
VALUES
    ('WC1', 72),
    ('WC2', 72),
    ('WC3', 72)
ON CONFLICT DO NOTHING;

-- ======================================================
-- DIM_SHIFT
-- ======================================================

CREATE TABLE IF NOT EXISTS dim_shift (

    shift_id SERIAL PRIMARY KEY,

    shift TEXT UNIQUE NOT NULL,

    workhours NUMERIC(4,2) NOT NULL,

    breaks NUMERIC(4,2) NOT NULL,

    efficiency NUMERIC(4,2)
        CHECK (efficiency BETWEEN 0 AND 1)

);

INSERT INTO dim_shift (
    shift,
    workhours,
    breaks,
    efficiency
)
VALUES
    ('1st Shift', 9.50, 1.50, 0.75),
    ('2nd Shift', 9.00, 1.50, 0.70),
    ('3rd Shift', 8.50, 1.50, 0.65)
ON CONFLICT DO NOTHING;

-- ======================================================
-- DIM_DATE
-- ======================================================

CREATE TABLE IF NOT EXISTS dim_date (

    calendar_day DATE PRIMARY KEY,

    calendar_month INTEGER NOT NULL,

    calendar_year INTEGER NOT NULL,

    month_name TEXT NOT NULL,

    month_year_name TEXT NOT NULL,

    month_year_key INTEGER NOT NULL,

    is_workday BOOLEAN NOT NULL,

    is_holiday BOOLEAN NOT NULL

);

-- ======================================================
-- POPULATE CALENDAR 2026
-- ======================================================

INSERT INTO dim_date (

    calendar_day,

    calendar_month,

    calendar_year,

    month_name,

    month_year_name,

    month_year_key,

    is_workday,

    is_holiday

)

SELECT

    calendar_day,

    EXTRACT(MONTH FROM calendar_day)::INTEGER AS calendar_month,

    EXTRACT(YEAR FROM calendar_day)::INTEGER AS calendar_year,

    TRIM(TO_CHAR(calendar_day, 'Month')) AS month_name,

    TO_CHAR(calendar_day, 'Mon/YY') AS month_year_name,

    (
        EXTRACT(YEAR FROM calendar_day)::INTEGER * 100
        +
        EXTRACT(MONTH FROM calendar_day)::INTEGER
    ) AS month_year_key,

    CASE

        WHEN EXTRACT(ISODOW FROM calendar_day) BETWEEN 1 AND 5

            THEN TRUE

        ELSE FALSE

    END AS is_workday,

    FALSE AS is_holiday

FROM generate_series(

        DATE '2026-01-01',
        DATE '2026-12-31',
        INTERVAL '1 day'

     ) AS calendar_day

ON CONFLICT (calendar_day)

DO NOTHING;

-- ======================================================
-- NATIONAL HOLIDAYS - BRAZIL (2026)
-- ======================================================

UPDATE dim_date

SET

    is_holiday = TRUE,

    is_workday = FALSE

WHERE calendar_day IN (

    DATE '2026-01-01', -- New Year's Day

    DATE '2026-04-03', -- Good Friday

    DATE '2026-04-21', -- Tiradentes

    DATE '2026-05-01', -- Labour Day

    DATE '2026-06-04', -- Corpus Christi

    DATE '2026-09-07', -- Independence Day

    DATE '2026-10-12', -- Our Lady of Aparecida

    DATE '2026-11-02', -- All Souls' Day

    DATE '2026-11-15', -- Republic Proclamation Day

    DATE '2026-12-25'  -- Christmas

);

-- ======================================================
-- INDEXES
-- ======================================================

CREATE INDEX IF NOT EXISTS idx_dim_date_month_year

ON dim_date (

    calendar_year,

    calendar_month

);
