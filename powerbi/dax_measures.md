# DAX Measures

This file contains the main DAX measures used in the Power BI dashboard for the **E-commerce Performance Analysis** project.

The measures are organized into three analytical areas:

- Financial Performance
- Marketing Campaign Performance
- Customer Retention

---

## 1. Financial Performance

These measures were used to analyze profit performance and compare March 2015 with March 2014.

### Revenue

Calculates total revenue from all orders.

```DAX
Revenue =
SUM('public orders'[price_usd])
```

### COGS

Calculates the total cost of goods sold.

```DAX
COGS =
SUM('public orders'[cogs_usd])
```

### Profit

Calculates profit as the difference between revenue and cost of goods sold.

```DAX
Profit =
[Revenue] - [COGS]
```

### Profit — March 2014

Calculates profit generated during March 2014.

```DAX
Profit Mar 2014 =
CALCULATE(
    [Profit],
    'public orders'[created_at] >= DATE(2014, 3, 1),
    'public orders'[created_at] < DATE(2014, 4, 1)
)
```

### Profit — March 2015

Calculates profit generated during March 2015.

```DAX
Profit Mar 2015 =
CALCULATE(
    [Profit],
    'public orders'[created_at] >= DATE(2015, 3, 1),
    'public orders'[created_at] < DATE(2015, 4, 1)
)
```

### Profit Change

Calculates the absolute change in profit between March 2014 and March 2015.

```DAX
Profit Change =
[Profit Mar 2015] - [Profit Mar 2014]
```

### Profit Change %

Calculates the percentage change in profit between March 2014 and March 2015.

```DAX
Profit Change % =
DIVIDE(
    [Profit Change],
    [Profit Mar 2014],
    0
)
```

---

## 2. Marketing Campaign Performance

These measures were used to compare the number of customers attracted through marketing campaigns with the number of customers who made a purchase.

### Campaign Visitors

Calculates the number of unique users who visited the website.

```DAX
Campaign Visitors =
DISTINCTCOUNT('public website_sessions'[user_id])
```

When this measure is used together with `utm_campaign` in a Power BI visual, it returns the number of unique visitors for each campaign.

### Campaign Buyers

Calculates the number of unique customers who placed an order.

```DAX
Campaign Buyers =
DISTINCTCOUNT('public orders'[user_id])
```

The relationship between `website_sessions` and `orders` allows the measure to be analyzed by marketing campaign.

### Campaign Conversion Rate

Calculates the percentage of campaign visitors who became buyers.

```DAX
Campaign Conversion Rate =
DIVIDE(
    [Campaign Buyers],
    [Campaign Visitors],
    0
)
```

---

## 3. Customer Retention

These measures were used to analyze repeat purchasing behavior.

### All Customers

Calculates the total number of unique customers who placed at least one order.

```DAX
All Customers =
DISTINCTCOUNT('public orders'[user_id])
```

### Repeat Customers

Calculates the number of customers who placed two or more orders.

```DAX
Repeat Customers =
COUNTROWS(
    FILTER(
        VALUES('public orders'[user_id]),
        CALCULATE(
            DISTINCTCOUNT('public orders'[order_id])
        ) >= 2
    )
)
```

### Repeat Customer Rate

Calculates the percentage of customers who placed two or more orders.

```DAX
Repeat Customer Rate =
DIVIDE(
    [Repeat Customers],
    [All Customers],
    0
)
```

---

## Key Power BI Results

The DAX measures produced the following key results:

| Metric | Result |
|---|---:|
| Profit — March 2014 | $43.07K |
| Profit — March 2015 | $50.03K |
| Profit Change | +$6.96K |
| Profit Change | +16.16% |
| Campaign Conversion Rate | 8.04% |
| All Customers | 31,696 |
| Repeat Customers | 591 |
| Repeat Customer Rate | 1.86% |

These measures were used to build the Power BI dashboard and reproduce the main results obtained during the SQL analysis.
