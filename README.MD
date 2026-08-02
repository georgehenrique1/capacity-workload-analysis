# Capacity vs Workload Analysis

Portfolio project focused on manufacturing capacity planning using PostgreSQL and Power BI.

## Project Goal

Build an end-to-end analytical solution to compare future manufacturing workload against available factory capacity over a 12-month planning horizon.

The project replaces spreadsheet-based calculations with a structured Planning Engine capable of identifying capacity gaps, Work Center bottlenecks and the projects driving future workload.

---

## Solution Architecture

The solution is divided into two layers.

### Planning Engine

Processes input snapshots, applies business rules and calculates workload and capacity.

Main components:

- Master Plan and Production Roster
- Lead Time Rules
- Routing Matrix
- Snapshot Control
- Workload Engine
- Capacity Engine

Main outputs:

- Detailed and Monthly Workload
- Detailed and Monthly Capacity

### Analytics Layer

Combines monthly workload and capacity into a reporting view consumed by Power BI.

The final analytical layer supports:

- Capacity vs Workload analysis
- Manned and Installed Capacity analysis
- Work Center bottleneck identification
- Capacity Gap analysis
- Project-level workload traceability

---

## Key Business Rules

### Workload

Workload calculations always use the latest available Master Plan.

```text
Internal Start Date =
Need Date - Lead Time Days
```

Routing Hours determine the Manned and Installed workload generated at each Work Center.

### Capacity

Capacity calculations preserve historical workforce assumptions.

For each analysis month, the model uses the latest Roster snapshot available up to that month:

```text
MAX(reference_month) <= analysis_month
```

Manned and Installed Capacity are calculated and analyzed independently.

---

## Power BI Report

The report contains two pages.

### Management Overview

Provides:

- Headcount
- Manned and Installed Capacity
- Required Manned and Installed Hours
- Capacity Gaps
- Utilization KPIs
- Monthly Capacity vs Workload trends
- Work Center utilization heatmaps

### Operational Analysis

Provides:

- Active Projects
- Required Manned and Installed Workload
- Top Projects by Total Workload
- Planned Projects and Need Dates
- Project-level workload traceability

---

## Dashboard Preview

### Management Overview

powerbi/management_overview.png

### Operational Analysis

powerbi/operational_analysis.png

---

## Technology Stack

- PostgreSQL
- SQL
- Power BI
- DAX
- Git
- GitHub
- DBML

---

## Project Structure

```text
CAPACITY_WORKLOAD_ANALYSIS/
├── docs/
│   ├── 01_business_problem.md
│   ├── 02_solution_overview.md
│   ├── 03_data_model.md
│   ├── 04_business_rules.md
│   ├── 05_kpis.md
│   └── 06_development_log.md
├── images/
│   ├── planning_engine_flow.png
│   └── planning_engine_physical_diagram.png
├── powerbi/
│   ├── capacity_workload_analysis.pbix
│   ├── management_overview.png
│   └── operational_analysis.png
├── sql/
│   ├── 01_data/
│   │   ├── history_raw_masterplan/
│   │   │   ├── raw_masterplan_012026.csv
│   │   │   ├── raw_masterplan_042026.csv
│   │   │   └── raw_masterplan_062026.csv
│   │   └── history_raw_roster/
│   │       ├── raw_roster_012026.csv
│   │       ├── raw_roster_042026.csv
│   │       └── raw_roster_062026.csv
│   ├── 02_planning_engine/
│   │   ├── 01_create_schema.sql
│   │   ├── 02_dimensions.sql
│   │   ├── 03_business_rules.sql
│   │   ├── 04_input_tables.sql
│   │   ├── 05_snapshot_views.sql
│   │   └── 06_workload_capacity_engine.sql
│   └── 03_analytics/
│       └── 07_capacity_vs_workload.sql
└── README.md
```

---

## Key Features

- Capacity vs Workload Analysis
- Manned Capacity Calculation
- Installed Capacity Calculation
- Historical Workforce Snapshots
- Latest Master Plan Forecast
- Internal Start Date Calculation
- Capacity Gap Analysis
- Work Center Bottleneck Identification
- Project-Level Workload Traceability
- Context-aware utilization measures in Power BI

---

## Documentation

Additional project documentation is available in the docs/ folder:

- docs/01_business_problem.md
- docs/02_solution_overview.md
- docs/03_data_model.md
- docs/04_business_rules.md
- docs/05_kpis.md
- docs/06_development_log.md

---

## Project Status

✅ Business Problem Definition  
✅ Solution Architecture  
✅ PostgreSQL Physical Model  
✅ Planning Engine  
✅ Snapshot Control  
✅ Workload and Capacity Engines  
✅ Analytics Layer  
✅ DBML Documentation  
✅ Power BI Dashboard  
✅ Project Documentation  

**Status: Completed**