# Capacity Workload Analysis

Portfolio project focused on Capacity vs Workload analysis in a manufacturing environment.

## Project Goal

Build an end-to-end analytical solution using PostgreSQL and Power BI to evaluate future manufacturing demand against available factory capacity over a 12-month planning horizon.

The project simulates a real-world capacity planning process commonly managed through spreadsheets and transforms it into a structured data and analytics solution.

## Solution Overview

The solution is divided into two layers:

### Planning Engine

Responsible for applying business rules and generating:

- Monthly Workload
- Monthly Capacity

Main components:

- Master Plan
- Production Roster
- Lead Time Rules
- Routing Matrix

### Analytics Layer

Responsible for transforming planning outputs into a Star Schema optimized for Power BI reporting and analysis.

## Key Features

- Capacity vs Workload Analysis
- Manned Capacity Calculation
- Installed Capacity Calculation
- Internal Start Date Calculation
- Work Center Analysis
- Bottleneck Identification
- Project-Level Workload Traceability
- Capacity Gap Analysis

## Technology Stack

- PostgreSQL
- SQL
- Power BI
- Git
- GitHub

## Project Structure

```text
docs/
├── 01_business_problem.md
├── 02_solution_overview.md
├── 03_data_model.md
├── 04_business_rules.md
├── 05_kpis.md
├── 06_development_log.md

planning_engine.dbml
```

## Current Status

✅ Business Problem Definition

✅ Solution Architecture

✅ Planning Engine Data Model

✅ Business Rules Documentation

⬜ PostgreSQL Physical Model

⬜ Data Generation

⬜ Analytics Layer (Star Schema)

⬜ Power BI Dashboard