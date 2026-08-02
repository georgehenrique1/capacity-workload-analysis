# Business Problem

## Context

Manufacturing organizations need to balance future production demand against available labor and equipment capacity.

As project volume and product complexity increase, spreadsheet-based planning becomes difficult to scale, maintain and audit. This limits visibility into future workload, capacity constraints and manufacturing bottlenecks.

---

## Problem Statement

The goal of this project is to build a centralized Capacity vs Workload solution using PostgreSQL and Power BI.

The solution compares future manufacturing workload against two capacity dimensions:

- Manned Capacity
- Installed Capacity

The analysis covers a 12-month planning horizon and supports tactical and strategic manufacturing decisions.

---

## Current Process

The planning process begins with a customer Master Plan containing project requirements, Product Types, Production Stages and Need Dates.

Business rules are applied to determine:

- When manufacturing activities should start
- Which Work Centers will be impacted
- How much manned and installed workload will be generated
- Whether available capacity is sufficient to support future demand

The current spreadsheet-based process requires manual calculations and provides limited traceability and scalability.

---

## Planning Challenges

The main challenges are:

- High dependency on manual calculations
- Limited visibility into future capacity constraints
- Difficulty identifying bottlenecks by month and Work Center
- Limited workload traceability at project level
- Lack of historical workforce tracking
- Decentralized planning information

---

## Planning Assumptions

Workload calculations always use the latest available Master Plan, ensuring that future demand reflects the most recent customer forecast.

Capacity calculations preserve historical workforce assumptions. For each analysis month, the solution uses the latest Roster snapshot available up to that month.

This allows the model to compare current demand expectations against the workforce capacity available throughout the planning horizon.

---

## Expected Business Outcomes

The solution should answer:

- Is available capacity sufficient to support future demand?
- Which months present capacity shortages?
- Which Work Centers are overloaded or underutilized?
- Is the constraint related to Manned or Installed Capacity?
- How do workload, capacity and headcount evolve over time?
- Which projects are the main workload drivers?
- Which projects contribute to future bottlenecks?

The expected outcome is a more structured, scalable and data-driven manufacturing planning process.