-- ======================================================
-- PLANNING ENGINE
-- BUSINESS RULES
-- ======================================================

-- ======================================================
-- LEADTIME RULES
-- ======================================================

CREATE TABLE IF NOT EXISTS leadtime_rules (

    combination_id INTEGER PRIMARY KEY,

    leadtime_days INTEGER NOT NULL
        CHECK (leadtime_days > 0),

    CONSTRAINT fk_leadtime_combination
        FOREIGN KEY (combination_id)
        REFERENCES dim_combination (combination_id)

);

INSERT INTO leadtime_rules (
    combination_id,
    leadtime_days
)
VALUES
    (1, 30),
    (2, 20),
    (3, 10),
    (4, 45),
    (5, 30),
    (6, 15),
    (7, 60),
    (8, 45),
    (9, 30)
ON CONFLICT DO NOTHING;

-- ======================================================
-- ROUTING HOURS
-- ======================================================

CREATE TABLE IF NOT EXISTS routing_hours (

    combination_id INTEGER NOT NULL,

    workcenter_id INTEGER NOT NULL,

    manned_hours NUMERIC(6,2) NOT NULL
        CHECK (manned_hours >= 0),

    installed_hours NUMERIC(6,2) NOT NULL
        CHECK (installed_hours >= 0),

    CONSTRAINT pk_routing
        PRIMARY KEY (
            combination_id,
            workcenter_id
        ),

    CONSTRAINT fk_routing_combination
        FOREIGN KEY (combination_id)
        REFERENCES dim_combination (combination_id),

    CONSTRAINT fk_routing_workcenter
        FOREIGN KEY (workcenter_id)
        REFERENCES dim_workcenter (workcenter_id)

);

INSERT INTO routing_hours (
    combination_id,
    workcenter_id,
    manned_hours,
    installed_hours
)
VALUES

-- Combination 1

(1, 1, 3.00, 2.00),
(1, 2, 2.50, 1.50),
(1, 3, 1.50, 1.00),

-- Combination 2

(2, 1, 4.00, 2.50),
(2, 2, 3.00, 2.00),
(2, 3, 2.00, 1.50),

-- Combination 3

(3, 1, 5.00, 3.00),
(3, 2, 4.00, 2.50),
(3, 3, 3.00, 2.00),

-- Combination 4

(4, 1, 3.50, 2.00),
(4, 2, 2.50, 1.50),
(4, 3, 1.50, 1.00),

-- Combination 5

(5, 1, 4.50, 3.00),
(5, 2, 3.50, 2.50),
(5, 3, 2.50, 2.00),

-- Combination 6

(6, 1, 6.00, 4.00),
(6, 2, 5.00, 3.50),
(6, 3, 4.00, 3.00),

-- Combination 7

(7, 1, 4.00, 2.50),
(7, 2, 3.00, 2.00),
(7, 3, 2.00, 1.50),

-- Combination 8

(8, 1, 5.00, 3.50),
(8, 2, 4.00, 3.00),
(8, 3, 3.00, 2.50),

-- Combination 9

(9, 1, 7.00, 5.00),
(9, 2, 6.00, 4.00),
(9, 3, 5.00, 3.50)

ON CONFLICT DO NOTHING;