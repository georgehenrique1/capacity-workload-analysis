# KPIs

## Capacity

### Manned Capacity

Available labor hours calculated from Headcount, Shift Hours, Breaks, Efficiency and Workdays.

### Installed Capacity

Available equipment hours calculated from Daily Installed Capacity and Calendar Days.

---

## Workload

### Required Manned Hours

Labor hours required to support the latest Master Plan.

### Required Installed Hours

Equipment hours required to support the latest Master Plan.

---

## Utilization

Utilization is calculated in Power BI so it responds correctly to the current Month and Work Center filter context.

### Manned Utilization

```DAX
Manned Utilization % =
DIVIDE(
    SUM('analytics vw_capacity_workload'[required_manned_hours]),
    SUM('analytics vw_capacity_workload'[manned_capacity])
)
```

### Installed Utilization

```DAX
Installed Utilization % =
DIVIDE(
    SUM('analytics vw_capacity_workload'[required_installed_hours]),
    SUM('analytics vw_capacity_workload'[installed_capacity])
)
```

Classification:

```text
Below 85%   → Healthy
85% to 100% → Attention
Above 100%  → Overload
```

---

## Capacity Gap

```text
Capacity Gap =
Available Capacity - Required Workload
```

Interpretation:

```text
Positive → Available Capacity
Negative → Capacity Deficit
```

Manned and Installed Gaps are evaluated independently.

---

## Operational Indicators

### Headcount

Current workforce available in the latest visible analysis month.

### Active Projects

Distinct number of projects contributing workload in the selected period.

### Total Project Workload

Used to rank the main workload drivers:

```text
Required Manned Hours
+
Required Installed Hours
```