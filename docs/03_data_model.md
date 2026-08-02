# Data Model

## Overview

The solution is divided into two layers:

- Planning Engine
- Analytics Layer

The Planning Engine stores inputs, applies business rules and calculates workload and capacity.

The Analytics Layer consolidates these results into a reporting structure consumed by Power BI.

---

## Planning Engine

The Planning Engine follows a Snowflake-style model designed for calculation logic, input history and business rule management.

### Input Tables

#### raw_masterplan

Stores historical customer demand snapshots.

Main fields:

- Project Number
- Project Name
- Combination ID
- Need Date
- Reference Month

Workload calculations always use the latest available Master Plan.

#### raw_roster

Stores historical workforce snapshots.

Main fields:

- Operator ID
- Operator Name
- Work Center
- Shift
- Reference Month

Roster history is preserved so each analysis month reflects the workforce available at that time.

---

## Master Data

The Planning Engine contains the following dimensions:

- `dim_product_type`
- `dim_production_stage`
- `dim_combination`
- `dim_workcenter`
- `dim_shift`
- `dim_date`

The `dim_combination` table represents:

```text
Product Type
+
Production Stage
```

It connects the Master Plan with Lead Time Rules and Routing Hours.

The date dimension provides calendar, workday, holiday and month-year attributes used by PostgreSQL and Power BI.

---

## Business Rules

### leadtime_rules

Defines when manufacturing activities should begin.

```text
Internal Start Date =
Need Date - Lead Time Days
```

### routing_hours

Defines the Manned and Installed Hours required by each Combination and Work Center.

Grain:

```text
Combination
+
Work Center
```

---

## Snapshot Logic

### vw_latest_masterplan

Returns the latest available Master Plan:

```text
MAX(reference_month)
```

This ensures that workload reflects the most recent customer forecast.

### vw_actual_roster

Returns the valid Roster snapshot for each analysis month:

```text
MAX(reference_month) <= analysis_month
```

This preserves historical workforce assumptions and keeps each snapshot valid until a newer version becomes available.

---

## Workload Engine

### vw_detailed_workload

Calculates workload using the latest Master Plan, Lead Time Rules and Routing Hours.

Grain:

```text
Project
+
Combination
+
Work Center
```

Measures:

- Required Manned Hours
- Required Installed Hours

This view preserves project-level traceability.

### vw_monthly_workload

Aggregates workload for monthly capacity comparison.

Grain:

```text
Analysis Month
+
Work Center
```

---

## Capacity Engine

### vw_detailed_capacity

Calculates capacity at Shift level.

Grain:

```text
Analysis Month
+
Work Center
+
Shift
```

Manned Capacity:

```text
Headcount
× Net Shift Hours
× Efficiency
× Workdays
```

Installed Capacity:

```text
Daily Installed Capacity
× Calendar Days
```

### vw_monthly_capacity

Aggregates capacity to:

```text
Analysis Month
+
Work Center
```

Measures:

- Headcount
- Manned Capacity
- Installed Capacity

---

## Analytics Layer

### analytics.vw_capacity_workload

This is the main analytical view used by the Power BI Management Overview.

It combines Monthly Capacity and Monthly Workload by:

```text
Analysis Month
+
Work Center
```

Main outputs:

- Headcount
- Manned and Installed Capacity
- Required Manned and Installed Hours
- Capacity Gaps
- Capacity Status
- Workdays and Total Days

Months without workload are preserved, with missing workload values treated as zero.

Utilization percentages are calculated in Power BI so they respond correctly to the current filter context:

```text
Utilization =
SUM(Required Hours) / SUM(Available Capacity)
```

---

## Power BI Model

Power BI consumes:

- `analytics.vw_capacity_workload`
- `planning_engine.vw_detailed_workload`
- `planning_engine.vw_detailed_capacity`
- `planning_engine.dim_date`
- `planning_engine.dim_workcenter`
- `planning_engine.dim_shift`

The model supports two report levels:

### Management Overview

- Capacity vs Workload
- Manned and Installed Utilization
- Capacity Gaps
- Monthly Trends
- Work Center Bottlenecks

### Operational Analysis

- Active Projects
- Top Projects by Total Workload
- Planned Projects and Need Dates
- Project-level Manned and Installed Workload

---

## Data Flow

```text
raw_masterplan
    ↓
vw_latest_masterplan
    ↓
vw_detailed_workload
    ↓
vw_monthly_workload
    ↓
analytics.vw_capacity_workload
```

```text
raw_roster
    ↓
vw_actual_roster
    ↓
vw_detailed_capacity
    ↓
vw_monthly_capacity
    ↓
analytics.vw_capacity_workload
```

---

## Key Design Decisions

- Calculation logic remains in PostgreSQL.
- Utilization is calculated in Power BI to respect filter context.
- Workload uses the latest customer forecast.
- Capacity preserves historical workforce snapshots.
- Manned and Installed Capacity are analyzed independently.
- Detailed workload supports project-level traceability.