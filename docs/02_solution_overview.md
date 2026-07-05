# Solution Overview

## Solution Vision

The proposed solution replaces spreadsheet-based capacity planning calculations with a centralized analytical platform built on PostgreSQL and Power BI.

The solution transforms customer demand into manufacturing workload requirements and compares those requirements against available factory capacity.

The analysis is performed using a 12-month planning horizon with monthly granularity.

---

## Technology Stack

- PostgreSQL
- SQL
- Power BI
- Git
- GitHub

---

## High-Level Process Flow

Customer Master Plan
→ Internal Start Date Calculation
→ Workload Generation
→ Capacity Calculation
→ Capacity vs. Workload Analysis
→ Power BI Dashboard

---

## Input Data Sources

### Master Plan

The Master Plan contains:

- Project Number
- Product Type
- Production Stage
- Need Date

Each record represents an individual project requirement.

---

### Lead Time Rules

Defines how many days before the Need Date manufacturing activities must start.

The output of this process is the Internal Start Date used for workload allocation.

---

### Routing Matrix

Defines workload consumption for each combination of:

- Product Type
- Production Stage
- Work Center

The routing matrix contains both labor and machine requirements.

---

### Production List

Monthly workforce allocation provided by manufacturing leadership.

The production list contains:

- Operator ID
- Operator Name
- Work Center
- Shift

This information is used to calculate available labor capacity.

---

## Capacity Model

The solution evaluates two independent capacity dimensions:

### Manned Capacity

Available labor hours.

### Installed Capacity

Available machine hours.

Both capacities are compared against workload requirements generated from project demand.

---

## Planning Horizon

- 12 Months
- Monthly Granularity

The solution focuses on tactical and strategic planning rather than daily production scheduling.

---

## Analytical Outputs

The solution will provide:

- Capacity vs Workload analysis
- Capacity utilization trends
- Bottleneck identification
- Overload and underload analysis
- Factory-level visibility
- Work Center drilldown analysis
- Scenario comparison capabilities