# Solution Overview

## Solution Vision

This project replaces spreadsheet-based capacity planning calculations with a centralized solution built using PostgreSQL and Power BI.

The solution converts customer demand into manufacturing workload and compares it against Manned and Installed Capacity over a 12-month planning horizon.

Its purpose is to provide visibility into future capacity constraints, manufacturing bottlenecks and the projects driving workload demand.

---

## Technology Stack

- PostgreSQL
- SQL
- Power BI
- Git
- GitHub

---

## Solution Architecture

The solution is divided into two layers.

### Planning Engine

The Planning Engine processes business rules and calculates workload and capacity.

Main components:

- Master Plan and Production Roster inputs
- Lead Time Rules
- Routing Matrix
- Snapshot Control
- Workload Engine
- Capacity Engine

Main outputs:

- Detailed and Monthly Workload
- Detailed and Monthly Capacity

### Analytics Layer

The Analytics Layer consolidates monthly workload and capacity into a reporting view consumed by Power BI.

The final analytical view provides:

- Headcount
- Required Manned and Installed Hours
- Available Manned and Installed Capacity
- Capacity Gaps
- Capacity Status

Utilization percentages are calculated as Power BI measures so they respond correctly to month and Work Center filters.

---

## High-Level Process Flow

```text
Master Plan + Production Roster
                ↓
        Snapshot Selection
                ↓
     Workload and Capacity Engines
                ↓
      Capacity vs Workload View
                ↓
        Power BI Dashboard
```

---

## Input Data

### Master Plan

Represents customer demand and contains:

- Project Number
- Project Name
- Product Type and Production Stage combination
- Need Date
- Reference Month

Workload calculations always use the latest available Master Plan.

### Production Roster

Represents workforce allocation and contains:

- Operator ID
- Operator Name
- Work Center
- Shift
- Reference Month

Roster snapshots are preserved so each analysis month uses the workforce assumptions available at that time.

---

## Workload Calculation

The Internal Start Date determines when workload enters the planning horizon.

```text
Internal Start Date = Need Date - Lead Time Days
```

The Routing Matrix then defines the Manned and Installed Hours required by each Product Type, Production Stage and Work Center combination.

Workload is available at two levels:

- Detailed by Project, Combination and Work Center
- Monthly by Analysis Month and Work Center

---

## Capacity Calculation

### Manned Capacity

Represents available labor hours based on:

- Headcount
- Shift work hours
- Breaks
- Efficiency
- Working days

```text
Manned Capacity =
Headcount × Net Shift Hours × Efficiency × Workdays
```

### Installed Capacity

Represents available equipment hours based on the daily installed capacity of each Work Center and the number of calendar days.

```text
Installed Capacity =
Daily Installed Capacity × Calendar Days
```

Capacity is calculated by Shift and then aggregated monthly by Work Center.

---

## Power BI Report

The report contains two pages.

### Management Overview

Provides:

- Manned and Installed Capacity KPIs
- Required Workload
- Capacity Gaps
- Utilization
- Monthly Capacity vs Workload trends
- Work Center bottleneck heatmaps

### Operational Analysis

Provides:

- Active Projects
- Required Manned and Installed Hours
- Top Projects by Total Workload
- Planned Projects and Need Dates
- Project-level workload traceability

---

## Planning Scope

- 12-month planning horizon
- Monthly analysis
- Factory and Work Center visibility
- Tactical and strategic planning

The solution is not intended for daily production scheduling or shop-floor control.