# Development Log

This document summarizes the main development milestones and architectural decisions made throughout the project.

## Project Definition

- Defined the manufacturing Capacity vs Workload business problem.
- Established a 12-month planning horizon with monthly granularity.
- Defined two independent resource constraints:
  - Manned Capacity
  - Installed Capacity
- Defined Work Center as the main level for capacity analysis.

## Solution Architecture

- Separated the solution into:
  - Planning Engine
  - Analytics Layer
  - Power BI Report
- Adopted a Snowflake-style model for the Planning Engine.
- Kept reporting structures separate from calculation and business rule objects.
- Created separate DBML diagrams for the physical model and processing flow.

## Planning Engine

- Created the `planning_engine` PostgreSQL schema.
- Implemented the following dimensions:
  - `dim_product_type`
  - `dim_production_stage`
  - `dim_combination`
  - `dim_workcenter`
  - `dim_shift`
  - `dim_date`
- Generated Product Type and Production Stage combinations using a cross join.
- Created the 2026 calendar with workday and holiday information.

## Business Rules

- Created `leadtime_rules` to calculate Internal Start Dates.
- Created `routing_hours` to define Manned and Installed workload by Combination and Work Center.
- Added primary keys, foreign keys, unique constraints and validation checks.
- Recalibrated Routing Hours to produce more realistic utilization scenarios.

## Input and Snapshot Management

- Created `raw_masterplan` and `raw_roster`.
- Added `reference_month` to preserve input versions.
- Loaded Master Plan snapshots for January, April and June 2026.
- Loaded Roster snapshots containing:
  - 30 operators in January
  - 39 operators in April
  - 45 operators in June

### Snapshot Strategy Revision

The initial design applied historical snapshot logic to both Master Plan and Roster.

The final strategy is:

- Workload always uses the latest available Master Plan through `vw_latest_masterplan`.
- Capacity uses the latest valid Roster for each analysis month through `vw_actual_roster`.

This keeps workload aligned with the latest customer forecast while preserving workforce history.

## Workload Engine

- Created `vw_detailed_workload`.
- Calculated Internal Start Date using Lead Time Rules.
- Applied Routing Hours to generate workload for each Work Center.
- Preserved project-level workload traceability.
- Created `vw_monthly_workload` at Analysis Month and Work Center level.

## Capacity Engine

- Created `vw_detailed_capacity` at Analysis Month, Work Center and Shift level.
- Calculated Manned Capacity using Headcount, Net Shift Hours, Efficiency and Workdays.
- Calculated Installed Capacity using Daily Installed Capacity and Calendar Days.
- Created `vw_monthly_capacity` at Analysis Month and Work Center level.

## Analytics Layer

- Created the `analytics` schema.
- Created `analytics.vw_capacity_workload`.
- Combined Monthly Capacity and Monthly Workload by Analysis Month and Work Center.
- Added Manned and Installed Capacity Gaps and Status indicators.
- Preserved months without workload by treating missing workload values as zero.

### KPI Calculation Revision

Utilization percentages were initially calculated in SQL.

This approach was revised because pre-calculated percentages do not aggregate correctly when multiple months or Work Centers are selected.

The utilization measures were moved to Power BI and are now calculated as:

```text
SUM(Required Hours)
/
SUM(Available Capacity)
```

## Power BI Report

- Connected Power BI to PostgreSQL using Import mode.
- Added shared Date, Work Center and Shift dimensions.
- Added Month-Year display and sorting attributes to `dim_date`.
- Created two report pages:
  - Management Overview
  - Operational Analysis

### Management Overview

Implemented:

- Headcount KPI
- Manned and Installed Capacity KPIs
- Required Workload KPIs
- Capacity Gaps
- Utilization measures
- Capacity vs Workload trends
- Work Center utilization heatmaps
- Conditional formatting for Gap and Utilization

### Operational Analysis

Implemented:

- Active Projects
- Required Manned and Installed Hours
- Top Projects by Total Workload
- Planned Projects table
- Project-level Need Date and workload traceability

## Current Status

Completed:

- Business problem definition
- Solution architecture
- PostgreSQL Planning Engine
- Snapshot management
- Workload and Capacity engines
- Analytics Layer
- DBML documentation
- Power BI report

Remaining:

- Final README update
- Dashboard screenshots
- Repository cleanup
- Final validation
- Portfolio publication