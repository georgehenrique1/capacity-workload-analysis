# Capacity vs Workload Analysis

Portfolio project focused on manufacturing capacity planning using PostgreSQL and Power BI.

## Project Goal

Build an end-to-end analytical solution to compare future manufacturing workload against available factory capacity over a 12-month planning horizon.

The project replaces spreadsheet-based calculations with a structured Planning Engine capable of identifying capacity gaps, Work Center bottlenecks and the projects driving future workload.

---

## Dashboard Preview

### Management Overview

![image_alt](https://github.com/georgehenrique1/capacity-workload-analysis/blob/65d8c1e98d734166d0fef54b3157dfb63404a7ba/images/management_overview.png)

The Management Overview provides:

- Headcount and available capacity
- Required Manned and Installed Hours
- Capacity Gaps
- Manned and Installed Utilization
- Monthly Capacity vs Workload trends
- Work Center bottleneck heatmaps

### Operational Analysis

images/operational_analysis.png

The Operational Analysis provides:

- Active Projects
- Required Manned and Installed Workload
- Top Projects by Total Workload
- Planned Projects and Need Dates
- Project-level workload traceability

---

## Solution Architecture

The solution is divided into two layers.

### Planning Engine

The Planning Engine processes input snapshots, applies business rules and calculates workload and capacity.

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

The Analytics Layer combines monthly workload and capacity into a reporting view consumed by Power BI.

The final analytical layer supports:

- Capacity vs Workload analysis
- Manned and Installed Capacity analysis
- Capacity Gap analysis
- Work Center bottleneck identification
- Project-level workload traceability

---

## Architecture Diagrams

### Planning Engine Physical Model

images/planning_engine_physical_diagram.png

### Planning Engine Processing Flow

images/planning_engine_flow.png

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

### Utilization

Utilization is calculated in Power BI so that results respond correctly to Month and Work Center filters.

```text
Utilization =
SUM(Required Hours) / SUM(Available Capacity)
```

---

## Data Flow

### Workload

```text
Raw Master Plan
       ↓
Latest Master Plan
       ↓
Lead Time and Routing Rules
       ↓
Detailed Workload
       ↓
Monthly Workload
```

### Capacity

```text
Raw Roster
       ↓
Historical Roster Selection
       ↓
Detailed Capacity
       ↓
Monthly Capacity
```

### Reporting

```text
Monthly Workload
        +
Monthly Capacity
        ↓
Capacity vs Workload Analytics View
        ↓
Power BI Report
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
│   ├── management_overview.png
│   ├── operational_analysis.png
│   ├── planning_engine_flow.png
│   └── planning_engine_physical_diagram.png
├── powerbi/
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
└── README.MD
```

---

## Documentation

Detailed project documentation is available in the `docs/` folder:

- docs/01_business_problem.md
- docs/02_solution_overview.md
- docs/03_data_model.md
- docs/04_business_rules.md
- docs/05_kpis.md
- docs/06_development_log.md

---

## Project Status

- ✅ Business Problem Definition
- ✅ Solution Architecture
- ✅ PostgreSQL Physical Model
- ✅ Planning Engine
- ✅ Snapshot Control
- ✅ Workload and Capacity Engines
- ✅ Analytics Layer
- ✅ Architecture Documentation
- ✅ Power BI Dashboard
- ✅ Project Documentation

**Status: Completed**
