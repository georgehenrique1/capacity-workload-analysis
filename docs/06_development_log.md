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
- Adopted a Snowflake-style structure for the Planning Engine.
- Kept reporting objects separate from calculation and business rule objects.
- Created separate DBML diagrams for the physical model and processing flow.

## Planning Engine

- Created the `planning_engine` PostgreSQL schema.
- Implemented:
  - `dim_product_type`
  - `dim_production_stage`
  - `dim_combination`
  - `dim_workcenter`
  - `dim_shift`
  - `dim_date`
- Generated Product Type and Production Stage combinations using a cross join.
- Created the 2026 calendar with workday, holiday and Power BI month-sorting attributes.

## Business Rules

- Created `leadtime_rules` for Internal Start Date calculation.
- Created `routing_hours` for Manned and Installed workload generation.
- Added primary keys, foreign keys, unique constraints and validation checks.
- Recalibrated Routing Hours to generate more realistic utilization and bottleneck scenarios.

## Input and Snapshot Management

- Created `raw_masterplan` and `raw_roster`.
- Added `reference_month` to preserve input versions.
- Loaded Master Plan snapshots for January, April and June 2026.
- Loaded workforce snapshots containing:
  - 30 operators in January
  - 39 operators in April
  - 45 operators in June

### Snapshot Strategy Revision

The initial design applied historical snapshot logic to both Master Plan and Roster.

The final strategy is:

- Workload always uses the latest available Master Plan through `vw_latest_masterplan`.
- Capacity uses the latest valid Roster for each analysis month through `vw_actual_roster`.

This keeps future workload aligned with the latest customer forecast while preserving historical workforce assumptions.

## Workload Engine

- Created `vw_detailed_workload`.
- Calculated Internal Start Date using Lead Time Rules.
- Applied Routing Hours to generate workload by Work Center.
- Preserved project-level workload traceability.
- Created `vw_monthly_workload` at Analysis Month and Work Center level.

## Capacity Engine

- Created `vw_detailed_capacity` at Analysis Month, Work Center and Shift level.
- Calculated Manned Capacity using:
  - Headcount
  - Net Shift Hours
  - Efficiency
  - Workdays
- Calculated Installed Capacity using Daily Installed Capacity and Calendar Days.
- Created `vw_monthly_capacity` at Analysis Month and Work Center level.

## Analytics Layer

- Created the `analytics` PostgreSQL schema.
- Created `analytics.vw_capacity_workload`.
- Combined Monthly Capacity and Monthly Workload by Analysis Month and Work Center.
- Added Manned and Installed Capacity Gaps and Status indicators.
- Preserved months without workload through a left join.
- Converted missing workload values to zero.

### KPI Calculation Revision

Utilization percentages were initially calculated in SQL.

This approach was revised because pre-calculated percentages do not aggregate correctly when multiple months or Work Centers are selected.

Utilization was moved to Power BI and is calculated as:

```text
SUM(Required Hours)
/
SUM(Available Capacity)
```

This ensures that utilization responds correctly to the current report filter context.

## Power BI Model

- Connected Power BI to PostgreSQL using Import mode.
- Imported the analytical and detailed calculation views.
- Added shared Date, Work Center and Shift dimensions.
- Added `month_year_name` and `month_year_key` to support chronological sorting.
- Created DAX measures for:
  - Manned Utilization
  - Installed Utilization
  - Latest Headcount
  - Active Projects
  - Total Project Workload
  - Conditional utilization colors

## Management Overview

Created the executive Capacity vs Workload page with:

- Headcount KPI
- Manned Capacity KPIs
- Installed Capacity KPIs
- Required Workload KPIs
- Capacity Gaps
- Context-aware Utilization measures
- Monthly Manned Capacity vs Workload trend
- Monthly Installed Capacity vs Workload trend
- Manned Utilization heatmap by Work Center
- Installed Utilization heatmap by Work Center
- Conditional formatting for Gap and Utilization

The page identifies when capacity constraints occur and whether they are related to labor or installed resources.

## Operational Analysis

Created the operational detail page with:

- Headcount
- Active Projects
- Required Manned Hours
- Required Installed Hours
- Top Projects by Total Workload
- Manned and Installed workload composition
- Planned Projects table
- Project Need Dates
- Project-level workload traceability

The page explains which projects are driving the workload and contributing to future capacity constraints.

## Dashboard Design

- Used a consistent corporate color palette.
- Applied green, yellow and red thresholds to utilization KPIs and heatmaps.
- Applied positive and negative formatting to Capacity Gaps.
- Created navigation buttons between the two report pages.
- Structured the report into:
  - Management Overview
  - Operational Analysis
- Kept the report concise and focused on decision-making.

## Documentation and Repository

- Updated:
  - Business Problem
  - Solution Overview
  - Data Model
  - Business Rules
  - KPI Definitions
  - Development Log
  - README
- Added the Planning Engine physical and processing-flow diagrams.
- Added Management Overview and Operational Analysis screenshots.
- Added the final Power BI `.pbix` report.
- Organized SQL scripts, source CSV files, documentation and images into dedicated folders.

## Final Status

Completed:

- Business Problem Definition
- Solution Architecture
- PostgreSQL Physical Model
- Planning Engine
- Business Rules
- Input and Snapshot Management
- Workload Engine
- Capacity Engine
- Analytics Layer
- DBML Documentation
- Power BI Data Model
- Management Overview
- Operational Analysis
- Project Documentation
- Dashboard Screenshots
- Power BI Report

**Project Status: Completed**