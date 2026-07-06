# Solution Overview

## Solution Vision

This project aims to replace spreadsheet-based capacity planning calculations with a centralized analytical solution built using PostgreSQL and Power BI.

The solution converts customer demand into manufacturing workload requirements and compares those requirements against available factory capacity over a 12-month planning horizon.

The goal is to provide visibility into future bottlenecks, capacity shortages, and workload distribution across the manufacturing network.

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

Responsible for processing business rules and generating workload and capacity calculations.

Main components:

- Master Plan
- Production Roster
- Lead Time Rules
- Routing Matrix
- Workload Engine
- Capacity Engine

Outputs:

- Monthly Workload
- Monthly Capacity

### Analytics Layer

Responsible for analytical consumption and reporting.

This layer will follow a Star Schema design and will be used by Power BI for reporting and KPI calculation.

---

## High-Level Process Flow

Customer Master Plan

↓

Internal Start Date Calculation

↓

Workload Generation

↓

Capacity Calculation

↓

Analytics Layer

↓

Power BI Dashboard

---

## Input Data Sources

### Master Plan

Contains:

- Project Number
- Project Name
- Product Type
- Production Stage
- Need Date

The Master Plan represents future customer demand and serves as the starting point for all workload calculations.

### Production Roster

Contains:

- Operator ID
- Operator Name
- Work Center
- Shift

Used to calculate available labor capacity.

---

## Business Rules

### Lead Time Rules

Used to calculate the Internal Start Date for each project stage.

Formula:

```text
Internal Start Date = Need Date - Lead Time Days
```

### Routing Matrix

Defines workload consumption for each combination of:

- Product Type
- Production Stage
- Work Center

The matrix stores:

- Required Manned Hours
- Required Installed Hours

---

## Capacity Model

The solution evaluates two independent capacity dimensions.

### Manned Capacity

Available labor hours based on workforce allocation, shift structure, working days and efficiency factors.

### Installed Capacity

Available machine hours based on installed factory capacity.

For simplification purposes, all Work Centers use a fixed daily installed capacity.

---

## Planning Horizon

- 12 Months
- Monthly Granularity

The solution is intended for tactical and strategic planning, not detailed production scheduling.

---

## Expected Outputs

The solution will provide:

- Capacity vs. Workload Analysis
- Capacity Utilization Trends
- Bottleneck Identification
- Capacity Gap Analysis
- Factory-Level Visibility
- Work Center Analysis
- Project-Level Workload Traceability
- Scenario Comparison Capabilities