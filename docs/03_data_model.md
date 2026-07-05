# Data Model

## Dimensional Modeling Approach

The solution adopts a dimensional modeling approach based on a Star Schema architecture.

The primary objective of the model is to support Capacity vs. Workload analysis across a 12-month planning horizon, enabling efficient reporting and analytical performance in Power BI.

The model separates descriptive business entities into Dimension Tables and measurable events into Fact Tables. In addition, business logic is centralized through specialized Business Rule Tables responsible for workload generation and planning calculations.

The model is designed to support both Factory-Level and Work Center-Level analysis.

---

# Solution Architecture

The solution is organized into four logical layers:

## Input Layer

Raw planning data received from business users.

Sources:

- Master Plan
- Production List

## Business Rules Layer

Contains the rules required to transform customer demand into manufacturing workload requirements.

Components:

- Lead Time Rules
- Routing Matrix

## Analytical Layer

Contains all dimensional and fact tables used to support calculations and reporting.

Components:

- Dimension Tables
- Fact Tables
- Capacity Calculations
- Workload Calculations

## Reporting Layer

Business intelligence layer consumed by Power BI dashboards.

Outputs:

- Capacity vs Workload Analysis
- Capacity Utilization
- Bottleneck Identification
- Scenario Analysis

---

# Dimensions

Dimensions describe the business entities used for analysis.

## dim_month

### Purpose

Stores calendar information used throughout the planning process.

### Grain

One record per month.

### Attributes

- month_key
- year
- month_number
- month_name
- calendar_days
- working_days
- holidays

### Example

202601

January 2026

22 Working Days

1 Holiday

---

## dim_project

### Purpose

Stores project identifiers received from the Master Plan.

### Grain

One record per project.

### Attributes

- project_key
- project_number

### Example

PRJ001

PRJ002

PRJ003

---

## dim_product_type

### Purpose

Stores product classifications.

### Grain

One record per Product Type.

### Attributes

- product_type_key
- product_type_name

### Example

Product Type 1

Product Type 2

Product Type 3

---

## dim_stage

### Purpose

Stores manufacturing Production Stages.

### Grain

One record per Production Stage.

### Attributes

- stage_key
- stage_name

### Example

Production Stage 1

Production Stage 2

Production Stage 3

---

## dim_workcenter

### Purpose

Stores manufacturing Work Centers.

### Grain

One record per Work Center.

### Attributes

- workcenter_key
- workcenter_name

### Example

Work Center 1

Work Center 2

Work Center 3

---

## dim_shift

### Purpose

Stores production shift definitions.

### Grain

One record per shift.

### Attributes

- shift_key
- shift_name

### Example

Shift 1

Shift 2

Shift 3

---

# Business Rule Tables

Business Rule Tables store the planning logic responsible for workload generation and date calculations.

## leadtime_rules

### Purpose

Stores lead times used to determine Internal Start Dates.

### Grain

One record per Product Type and Production Stage.

### Attributes

- product_type_key
- stage_key
- leadtime_days

### Business Logic

Internal Start Date

=

Need Date

-

Lead Time Days

---

## routing_hours

### Purpose

Defines workload requirements for every Product Type, Production Stage and Work Center combination.

This table is the primary workload generation engine for the solution.

### Grain

One record per Product Type, Production Stage and Work Center.

### Attributes

- product_type_key
- stage_key
- workcenter_key
- manned_hours
- installed_hours

### Example

Product Type 1

Production Stage 1

Work Center 1

Manned Hours = 3

Installed Hours = 2

---

# Fact Tables

Fact Tables contain the measurable events used for analysis.

## fact_masterplan

### Purpose

Stores planning requirements received from customers.

### Grain

One record per Project and Production Stage.

### Attributes

- masterplan_id
- project_key
- product_type_key
- stage_key
- need_date
- internal_start_date
- month_key

### Description

This table represents the planning demand received from customers and serves as the origin of workload generation.

---

## fact_capacity_snapshot

### Purpose

Stores monthly snapshots of factory capacity.

Historical snapshots are preserved to provide traceability and support capacity evolution analysis.

### Grain

One record per Snapshot Month, Capacity Month and Work Center.

### Attributes

- snapshot_month_key
- capacity_month_key
- workcenter_key
- headcount
- manned_capacity_hours
- installed_capacity_hours

### Description

Each monthly snapshot preserves the capacity assumptions available at the time of planning.

This allows historical comparison between different planning cycles.

---

## fact_workload

### Purpose

Stores workload requirements generated from customer demand.

### Grain

One record per Project, Production Stage and Work Center.

### Attributes

- month_key
- project_key
- product_type_key
- stage_key
- workcenter_key
- required_manned_hours
- required_installed_hours

### Description

This table is generated by combining:

- Master Plan
- Lead Time Rules
- Routing Matrix

The result is the manufacturing workload required to satisfy future customer demand.

---

# Analytical Layer

## vw_capacity_vs_workload

### Purpose

Provides the final analytical dataset consumed by Power BI.

### Measures

- Manned Capacity
- Installed Capacity
- Manned Workload
- Installed Workload
- Manned Gap
- Installed Gap
- Manned Utilization
- Installed Utilization

### Description

The view consolidates workload and capacity information into a single analytical structure optimized for reporting and dashboard development.

---

# Data Flow

The analytical process follows the flow below:

Master Plan

↓

Internal Start Date Calculation

↓

Workload Generation

↓

Capacity Snapshot Calculation

↓

Capacity vs Workload Analysis

↓

Power BI Dashboard

---

# Table Relationship Overview

## fact_masterplan

Connected Dimensions:

- dim_project
- dim_product_type
- dim_stage
- dim_month

---

## fact_workload

Connected Dimensions:

- dim_project
- dim_product_type
- dim_stage
- dim_workcenter
- dim_month

---

## fact_capacity_snapshot

Connected Dimensions:

- dim_workcenter
- dim_month

---

# Analytical Granularity

The solution supports two analytical levels:

## Factory Level

Used for executive and long-term planning analysis.

Typical questions:

- Do we have enough capacity to support future demand?
- Which months present capacity shortages?
- How does utilization evolve over time?

## Work Center Level

Used for detailed capacity investigation.

Typical questions:

- Which Work Centers are overloaded?
- Which Work Centers are underutilized?
- Where are the manufacturing bottlenecks?

---

# Future Enhancements

Potential future improvements for the model include:

- Scenario Planning
- Overtime Simulation
- Additional Shift Scenarios
- Workforce Growth Projections
- Work Center Capacity Expansion Analysis
- Demand Growth Simulations
- Capacity Forecasting Models